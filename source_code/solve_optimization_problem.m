function [cycle_data,x_opt,f_opt,exitflag,output,lambda] = solve_optimization_problem(fixed_parameters,optimization_problem)

% This function is used to have a temporal storage of the objective
% function and the constraints and avoid the evaluation of the whole
% turbine each time the objective function or the constraints are required
% (this function might look complex, but it is just a trick to speed the
% optimization speed by a factor of 2)

x_last   = []; % Degrees of freedom in the last computation
f_bis    = []; % Objective function in storage
c_bis    = []; % Nonlinear inequality constraints in storage
c_eq_bis = []; % Nonlinear equality constraints in storage

% Objective function and nonlinear constraints functions (nested below)
fixed_parameters.calc_detail = 'short';
optimization_problem.objective = @(x) evaluate_objective_function(x,fixed_parameters);
optimization_problem.nonlcon   = @(x) evaluate_constraints(x,fixed_parameters);

% Use fmincon to solve the optimization problem
[x_opt,f_opt,exitflag,output,lambda] = fmincon(optimization_problem);
cycle_data = evaluate_optimization_problem(x_opt,fixed_parameters);

    function f = evaluate_objective_function(x,fixed_parameters)
        if ~isequal(x,x_last)      % Check if computation is necessary
           [~, f_bis,c_bis,c_eq_bis] = evaluate_optimization_problem(x,fixed_parameters);
            x_last = x;
        end
        f = f_bis;        
    end

    function [c, c_eq] = evaluate_constraints(x,fixed_parameters)
        if ~isequal(x,x_last)      % Check if computation is necessary
            [~, f_bis,c_bis,c_eq_bis] = evaluate_optimization_problem(x,fixed_parameters);
            x_last = x;
        end
        c = c_bis;
        c_eq = c_eq_bis;          
    end


end

