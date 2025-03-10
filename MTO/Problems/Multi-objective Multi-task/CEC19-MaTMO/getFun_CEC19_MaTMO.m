function [Obj, Con] = getFun_CEC19_MaTMO(x, Problem, shiftVector, rotationMatrix, boundaryCvDv, gType, f1Type, hType, Lb, Ub)
    switch Problem
        case {2, 3, 5} %ZDT
            f1 = evalF1(x(1:boundaryCvDv), f1Type);
            g = evalGfunction(shiftVector, rotationMatrix, x(boundaryCvDv + 1:end), gType, Lb(boundaryCvDv + 1:end), Ub(boundaryCvDv + 1:end));
            g = g + 1;
            f2 = g * evalH(f1, g, hType);
        otherwise % DTLZ
            g = evalGfunction(shiftVector, rotationMatrix, x(boundaryCvDv + 1:end), gType, Lb(boundaryCvDv + 1:end), Ub(boundaryCvDv + 1:end));
            f1 = (1 + g) * cos(x(1) * 0.5 * pi);
            f2 = (1 + g) * sin(x(1) * 0.5 * pi);
    end

    Obj = [f1, f2];
    Con = 0;
end

function Gfunction = evalGfunction(shiftVector, rotationMatrix, x, gType, Lb, Ub)
    x = x * rotationMatrix;
    x = x - shiftVector;
    % Check Boundary
    x(x < Lb) = Lb(x < Lb);
    x(x > Ub) = Ub(x > Ub);
    switch gType
        case 'Sphere'
            Gfunction = sum(x.^2);
        case 'Rosenbrock'
            t = 0;
            for i = 1:length(x) - 1
                t = t + 100 * (x(i)^2 - x(i + 1))^2 + (1 - x(i)^2);
            end
            Gfunction = t;
        case 'Ackley'
            sum1 = sum(x.^2) / length(x);
            sum2 = sum(cos(2 * pi .* x) ./ length(x));
            Gfunction = -20 * exp(-0.2 * sqrt(sum1)) - exp(sum2) + 20 +exp(1);
        case 'Griewank'
            t = sqrt([1:length(x)]);
            sum1 = sum(x.^2);
            prod1 = prod(cos(x ./ t));
            Gfunction = 1 + sum1 / 4000 - prod1;
        case 'Rastrigin'
            a = 10 * length(x);
            Gfunction = sum(x.^2 - 10 .* cos(2 * pi .* x)) + a;
        case 'Mean'
            a = abs(x);
            Gfunction = sum(a) / length(x);
            Gfunction = 9 * Gfunction;
    end
end

function F1Function = evalF1(x, f1Type)
    if strcmp(f1Type, 'linear')
        A = sum(x);
        F1Function = A / length(x);
    else
        A = sum(x.^2);
        F1Function = sqrt(sum(A));
    end
end

function Hfunction = evalH(F1Function, Gfunction, hType)
    if strcmp(hType, 'convex')
        Hfunction = 1 - sqrt((F1Function / Gfunction));
    else
        Hfunction = 1 - (F1Function / Gfunction)^2;
    end
end
