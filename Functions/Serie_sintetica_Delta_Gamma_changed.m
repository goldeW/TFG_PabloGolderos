function [serie_sumada,muestras_centroide_1_Delta_Gamma_Changed] = Serie_sintetica_Delta_Gamma_changed(centroide1, ventana_orig)
distribucion_estable_centroide1_deltaChanged = makedist('Stable', 'alpha', centroide1(1,1), 'beta', 0, 'gam', centroide1(1,2), 'delta', centroide1(1,3));
muestras_centroide_1_Delta_Gamma_Changed = random(distribucion_estable_centroide1_deltaChanged, 901,1);
% Comprobación de posibles valores negativos que alteran la distribucion
% Asegurarse de que todos los valores son positivos
all_positive = false;
while ~all_positive
    all_positive = true; % Suponer que todos los valores son positivos
    for i = 1:901
        if (muestras_centroide_1_Delta_Gamma_Changed(i) < 0)
            % Generar un nuevo valor aleatorio si es negativo
            muestras_centroide_1_Delta_Gamma_Changed(i) = random(distribucion_estable_centroide1_deltaChanged, 1, 1);
            all_positive = false; % Encontramos un negativo, por lo que el bucle se repetirá
        end
    end
end
serie_sumada = muestras_centroide_1_Delta_Gamma_Changed + ventana_orig;
% Gráfica de ventana original para poder comparar
figure;
subplot(3,1,1)
plot(ventana_orig);
xlabel('Ventana 15 minutos', 'FontSize', 16, 'FontWeight', 'bold'); ylabel('Paquetes', 'FontSize', 16, 'FontWeight', 'bold');
title('Gráfica la serie original', 'FontSize', 16, 'FontWeight', 'bold');
legend('Serie Original', 'FontSize', 14, 'FontWeight', 'bold');
% Establecer el formato del eje x en días y horas
ax = gca;
ax.FontSize = 14; % Cambiar el tamaño de la letra de los ejes
grid on;

% Gráfica de las dos series por separado
subplot(3,1,2)
plot(muestras_centroide_1_Delta_Gamma_Changed, 'b'); % serie_sintetica en azul
hold on;
plot(ventana_orig, 'r'); % serie_original en rojo
xlabel('Ventana 15 minutos', 'FontSize', 16, 'FontWeight', 'bold'); ylabel('Paquetes', 'FontSize', 16, 'FontWeight', 'bold');
title('Gráfica de las dos series por separado', 'FontSize', 16, 'FontWeight', 'bold');
legend('Serie Sintética', 'Serie Original', 'FontSize', 14, 'FontWeight', 'bold');
% Establecer el formato del eje x en días y horas
ax = gca;
ax.FontSize = 14; % Cambiar el tamaño de la letra de los ejes
grid on;
hold off;

% Gráfica de las dos series superpuestas
subplot(3,1,3)
plot(serie_sumada, 'b'); 
xlabel('Ventana 15 minutos', 'FontSize', 16, 'FontWeight', 'bold'); ylabel('Paquetes', 'FontSize', 16, 'FontWeight', 'bold');
title('Gráfica de las dos series superpuestas', 'FontSize', 16, 'FontWeight', 'bold');
legend('Serie sumada', 'FontSize', 14, 'FontWeight', 'bold');
% Establecer el formato del eje x en días y horas
ax = gca;
ax.FontSize = 14; % Cambiar el tamaño de la letra de los ejes
grid on;


end

