classdef ZDT4_RC

    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2022 Yanchi Li. You are free to use the MTO-Platform for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "MTO-Platform" and cite
    % or footnote "https://github.com/intLyc/MTO-Platform"
    %--------------------------------------------------------------------------

    methods (Static)
        function [Obj, Con] = getFnc(x, M)
            D = length(x);
            y = (M * x(2:end)')';
            gx = 1 + 10 * (D - 1) + sum(y .* y - 10 * cos(4 * pi * y));
            Obj(1) = x(1);
            Obj(2) = gx * (1 - sqrt(x(1) / gx));

            theta = -0.05 * pi;
            a = 40; b = 5; c = 1; d = 6; e = 0;
            Con = (a * abs(sin(b * pi * (sin(theta) * (Obj(2) - e) + ...
                cos(theta) * Obj(1))^c))^d) - cos(theta) * (Obj(2) - e) + sin(theta) * Obj(1);
            Con(Con < 0) = 0;
        end

        function Optimum = getOptimum(N)
            Optimum(:, 1) = linspace(0, 1, N)';
            Optimum(:, 2) = 1 - Optimum(:, 1).^0.5;
        end
    end
end
