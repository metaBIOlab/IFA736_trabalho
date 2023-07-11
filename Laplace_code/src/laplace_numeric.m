function M = laplace_numeric(M, check, pMean, eps_limit)

eps = 1; eps_2 = eps;
check_aux = check(2:end - 1, 2:end - 1);                                   % Auxiliary check without borders

M(check) = pMean;

while eps > eps_limit                                                      % Loop until it reaches the stop criterion
    eps_1 = eps_2;
    A = M(3:end    , 2:end - 1);                                           % Matrices (A, B, C, and D) correspond to the 4 direct neighbors of the i-th point
    B = M(1:end - 2, 2:end - 1);
    C = M(2:end - 1, 3:end    );
    D = M(2:end - 1, 1:end - 2);
    result = (A + B + C + D)/4;
    M(check) = result(check_aux);                                          % Takes the average of the neighbors and updates the matrix M
    %     eps_2 = ...
    %         sqrt((sum(diff(M).^2, "all") + sum(diff(M, 1, 2).^2, "all")));
    dx = diff(M);
    dy = diff(M,1,2);
    eps_2 = sum(sqrt(dx(:,2:end).^2+dy(2:end,:).^2),"all");
    eps = abs(eps_1 - eps_2) / eps_1;                                      % Updates the stop criterion indicator
    disp(eps)
end

end