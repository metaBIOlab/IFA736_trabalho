function check = checking2(M, te, ti)

filled_I = logical(imfill(ti));                                   % Points that are inside the internal trace

ind = find(filled_I==1);
k=1;
while true
    [i, j] = ind2sub(size(M), ind(k));
    if te(i,j)==0
        break;
    end
    k = k+1;
end

filled_E = logical(imfill(logical(te), [i j], 4));                                   % Points that are inside the external trace


check = filled_E - filled_I;                                               % Points that are between both traces
check(M ~= 0) = 0;

check = logical(check);                                                    % Transforms in a logical matrix

end
