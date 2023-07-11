files_list = dir(fullfile('.', '**/*.txt*'));                     % Lists all c3d files in the folder

for i = 1:length(files_list)

path_i = [files_list(i).folder filesep files_list(i).name];

name = files_list(i).name(1:end-4);
file_name = fopen(path_i, 'r');   
file_data = fread(file_name, '*char')';
fclose(file_name);

pattern = '-?\d+\.\d+';
matches = regexp(file_data, pattern, 'match');
data = str2double(matches);

data = reshape(data, 2, []).';

table = array2table(data, 'VariableNames', {'x', 'y'});

writetable(table, 'in_pt.csv');

%%

file_name = fopen('out_pt.txt', 'r');
file_data = fread(file_name, '*char')';
fclose(file_name);

pattern = '-?\d+\.\d+';
matches = regexp(file_data, pattern, 'match');
data = str2double(matches);

data = reshape(data, 2, []).';

table = array2table(data, 'VariableNames', {'x', 'y'});

writetable(table, [name '.csv']);
end
