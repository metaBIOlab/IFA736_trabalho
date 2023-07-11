clear;
addpath('src');

%% Setting parameters
n = 500;                                                                   % Parameter that scales the resolution of the matrix
h = 0.01;                                                                  % Step size for integration for the path integral used to calculate the thickness
eps_limit = 1e-7;                                                          % Limit criterio to stop laplace's iterations (Variation of energy)
pout = 250;                                                                % Potential of the external trace
pint = 50;                                                                 % Potential of the internal trace
pMean = pint + (pout-pint)/2;                                              % Potential of the contour that is in the middle of both traces

folder_int = strcat('.', filesep, 'data', filesep, 'simulation', filesep, 'in', filesep);     % Folder with the database
folder_out = strcat('.', filesep, 'data', filesep, 'simulation', filesep, 'out', filesep);     % Folder with the database
folder_env = strcat('.', filesep, 'data', filesep, 'simulation', filesep, 'e', filesep);     % Folder with the database

%% Main code

files_list_int = dir(fullfile(folder_int, '**/*.csv*'));                   % Lists all c3d files in the folder
files_list_out = dir(fullfile(folder_out, '**/*.csv*'));                   % Lists all c3d files in the folder
files_list_env = dir(fullfile(folder_env, '**/*.csv*'));                   % Lists all c3d files in the folder
out_table = table();

for i = 1:length(files_list_int)

    file_path_int = [files_list_int(i).folder filesep files_list_int(i).name];
    file_path_out = [files_list_out(i).folder filesep files_list_out(i).name];
    file_path_env = [files_list_env(i).folder filesep files_list_env(i).name];

    name = files_list_int(i).name(6:end-4);
    
    tint_xy = readmatrix(file_path_int);
    tout_xy = readmatrix(file_path_out);
    tenv_xy = readmatrix(file_path_env);
    
    min_xy = min(tenv_xy);
    max_xy = max(tenv_xy);
    N = round(max(max_xy - min_xy) * n);

    tenv = initialize_trace(tenv_xy, [], N, 1);
    tout = initialize_trace(tout_xy, [], N, pout);
    tint = initialize_trace(tenv_xy, tint_xy, N, pint);
    
    M = tint + tout;

    [x_over, y_over] = find(M==pint+pout);

    for j = 1:length(x_over)
        M(x_over(j),y_over(j)) = pout;
    end

    check = checking(M, tout, tint);                                          % Check if a logical matrix that informs the pixels that are between the traces

    M = laplace_numeric(M, check, pMean, eps_limit);                       % Run the laplace method to calculate the potential in any point between the surfaces

    grad = norm_gradient(M, check);                                        % Takes the gradient

    [mean_thickness, thickness, coords_equi] = ...                         % Calculate the mean thickness of the pixels that belongs to the contour
        calc_mean_thickness(M, tint, tout, grad, check, pMean, h, n);      % that is in the middle of the external and internal trace

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

    out_table.name(i) = string(name);
    out_table.mean_thickness(i) = mean_thickness;
    out_table.thick_out(i) = thick_out;
    out_table.thick_int(i) = thick_int;
    out_table.thick_equi(i) = thick_equi;
    out_table.area(i) = area;
    out_table.per_out(i) = per_out;
    out_table.per_int(i) = per_int;
    out_table.per_env(i) = per_env;
    out_table.per_equi(i) = per_equi;
    
    plots_cerebelo(string(name), M, coords_equi, grad, check, h, min_xy, max_xy, thickness, n, mean_thickness, thick_out, thick_int);
end

writetable(out_table,strcat('output', filesep, 'thickness_simulation.csv'));
