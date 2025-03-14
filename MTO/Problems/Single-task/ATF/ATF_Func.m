function [Obj, Con] = ATF_Func(var, problem)

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    dim = length(var);
    Obj = 10 * dim;
    for i = 1:dim
        Obj = Obj + (var(i)^2 - 10 * (cos(2 * pi * var(i))));
    end
    switch problem
        case 1
            Con = var(1)^2/4 + var(2)^2/9 -1;
        case 2
            Con = 3 * (var(1) + 9)^2 + var(2)^2 - 2;
    end
    Con(Con < 0) = 0;
end
