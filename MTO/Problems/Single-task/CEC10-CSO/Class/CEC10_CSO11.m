classdef CEC10_CSO11 < Problem
    % <ST-SO> <Constrained>

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods
        function obj = CEC10_CSO11(varargin)
            obj = obj@Problem(varargin);
            obj.maxFE = 20000 * obj.D;
        end

        function Parameter = getParameter(obj)
            Parameter = {'Dim', num2str(obj.D)};
            Parameter = [obj.getRunParameter(), Parameter];
        end

        function obj = setParameter(obj, Parameter)
            D = str2double(Parameter{3});
            if D ~= 10 && D ~= 30
                [~, idx] = min([abs(D - 10), abs(D - 30)]);
                if idx == 1
                    D = 10;
                else
                    D = 30;
                end
            end
            if obj.D == D
                obj.setRunParameter(Parameter(1:2));
            else
                obj.D = D;
                obj.maxFE = 20000 * obj.D;
                obj.setRunParameter({Parameter{1}, num2str(obj.maxFE)});
            end
        end

        function setTasks(obj)
            if isempty(obj.D)
                D = obj.defaultD;
                if D ~= 10 && D ~= 30
                    [~, idx] = min([abs(D - 10), abs(D - 30)]);
                    if idx == 1
                        D = 10;
                    else
                        D = 30;
                    end
                end
                obj.D = D;
            end

            Tasks(1) = benchmark_CEC10_CSO(11, obj.D);
            obj.T = 1;
            obj.D(1) = Tasks(1).Dim;
            obj.Fnc{1} = Tasks(1).Fnc;
            obj.Lb{1} = Tasks(1).Lb;
            obj.Ub{1} = Tasks(1).Ub;
        end
    end
end
