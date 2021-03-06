function stop = save_current_solution(x,~,~,fixed_parameters)

% Use a persistent variable to keep track of the number of iterations
persistent iter
if isempty(iter)
    iter = 0;
end
iter = iter+1;

% Evaluate the cycle model for the current vector of independent variables
fixed_parameters.calc_detail = 'short';
cycle_data = evaluate_rankine_cycle(x,fixed_parameters);

% Save the current solution as a MATLAB data structure
save(fullfile(fixed_parameters.results_path,['cycle_data_', num2str(iter), '.mat']),'cycle_data')

% Return a false stop flag
stop = false;

end