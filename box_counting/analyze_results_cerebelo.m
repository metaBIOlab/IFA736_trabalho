clear;
clc;
close all;

%% Case list
case_list = {'in_cerebelo', 'out_cerebelo'};

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

%% Plotting
fig = figure('Position', [100, 100, 1600, 600]);
fig.Color = 'w';

%%
subplot(1,3,1);
plot(log(1./results.in_cerebelo.bsV), log(results.in_cerebelo.nbV), 'LineStyle', 'None', 'Marker', '+', 'LineWidth', 1.5, 'Color', 'k');
hold on;
plot(log(1./results.out_cerebelo.bsV), log(results.out_cerebelo.nbV), 'LineStyle', 'None', 'Marker', '+', 'LineWidth', 1.5, 'Color', 'b');
set(gca, 'FontSize', 16);
xlabel('ln(1/eps)');
ylabel('ln(N(eps))');

%%
subplot(1,3,2);
s = scatter(results.in_cerebelo.x, results.in_cerebelo.y, 7, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
hold on;
for i = 1:size(results.in_cerebelo.xIntBoxes, 1)
    patch(results.in_cerebelo.xIntBoxes(i, :), results.in_cerebelo.yIntBoxes(i, :), 'r', 'FaceAlpha', 0.4)
    hold on;
end
s = scatter(results.out_cerebelo.x, results.out_cerebelo.y, 7, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
hold on;
for i = 1:size(results.out_cerebelo.xIntBoxes, 1)
    patch(results.out_cerebelo.xIntBoxes(i, :), results.out_cerebelo.yIntBoxes(i, :), 'y', 'FaceAlpha', 0.4)
    hold on;
end
set(gca, 'FontSize', 16);
xlabel('x');
ylabel('y');

%%
subplot(1,3,3);
s = scatter(results.out_cerebelo.x, results.out_cerebelo.y, 7, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
hold on;
for i = 1:size(results.out_cerebelo.xIntBoxes, 1)
    patch(results.out_cerebelo.xIntBoxes(i, :), results.out_cerebelo.yIntBoxes(i, :), 'y', 'FaceAlpha', 0.4)
    hold on;
end
s = scatter(results.in_cerebelo.x, results.in_cerebelo.y, 7, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
hold on;
for i = 1:size(results.in_cerebelo.xIntBoxes, 1)
    patch(results.in_cerebelo.xIntBoxes(i, :), results.in_cerebelo.yIntBoxes(i, :), 'r', 'FaceAlpha', 0.4)
    hold on;
end
set(gca, 'FontSize', 16);
xlabel('x');
ylabel('y');
xlim([0.4, 0.6]);
ylim([0.7, 0.9]);