function [Serie_sintetica_window, Parametros_Stables_ventanaEnConcreto, serie_sumada] = Superponer_trafico_1ventana(serie_original)
    
    % Sacar los parametros estables de la serie en concreto
    Parametros_AlphaStable = fitdist(serie_original, 'Stable');
    alpha = Parametros_AlphaStable.alpha;
    gamma = Parametros_AlphaStable.gam*0.4;
    delta = Parametros_AlphaStable.delta*0.1;
    Parametros_Stables_ventanaEnConcreto = [alpha gamma delta];
    % Se genera el objeto de distribución estable
    distribucion_estable_window = makedist('Stable', 'alpha', alpha, 'beta', 1, 'gam', gamma, 'delta', delta);

    % Se genera la serie temporal de 901 puntos con la distribución de su
    % serie original (Caso muy concreto)
    Serie_sintetica_window = random(distribucion_estable_window, 901,1);
    
    serie_sumada = Serie_sintetica_window + serie_original;

    % Gráfica de ventana original para poder comparar
    figure;
    subplot(3,1,1)
    plot(serie_original);
    xlabel('Ventana 15 minutos'); ylabel('Paquetes');
    title('Gráfica la serie original');
    legend('Serie Original');
    grid on;
    
    % Gráfica de las dos series por separado
    subplot(3,1,2)
    plot(Serie_sintetica_window, 'b'); % serie_sintetica en azul
    hold on;
    plot(serie_original, 'r'); % serie_original en rojo
    xlabel('Ventana 15 minutos'); ylabel('Paquetes');
    title('Gráfica de las dos series por separado');
    legend('Serie Sintética', 'Serie Original');
    grid on;
    hold off;
    
    % Gráfica de las dos series superpuestas
    subplot(3,1,3)
    plot(serie_sumada, 'b'); 
    xlabel('Ventana 15 minutos'); ylabel('Paquetes');
    title('Gráfica de las dos series superpuestas');
    legend('Serie sumada');
    grid on;



end