function result = FR(MTOData, varargin)
    % <Metric>

    % Feasible Rate

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    result.Metric = 'Max';
    result.RowName = {};
    result.ColumnName = {};
    % Data for Table
    result.TableData = [];
    
    row = 1;
    for prob = 1:length(MTOData.Problems)
        if MTOData.Problems(prob).M ~= 1
            return;
        end
        tnum = MTOData.Problems(prob).T;
        for task = 1:tnum
            if tnum == 1
                result.RowName{row} = MTOData.Problems(prob).Name;
            else
                result.RowName{row} = [MTOData.Problems(prob).Name, '-T', num2str(task)];
            end
            row = row + 1;
        end
    end
    result.ColumnName = {MTOData.Algorithms.Name};

    % Calculate Feasible Rate
    row = 1;
    for prob = 1:length(MTOData.Problems)
        for task = 1:MTOData.Problems(prob).T
            for algo = 1:length(MTOData.Algorithms)
                CV = zeros(1, MTOData.Reps);
                for rep = 1:MTOData.Reps
                    CV(rep) = MTOData.Results(prob, algo, rep).CV(task, end);
                end
                result.TableData(row, algo, :) = sum(CV <= 0) / MTOData.Reps;
            end
            row = row + 1;
        end
    end
end
