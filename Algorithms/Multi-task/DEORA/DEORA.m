classdef DEORA < Algorithm
    % <Multi> <Competitive>

    %------------------------------- Reference --------------------------------
    % @Article{Li2022CompetitiveMTO,
    %   author     = {Li, Genghui and Zhang, Qingfu and Wang, Zhenkun},
    %   journal    = {IEEE Transactions on Evolutionary Computation},
    %   title      = {Evolutionary Competitive Multitasking Optimization},
    %   year       = {2022},
    %   pages      = {1-1},
    %   doi        = {10.1109/TEVC.2022.3141819},
    % }
    %--------------------------------------------------------------------------

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        F = 0.5
        CR = 0.9
        alpha = 0.5
        beta = 0.2
        gama = 0.85
        prob_min = 0.1
        rmp0 = 0.3
    end

    methods
        function Parameter = getParameter(obj)
            Parameter = {'F: Mutation Factor', num2str(obj.F), ...
                        'CR: Crossover Probability', num2str(obj.CR), ...
                        'alpha', num2str(obj.alpha), ...
                        'beta', num2str(obj.beta), ...
                        'gama', num2str(obj.gama), ...
                        'prob_min: Minimum selection probability', num2str(obj.prob_min), ...
                        'rmp0: Initial random mating probability', num2str(obj.rmp0)};
        end

        function obj = setParameter(obj, Parameter)
            i = 1;
            obj.F = str2double(Parameter{i}); i = i + 1;
            obj.CR = str2double(Parameter{i}); i = i + 1;
            obj.alpha = str2double(Parameter{i}); i = i + 1;
            obj.beta = str2double(Parameter{i}); i = i + 1;
            obj.gama = str2double(Parameter{i}); i = i + 1;
            obj.prob_min = str2double(Parameter{i}); i = i + 1;
            obj.rmp0 = str2double(Parameter{i}); i = i + 1;
        end

        function data = run(obj, Tasks, RunPara)
            sub_pop = RunPara(1); sub_eva = RunPara(2);
            eva_num = sub_eva * length(Tasks);

            HR = []; % HR is used to store the historical rewards
            gen = (eva_num - sub_pop * length(Tasks)) / sub_pop + 1;
            T = obj.beta * gen;
            delta_rmp = 1 / gen;
            rmp = obj.rmp0 * ones(length(Tasks), length(Tasks)) / (length(Tasks) - 1);
            rmp(logical(eye(size(rmp)))) = (1 - obj.rmp0);

            % initialize
            [population, fnceval_calls, bestobj, bestX] = initializeMT(Individual, sub_pop, Tasks, max([Tasks.dims]) * ones(1, length(Tasks)));
            convergence(:, 1) = bestobj;

            generation = 1;
            while fnceval_calls < eva_num
                generation = generation + 1;

                % Select the k-th task to optimize
                if generation <= T
                    k = unidrnd(length(Tasks));
                else
                    weights = obj.gama.^(generation - 3:-1:0);
                    sum_weights = sum(weights);
                    for t = 1:length(Tasks)
                        mean_R(t) = sum(weights .* HR(t, :)) / sum_weights;
                    end
                    % The selection probability
                    prob(generation, :) = obj.prob_min / length(Tasks) + (1 - obj.prob_min) * mean_R ./ (sum(mean_R));
                    % Determine the a task based on the selection probability using roulette wheel method
                    r = rand;
                    for t = 1:length(Tasks)
                        if r <= sum(prob(generation, 1:t))
                            k = t;
                            break;
                        end
                    end
                end

                % generate for the selected task
                [offspring, r1_task, calls] = OperatorDEORA.generate(population, Tasks, k, rmp, obj.F, obj.CR);
                fnceval_calls = fnceval_calls + calls;

                % selection
                fit_old = [population{k}.factorial_costs];
                replace = [population{k}.factorial_costs] > [offspring.factorial_costs];
                population{k}(replace) = offspring(replace);
                fit_new = [population{k}.factorial_costs];

                % calculate the reward
                R_p = max((fit_old - fit_new) ./ (fit_old), 0);
                R_b = max((min(bestobj) - min(fit_new)) / min(bestobj), 0);
                R = zeros(length(Tasks), 1);
                for t = 1:length(Tasks)
                    if t == k %The main task
                        R(t) = obj.alpha * R_b + (1 - obj.alpha) * (sum(R_p) / length(R_p));
                    else % The auxiliary task
                        index = find(r1_task == t);
                        if isempty(index)
                            R(t) = 0;
                        else
                            [~, minid] = min(fit_new);
                            R(t) = obj.alpha * (r1_task(minid) == t) * R_b + (1 - obj.alpha) * (sum(R_p(index)) / length(index));
                        end
                    end
                end
                HR = [HR, R];

                % update rmp
                for t = 1:length(Tasks)
                    if t == k
                        continue;
                    end
                    if R(t) >= R(k)
                        rmp(k, t) = min(rmp(k, t) + delta_rmp, 1);
                        rmp(k, k) = max(rmp(k, k) - delta_rmp, 0);
                    else
                        rmp(k, t) = max(rmp(k, t) - delta_rmp, 0);
                        rmp(k, k) = min(rmp(k, k) + delta_rmp, 1);
                    end
                end

                [bestobj_now, idx] = min([population{k}.factorial_costs]);
                if bestobj_now < bestobj(k)
                    bestobj(k) = bestobj_now;
                    bestX{k} = population{k}(idx).rnvec;
                end
                convergence(:, generation) = convergence(:, generation - 1);
                convergence(k, generation) = bestobj(k);
            end
            data.convergence = gen2eva(convergence);
            data.bestX = uni2real(bestX, Tasks);
        end
    end
end
