function [boxCounts, boxSize, xIntBoxes, yIntBoxes] = boxCountInPolygon(x, y, nBoxes)

    %% Define the range of box sizes
    nBoxesX = nBoxes; % Modify the range as desired
    boxSize = 1/nBoxesX;
    nBoxesY = nBoxesX; 

    %% Initialize an array to store the counts
    boxCounts = 0;

    %% Box corners
    boxCornersX = linspace(0, 1, nBoxesX+1);
    boxCornersY = linspace(0, 1, nBoxesY+1);

    %% Mesh
    [gridX, gridY] = meshgrid(boxCornersX, boxCornersY);
    % boxes = [gridX(:), gridY(:)];

    %% Storing coordinates of intersected boxes
    xIntBoxes = [];
    yIntBoxes = [];

    %% Loop over boxes
    for j = 1:nBoxesY
        for i = 1:nBoxesX
    %         disp([j, i]);
            xBoxCornerSW = gridX(j, i);
            xBoxCornerSE = gridX(j, i+1);
            xBoxCornerNW = gridX(j, i);
            xBoxCornerNE = gridX(j, i+1);
            yBoxCornerSW = gridY(j+1, i);
            yBoxCornerSE = gridY(j+1, i+1);
            yBoxCornerNW = gridY(j, i);
            yBoxCornerNE = gridY(j, i+1);

            xVPol = [xBoxCornerSW, xBoxCornerNW, xBoxCornerNE, xBoxCornerSE,...
                     xBoxCornerSW];
            yVPol = [yBoxCornerSW, yBoxCornerNW, yBoxCornerNE, yBoxCornerSE,...
                     yBoxCornerSW];

            indices = inpolygon(x, y, xVPol, yVPol);
            if any(indices)
               boxCounts = boxCounts + 1;
               xIntBoxes(end+1, :) = xVPol;
               yIntBoxes(end+1, :) = yVPol;
            end
        end
    end
