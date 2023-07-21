function [thickness, r] = calc_i_thickness(grad, r0, check, h)

r(1, :) = r0;                                                              % Initializes the displacement array going from point r0 following the gradient
r_inv(1, :) = r0;                                                          % Initializes the correspondent that follows the oposite gradient

while(check(floor(r(end, 1)), floor(r(end, 2))) == 1)                      % Integration of the gradient path through Euler's method
    r(end + 1, :) = r(end, :) + h * reshape(grad(floor(r(end, 1)), ...
        floor(r(end, 2)), :), [1, 2]);
    if(r(end, 1) == r(end - 1, 1) && r(end, 2) == r(end - 1, 2))
        break;
    end
end

while (check(floor(r_inv(end, 1)), floor(r_inv(end, 2))) == 1)
    r_inv(end + 1, :) = ...
        r_inv(end, :) - h * reshape(grad(floor(r_inv(end, 1)), ...
        floor(r_inv(end, 2)), :), [1, 2]);    %#ok<*AGROW>
    if(r_inv(end, 1) == r_inv(end - 1, 1) && r_inv(end, 2) == r_inv(end - 1, 2))
        break;
    end
end

if size(r, 1) == 1 && size(r_inv, 1) == 1
    thickness = 0;
elseif size(r, 1) == 1
    thickness = sum(sqrt(sum(diff(r_inv).^2, 2)));
elseif size(r_inv, 1) == 1
    thickness = sum(sqrt(sum(diff(r).^2, 2)));
else
    r = [flip(r_inv(2:end, :), 1); r];                                     % Joins both trajectories
    dr = diff(r);
    thickness = sum(sqrt(sum(dr.^2, 2)));                                  % Takes the size of the trajectory, i.e. the thickness
end

end
