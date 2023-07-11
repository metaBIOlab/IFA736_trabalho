function [trace] = initialize_trace(te_xy, ti_xy, N,  potential)

min_x = min(te_xy(:, 1));
min_y = min(te_xy(:, 2));

te_xy(:,1) = te_xy(:,1) - min_x;
te_xy(:,2) = te_xy(:,2) - min_y;

max_xy = max(te_xy, [], "all");

if isempty(ti_xy)
    trace_xy = te_xy;
else
    trace_xy = ti_xy;
    trace_xy(:, 1) = trace_xy(:, 1) - min_x;
    trace_xy(:, 2) = trace_xy(:, 2) - min_y;
end

trace_xy = trace_xy / max_xy;
trace_xy = 1 + round(trace_xy * N);
trace_xy = [trace_xy; trace_xy(1, :)];

trace = zeros(N+1);

d_trace = diff(trace_xy);

for i = 1 : size(d_trace,1)
    dx = d_trace(i, 1);
    dy = d_trace(i, 2);
    nSteps = max(abs(dx), abs(dy));
    stepX = dx / nSteps;
    stepY = dy / nSteps;

    x_aux = trace_xy(i, 1);
    y_aux = trace_xy(i, 2);

    for j = 1 : nSteps
        trace(ceil(x_aux), ceil(y_aux)) = 1;
        x_aux = x_aux + stepX;
        y_aux = y_aux + stepY;
    end
end

trace = trace * potential;

trace = [zeros(size(trace, 1), 1), trace, zeros(size(trace, 1), 1)];
trace = [zeros(1, size(trace, 2)); trace; zeros(1, size(trace, 2))];

end