function plots_cerebelo(name, M, coords_equi, grad, check, h, min_xy, max_xy, thickness, n, mean_thickness, thick_out, thick_int)

figure(1); clf;
x_plot=1:size(M,1); y_plot=x_plot; y_plot=y_plot';
contourf(x_plot,y_plot,M)
hold on;
for i=1:10:size(coords_equi, 1)
    [~, r] = calc_i_thickness(grad, coords_equi(i,:), check, h);
    plot(r(:,2)-0.5,r(:,1)-0.5,'k','LineWidth',0.5);
end

[~, i_xy] = max(max_xy);

xticks(linspace(1, size(M,1), 5))
xticklabels(round(linspace(min_xy(1), max_xy(i_xy), 5),2))
yticks(linspace(1, size(M,1), 5))
yticklabels(round(linspace(min_xy(2), max_xy(i_xy), 5),2))

xlabel('X');
ylabel('Y');

axis square
hcb = colorbar;
ylabel(hcb, 'Potencial', 'Rotation', -90, 'HorizontalAlignment', 'center');

set(gcf, 'Units', 'pixels', 'Position', [0, 0, 1000, 1000]);
set(gca, 'FontSize', 14);

exportgraphics(gcf, strcat('.', filesep, 'figures', filesep, name, '_equipotential.pdf'), 'ContentType', 'vector');

%%
figure(2); clf;

edges = linspace(0,max(thickness),31);
frequency = histcounts(thickness, edges);
edges(1) = [];
total = sum(frequency);
occurrency = frequency / total;

h = bar(edges, occurrency, 'hist');
h.FaceColor = [0.5 0.5 0.5];
h.FaceAlpha = 0.4;
h.EdgeAlpha = 0.05;
xlabel('Thickness');
ylabel('Occurrence');
c=lines(3);
xline(mean_thickness, LineWidth=2,Color=c(2,:));
xline(thick_out, LineWidth=2, Color=c(3,:));
xline(thick_int, LineWidth=2, Color=c(1,:));

legend('Distribuição de expessuras', 'Média da distribuição', 'Perímetro externo / Área', 'Perímetro interno / Área')

exportgraphics(gcf, strcat('.', filesep, 'figures', filesep, name, '_histogram.pdf'), 'ContentType', 'vector');

end
