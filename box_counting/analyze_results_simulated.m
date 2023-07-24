clear;
clc;
close all;

%% Case list
case_list = {'in_pt1_250', 'in_pt1_1000', 'in_pt2_250', 'in_pt2_1000', 'in_pt3_250', 'in_pt3_1000', 'in_pt4_250', 'in_pt5_250',...
             'out_pt1_250', 'out_pt1_1000', 'out_pt2_250', 'out_pt2_1000', 'out_pt3_250', 'out_pt3_1000', 'out_pt4_250', 'out_pt5_250'};

%% Loading results in struct         
results = struct();
for i = 1:length(case_list)
    results.(case_list{i}) = load(case_list{i});
end

%% Printing all fractal dimensions
for i = 1:length(case_list)
    data = results.(case_list{i});
    disp([data.case_name, ' ', num2str(-data.coefficients(1))]);
end