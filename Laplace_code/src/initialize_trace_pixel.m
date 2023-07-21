function [M, tout, tint] = initialize_trace_pixel(tout_xy, tint_xy, pout, pint)

maxX = max(tout_xy(:,1));
maxY = max(tout_xy(:,2));
minX = min(tout_xy(:,1));
minY = min(tout_xy(:,2));

sizeM = max(maxX - minX + 1, maxY - minY + 1);

M = zeros(sizeM);
tout = M; tint = M;

tout_xy(:,1) = tout_xy(:,1) - minX + 1;
tout_xy(:,2) = tout_xy(:,2) - minY + 1;
tint_xy(:,1) = tint_xy(:,1) - minX + 1;
tint_xy(:,2) = tint_xy(:,2) - minY + 1;

for i=1:length(tout_xy)
    M(tout_xy(i,1),tout_xy(i,2))=pout;
    tout(tout_xy(i,1),tout_xy(i,2)) = pout;
end

for i=1:length(tint_xy)
    M(tint_xy(i,1),tint_xy(i,2))=pint;
    tint(tint_xy(i,1),tint_xy(i,2))=pint;
end

M = [zeros(1, size(M, 2)); M; zeros(1, size(M, 2))];
tint = [zeros(1, size(tint, 2)); tint; zeros(1, size(tint, 2))];
tout = [zeros(1, size(tout, 2)); tout; zeros(1, size(tout, 2))];

M = [zeros(size(M, 1), 1), M, zeros(size(M, 1), 1)];
tint = [zeros(size(tint, 1), 1), tint, zeros(size(tint, 1), 1)];
tout = [zeros(size(tout, 1), 1), tout, zeros(size(tout, 1), 1)];

end
