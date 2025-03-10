function [Obj, Con] = Weierstrass(var, M, opt, g)
    % WEIERSTASS function
    %   - var: design variable vector
    %   - M: rotation matrix
    %   - opt: shift vector
    %   - g: Objective value move

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    D = length(var);
    var = (M * (var - opt)')';
    a = 0.5;
    b = 3;
    kmax = 20;
    Obj = 0;

    for i = 1:D

        for k = 0:kmax
            Obj = Obj + a^k * cos(2 * pi * b^k * (var(i) + 0.5));
        end

    end

    for k = 0:kmax
        Obj = Obj - D * a^k * cos(2 * pi * b^k * 0.5);
    end
    Obj = Obj + g;

    Con = 0;
end
