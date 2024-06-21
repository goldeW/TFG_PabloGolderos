function [alfas_serie_sumada_3] = Representacion3D_comparativa(serie_sumada_3,stables_calculados, alfas_sf, gammas_sf, deltas_sf,centroide_objetivo)
alfas_serie_sumada_3 = alphas(serie_sumada_3,1);

figure;
scatter3(alfas_sf, gammas_sf, deltas_sf, [], alfas_sf, 'filled');
xlabel('Alfas_sf', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Gammas_sf', 'FontSize', 16, 'FontWeight', 'bold');
zlabel('Deltas_sf', 'FontSize', 16, 'FontWeight', 'bold');
title('Representación en 3D de Alfas, Gammas y Deltas', 'FontSize', 16, 'FontWeight', 'bold');
colorbar;
hold on
scatter3(centroide_objetivo(1,1), centroide_objetivo(1,2), centroide_objetivo(1,3), 150, "red", 'filled');
scatter3(alfas_serie_sumada_3(1,1), alfas_serie_sumada_3(3,1), alfas_serie_sumada_3(4,1), 150,"black", 'filled');
scatter3(stables_calculados(1,1), stables_calculados(1,2), stables_calculados(1,3), 150,"magenta", 'filled');
h1 = plot3(NaN, NaN, NaN, 'or', 'MarkerFaceColor', 'red'); % Rojo
h2 = plot3(NaN, NaN, NaN, 'ok', 'MarkerFaceColor', 'black'); % Negro
h3 = plot3(NaN, NaN, NaN, 'om', 'MarkerFaceColor', 'magenta'); % Magenta
legend([h1, h2, h3], {'Centroide objetivo', 'Serie sumada', 'Serie de ataque'}, 'FontSize', 14, 'FontWeight', 'bold');
% Establecer el formato del eje x en días y horas
ax = gca;
ax.FontSize = 14; % Cambiar el tamaño de la letra de los ejes
hold off
end

