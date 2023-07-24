clear;
clc;
close all;

%% Adding source code path
addpath('.\src');

%% Controls
save_control = 1;
refine_control = 1;
box_min = 3;
box_max = 100;
target_spacing = 0.0001; % only used if refine_control is set to 1

%% Load your desired curve
folder = '.\data\simulation\';
curve = 'out';
ccase = 'pt5';
number_of_points = '250';
case_name = [curve,'_',ccase,'_',number_of_points];
full_path = [folder, '\', curve, '\', case_name, '.csv'];
disp(full_path);
curve = csvread(full_path, 1, 0);
x = curve(:,1);
y = curve(:,2);

%% Normalizing
x = (x-min(x))/(max(x)-min(x));
y = (y-min(y))/(max(y)-min(y));

%% Plotting
fig = figure('Position', [100, 100, 500, 500]);
fig.Color = 'w';
scatter(x, y);
hold on;
grid on;


%% Refining Curve
if(refine_control)
    newPoints = [];
    for i = 1:size(x, 1)-1
        xleft = x(i);
        xright = x(i+1);
        yleft = y(i);
        yright = y(i+1);
        disp([xleft, xright]);
        if(xright>=xleft)
            xq = (xleft:target_spacing:xright)';
        else
            xq = (xleft:-target_spacing:xright)';
        end
        yq = interp1([xleft, xright],[yleft, yright],xq);
        newPoints = [newPoints; [xq, yq]];
    end
    x = newPoints(:,1);
    y = newPoints(:,2);
end

%% Box count
bsV = [];
nbV = [];
for n = box_min:box_max
    [counts, boxSize, xIntBoxes, yIntBoxes] = boxCountInPolygon(x, y, n);
    bsV(end+1) = boxSize;
    nbV(end+1) = counts;
end

%% Fit a line to the data and estimate the fractal dimension
coefficients = polyfit(log(bsV), log(nbV), 1);
fractalDimension = -coefficients(1);
disp(['Estimated Fractal Dimension: ', num2str(fractalDimension)]);


%% Plotting
fig = figure('Position', [100, 100, 1600, 800]);
subplot(1,2,1);
plot(log(1./bsV), log(nbV), 'LineStyle', 'None', 'Marker', '+', 'LineWidth', 1.5, 'Color', 'k');
subplot(1,2,2);
scatter(x, y);
hold on;
for i = 1:size(xIntBoxes, 1)
    patch(xIntBoxes(i, :), yIntBoxes(i, :), 'r', 'FaceAlpha', 0.4)
    hold on;
end
pause;

%% Saving
if(save_control)
    close(fig);
    save([case_name, '.mat']);
end
