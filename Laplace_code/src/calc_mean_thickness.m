function [mean_thickness, thickness, equipot] = calc_mean_thickness(M, ti, te, grad, check, pMean, h, n)

contour_pMean = contourc(M, [pMean pMean]);                                % Find the contour line that corresponds to the pMean value

contour_pMean(:,ismember(contour_pMean(1, :), pMean)) = [];

contourExclude = zeros(size(contour_pMean,2),1);

for i = 1:size(contour_pMean,2)
    xi = round(contour_pMean(2,i));
    yi = round(contour_pMean(1,i));

    if ti(xi,yi)~=0 || te(xi,yi)~=0
        contourExclude(i) = 1;
    end
end

contour_pMean(:,logical(contourExclude)) = [];

xCoords = round(contour_pMean(2,:));
yCoords = round(contour_pMean(1,:));

equipot = [xCoords; yCoords]';
equipot = unique(equipot, "rows");

thickness = zeros(size(equipot, 1), 1);                                     % Creates a vector to find the thickness of the pixels that belongs to that contour line

for i = 1:size(thickness, 1)                                               % Loop that goes through the pixels of the contour line
    thickness(i) = calc_i_thickness(grad, equipot(i,:), check, h);         % Calculates the thickness for that specific pixel
end

thickness = thickness/n;

mean_thickness = mean(thickness);                                          % Takes the mean thickness

end