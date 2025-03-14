classdef DE < Algorithm
    % <Single-task> <Single-objective> <None/Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    properties (SetAccess = private)
        F = 0.5
        CR = 0.9
    end

    methods
        function Parameter = getParameter(Algo)
            Parameter = {'F: Mutation Factor', num2str(Algo.F), ...
                        'CR: Crossover Rate', num2str(Algo.CR)};
        end

        function Algo = setParameter(Algo, Parameter)
            i = 1;
            Algo.F = str2double(Parameter{i}); i = i + 1;
            Algo.CR = str2double(Parameter{i}); i = i + 1;
        end

        function run(Algo, Prob)
            % Initialization
            population = Initialization(Algo, Prob, Individual);

            while Algo.notTerminated(Prob)
                for t = 1:Prob.T
                    % Generation
                    offspring = Algo.Generation(population{t});
                    % Evaluation
                    offspring = Algo.Evaluation(offspring, Prob, t);
                    % Selection
                    population{t} = Selection_Tournament(population{t}, offspring);
                end
            end
        end

        function offspring = Generation(Algo, population)
            for i = 1:length(population)
                offspring(i) = population(i);
                A = randperm(length(population), 4);
                A(A == i) = []; x1 = A(1); x2 = A(2); x3 = A(3);

                offspring(i).Dec = population(x1).Dec + Algo.F * (population(x2).Dec - population(x3).Dec);
                offspring(i).Dec = DE_Crossover(offspring(i).Dec, population(i).Dec, Algo.CR);

                offspring(i).Dec(offspring(i).Dec > 1) = 1;
                offspring(i).Dec(offspring(i).Dec < 0) = 0;
            end
        end
    end
end
