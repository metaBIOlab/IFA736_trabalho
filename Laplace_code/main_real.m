clear;
addpath('src');

%% Setting parameters
n = 1;                                                                     % Parameter that scales the resolution of the matrix
h = 0.01;                                                                  % Step size for integration for the path integral used to calculate the thickness
eps_limit = 1e-7;                                                          % Limit criterio to stop laplace's iterations (Variation of energy)
pout = 250;                                                                % Potential of the external trace
pint = 50;                                                                 % Potential of the internal trace
penv = 10;
pMean = pint + (pout-pint)/2;                                              % Potential of the contour that is in the middle of both traces

folder_data = strcat('.', filesep, 'data', filesep, 'real', filesep);      % Folder with the database

%% Main code

out_table = table();

file_path_int = [folder_data filesep 'in_cerebelo.csv'];
file_path_out = [folder_data filesep 'out_cerebelo.csv'];
file_path_env = [folder_data filesep 'e_cerebelo.csv'];

name = 'cerebelo_real';

tint_xy = readmatrix(file_path_int);
tout_xy = readmatrix(file_path_out);
tenv_xy = readmatrix(file_path_env);

min_xy = min(tenv_xy);
max_xy = max(tenv_xy);


[M, tout, tint] = initialize_trace_pixel(tout_xy, tint_xy, pout, pint);

N = size(tint, 1);

tenv = initialize_trace(tenv_xy, [], N-3, penv);

check = checking(M, tout, tint);                                          % Check if a logical matrix that informs the pixels that are between the traces

M = laplace_numeric(M, check, pMean, eps_limit);                           % Run the laplace method to calculate the potential in any point between the surfaces

grad = norm_gradient(M, check);                                            % Takes the gradient

[mean_thickness, thickness, coords_equi] = ...                             % Calculate the mean thickness of the pixels that belongs to the contour
    calc_mean_thickness(M, tint, tout, grad, check, pMean, h, n);          % that is in the middle of the external and internal trace

tequi = zeros(size(M));
for j = 1 : length(coords_equi)
    tequi(coords_equi(j, 1), coords_equi(j, 2)) = 1;
end

area = sum(check,"all")/(n^2);
per_out = sum(tout./pout,"all")/n;
per_int = sum(tint./pint,"all")/n;
per_env = sum(tenv,"all")/n;
per_equi = sum(tequi,"all")/n;

thick_out = area/per_out;
thick_int = area/per_int;
thick_equi = area/per_equi;

out_table.name(1) = string(name);
out_table.mean_thickness(1) = mean_thickness;
out_table.thick_out(1) = thick_out;
out_table.thick_int(1) = thick_int;
out_table.thick_equi(1) = thick_equi;
out_table.area(1) = area;
out_table.per_out(1) = per_out;
out_table.per_int(1) = per_int;
out_table.per_env(1) = per_env;
out_table.per_equi(1) = per_equi;

plots_cerebelo(string(name), M, coords_equi, grad, check, h, min_xy, max_xy, thickness, n, mean_thickness, thick_out, thick_int);

writetable(out_table,strcat('output', filesep, 'thickness_real.csv'));
