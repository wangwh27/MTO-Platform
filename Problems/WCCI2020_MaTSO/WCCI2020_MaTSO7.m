classdef WCCI2020_MaTSO7 < Problem

    properties
        task_size = 5;
        dims = 50;
    end

    methods
        function parameter = getParameter(obj)
            parameter = {'Task Size', num2str(obj.task_size), ...
                        'Dims', num2str(obj.dims)};
        end

        function obj = setParameter(obj, parameter_cell)
            count = 1;
            obj.task_size = str2num(parameter_cell{count}); count = count + 1;
            obj.dims = str2num(parameter_cell{count}); count = count + 1;
        end

        function Tasks = getTasks(obj)
            Tasks = benchmark_WCCI2020_MaTSO(7, obj.task_size, obj.dims);
        end

    end

end
