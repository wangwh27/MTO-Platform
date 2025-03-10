function Result = gen2eva(Result_Gen, FE_Gen, maxGen)
    %% Map the convergence from generation to evaluation
    % Input: Result_Gen, FE_Gen, maxGen
    % Output: Result

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    if length(Result_Gen) <= maxGen
        maxGen = length(Result_Gen);
    end

    Result = Result_Gen(:, 1:maxGen);
    for k = 1:size(Result_Gen, 1)
        Gap = FE_Gen(end) ./ (maxGen);
        idx = 1;
        i = 1;
        while i <= length(FE_Gen)
            if FE_Gen(i) >= ((idx) * Gap)
                Result(k, idx) = Result_Gen(k, i);
                idx = idx + 1;
            else
                i = i + 1;
            end
            if idx > maxGen
                break;
            end
        end
        Result(k, 1) = Result_Gen(k, 1);
        Result(k, end) = Result_Gen(k, end);
        if idx - 1 < length(maxGen)
            Result(k, idx - 1:end) = Result_Gen(k, end);
        end
    end
end
