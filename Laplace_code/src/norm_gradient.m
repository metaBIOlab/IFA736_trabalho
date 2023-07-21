function grad = norm_gradient(M, check)

[py, px] = gradient(M);                                                    % Takes the gradient (py and px) of the potential at each point
px(check ~= 1) = 0;                                                        % Disregards gradient values that do not match the interior of the traces
py(check ~= 1) = 0;

px_n = px ./ ((px.^2 + py.^2) .^ (1/2));                                   % Normalizes gradients
py_n = py ./ ((px.^2 + py.^2) .^ (1/2));
px_n(isnan(px_n)) = 0;
py_n(isnan(py_n)) = 0;

grad(:, :, 1) = px_n;                                                      % Aggregates both arrays into one
grad(:, :, 2) = py_n;

end