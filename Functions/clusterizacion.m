function [idx, centros,coeficiente_silueta] = clusterizacion(alfa, gamma, delta, num_clusters)
    X = [alfa', gamma', delta'];
  
    [idx, centros] = kmeans(X, num_clusters);
    % Calcular el coeficiente de silueta
    coeficiente_silueta = silhouette(X, idx);
    
    % Grafica los datos en 3D
    figure;
    scatter3(alfa, gamma, delta, 50, idx, 'filled');
    hold on;
    
    % Grafica los centroides de los clusters
    scatter3(centros(:, 1), centros(:, 2), centros(:, 3), 200, 'k', 'filled', 'MarkerEdgeColor', 'w');
    xlabel('Alpha', 'FontSize', 16, 'FontWeight', 'bold');
    ylabel('Gamma', 'FontSize', 16, 'FontWeight', 'bold');
    zlabel('Delta', 'FontSize', 16, 'FontWeight', 'bold');
    legend('Datos', 'Centroides', 'FontSize', 14, 'FontWeight', 'bold');
    title('Clustering en 3D de Alfa, Gamma y Delta', 'FontSize', 16, 'FontWeight', 'bold');
    ax = gca;
    ax.FontSize = 14; % Cambiar el tamaño de la letra de los ejes
    colorbar;
    
    hold off;
end

