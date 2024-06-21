clear; close all;clc; warning off;
addpath('./Datasets/');
addpath('./Functions/');
addpath('./Datos_finales/');

%% Cargar datos obtenidos de Representación.m
% Cargar los archivos .mat
data1 = load('serie_sintetica_10.mat');
data2 = load('serie_sintetica_075.mat');
data3 = load('serie_sintetica_05.mat');
data4 = load('serie_sintetica_meseta.mat');
data5 = load('serie_sintetica_gauss.mat');
data6 = load('serie_original.mat');
data7 = load('alphas_serie_original.mat');
data8 = load('stables_calculados.mat');
data9 = load('centroide_objetivo.mat');
data10 = load('stables_sf.mat');

% Extraer variables del archivo
serie_sintetica_10 = data1.muestras_centroide_Delta_Gamma_Changed_10;
serie_sintetica_075 = data2.muestras_centroide_Delta_Gamma_Changed_11;
serie_sintetica_05 = data3.muestras_centroide_Delta_Gamma_Changed_9;
serie_sintetica_meseta = data4.meseta_aleatoria;
serie_sintetica_gauss = data5.muestras_serie_tr;
serie_original = data6.serie_original;
alphas_serie_original = data7.alphas_serie_original;
stables_calculados = data8.stables_calculados_4;
centroide_objetivo = data9.centroide_objetivo;
alfas_sf = data10.alfas_sf;
gammas_sf = data10.gammas_sf;
deltas_sf = data10.deltas_sf;

% Series sumadas y limpiar variables inutiles
serie_sumada_10 = serie_original + serie_sintetica_10;
serie_sumada_meseta = serie_original + serie_sintetica_meseta;
vars = who('data*'); % Encuentra todas las variables que empiezan con 'data'
clear(vars{:}); % Elimina todas esas variables
f = ["pdf"]; % Formato para guardar imagenes vectoriales

%% Flash - crowd para la memoria 

% Concatenar el vector original tres veces para obtener un vector de 2703x1
serie_orig_concatenada = repmat(serie_original, 3, 1);
vector_ceros = zeros(901,1);
serie_sumada_concatenada = [vector_ceros; serie_original+serie_sintetica_10; vector_ceros];

% Graficar ambas series para comparar
figure;
plot(serie_orig_concatenada, 'b', 'DisplayName', 'Serie Original');
xlim([0,2703]); ylim([3.5e4,9e4]);
hold on;
plot(serie_sumada_concatenada, 'r--', 'DisplayName', 'Serie con DoS Sutil');
legend show;
% Cambiar el tamaño de letra de la leyenda
lgd = legend;
lgd.FontSize = 14;
title('Flash-crowd con la serie de ataque al 10%', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Tiempo (segundos)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Paquetes/s', 'FontSize', 14, 'FontWeight', 'bold');
% Configurar los ejes
ax = gca; % Obtener el objeto de los ejes
ax.FontSize = 14; % Cambiar el tamaño de la letra de los ejes
grid on;


%% Comparativa con ataque tipo meseta 
% Este script genera un ataque de tipo meseta distinto al importado, solo
% ejecutar si se quieren hacer pruebas, pero para la parte de comparativa,
% saltar e importar los datos finales.
serie_orig_concatenada = repmat(serie_original, 3, 1);
% Calcular el valor medio de la serie original
valor_medio = mean(serie_original);

% Generar una meseta al 10% del valor medio
num_elements = 901;
media_meseta = valor_medio * 0.10;
desviacion_estandar_meseta = media_meseta * 0.2;  
meseta_aleatoria = media_meseta + desviacion_estandar_meseta * randn(num_elements, 1);
% Crear una copia de serie_orig_concatenada para sumar la meseta
vector_ceros = zeros(901,1);
serie_meseta_sumada = meseta_aleatoria+serie_original;
serie_meseta_concatenada = [vector_ceros; meseta_aleatoria; vector_ceros];
serie_sumada_concatenada = serie_meseta_concatenada + serie_orig_concatenada;

% Calculando distancia al centroide para gráfica de costes. El dato aquí
% generado se utiliza en Representación.m
DistCentroide_meseta = DistCentroide(alphas(serie_meseta_sumada,1),centroide_objetivo);

% Crear los subplots
figure;
% Primer subplot: la serie original
subplot(3, 1, 1);
plot(serie_orig_concatenada);
xlim([0,2703]);
title('Serie Original');
xlabel('Índice');
ylabel('Valor');

% Segundo subplot: la serie original y la meseta
subplot(3, 1, 2);
plot(1:length(serie_orig_concatenada), serie_orig_concatenada, 'b', 'DisplayName', 'Serie Original');
xlim([0,2703]);
hold on;
plot(1:length(serie_meseta_concatenada), serie_meseta_concatenada, 'r', 'DisplayName', 'Meseta');
title('Serie Original y Meseta');
xlabel('Índice');
ylabel('Valor');
legend;

% Tercer subplot: la serie original concatenada y modificada
subplot(3, 1, 3);
plot(serie_sumada_concatenada);
xlim([0,2703]);
title('Serie Original Concatenada Modificada');
xlabel('Índice');
ylabel('Valor');


%% Porcentajes de paquetes con respecto a la serie original
paquetes_serie_original = sum(serie_original);
paquetes_stable_05 = sum(serie_sintetica_05);
paquetes_stable_075 = sum(serie_sintetica_075);
paquetes_stable_10 = sum(serie_sintetica_10);
paquetes_stable_gaus = sum(serie_sintetica_gauss);
paquetes_stable_meseta = sum(serie_sintetica_meseta);

paquetes_normalizado = [paquetes_stable_05 paquetes_stable_075 paquetes_stable_10 paquetes_stable_gaus paquetes_stable_meseta]./paquetes_serie_original;
porcentaje_paquetes_normalizado = paquetes_normalizado*100;

%% Distancias normalizadas a Centroide
alfaestables_05 = alphas(serie_sintetica_05,1);
DistCentroide_005 = DistCentroide(alphas_serie_original + alphas(serie_sintetica_05,1),centroide_objetivo);
DistCentroide_075 = DistCentroide(alphas_serie_original + alphas(serie_sintetica_075,1),centroide_objetivo);
DistCentroide_010 = DistCentroide(alphas_serie_original + alphas(serie_sintetica_10,1),centroide_objetivo);
DistCentroide_meseta = 6.15036e+03; % dato generado en Analytic_studio
DistCentroide_gauss = DistCentroide(alphas_serie_original + alphas(serie_sintetica_gauss,1),centroide_objetivo);
distancias_Centroides_Norm = [DistCentroide_005 DistCentroide_075 DistCentroide_010 DistCentroide_gauss DistCentroide_meseta]./DistCentroide_meseta;

% Define los nombres de las categorías
categorias = {'5%', '7.5%', '10%', 'gaussiana', 'meseta'};
% Define los colores para cada barra
colores = lines(length(distancias_Centroides_Norm));
% Crear la gráfica de barras
figure;
hold on;
b = bar(distancias_Centroides_Norm);
% Configurar los ejes
ax = gca; % Obtener el objeto de los ejes
ax.FontSize = 14; % Cambiar el tamaño de la letra de los ejes
ax.FontWeight = 'bold'; % Poner en negrita la letra de los ejes
% Añadir título y configurar sus propiedades
title('Distancias Normalizadas a los Centroides', 'FontSize', 16, 'FontWeight', 'bold');

% Añadir etiquetas a los ejes y configurar sus propiedades
xlabel('Tipo de ataque', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Distancia al centroide normalizada', 'FontSize', 14, 'FontWeight', 'bold');
% Cambiar los colores de las barras y añadir texto de %
for k = 1:length(distancias_Centroides_Norm)
    b.FaceColor = 'flat';
    b.CData(k,:) = colores(k,:);
    porcentaje_texto = sprintf('%.2f%%', porcentaje_paquetes_normalizado(k));
    text(k, distancias_Centroides_Norm(k) - 0.05, porcentaje_texto, 'FontSize', 14, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontWeight', 'bold');
end
% Añadir las etiquetas de las categorías en el eje x
set(gca, 'XTickLabel', categorias);
% Añadir texto en la esquina superior izquierda dentro de la figura
%text(0.05, 0.95, '% con respecto a la serie original', 'Units', 'normalized', ...
    %'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontWeight', 'bold', 'FontSize', 12);
%saveas(gcf,'diagrama_barras_costes',f);


%% Calcular distancia de todos los puntos al centroide para ver cómo está de enmascarado
distancia_euclidea_puntos_sf = zeros(1,184);
for i=1:184
    alfas_ventana = [alfas_sf(i) 1 gammas_sf(i) deltas_sf(i)]';
    distancia_euclidea_puntos_sf(i) = DistCentroide(alfas_ventana,centroide_objetivo);
end

distancia_ordenada = sort(distancia_euclidea_puntos_sf);
distancia_percentil_10 = prctile(distancia_ordenada, 10);
distancia_percentil_90 = prctile(distancia_ordenada, 90);
distancia_euclidea_puntos_media = mean(distancia_ordenada);

% Busca un valor de distancia al centroide menor que la serie de ataque 10%
Percentil_serie_ataque_10 = -1;
for j=1:184
    if(distancia_ordenada(j)>DistCentroide_010)
        Percentil_serie_ataque_10 = j-1;
        break;
    end
end

% Busca un valor de distancia al centroide menor que la serie de ataque 7.5%
Percentil_serie_ataque_075 = -1;
for j=1:184
    if(distancia_ordenada(j)>DistCentroide_075)
        Percentil_serie_ataque_075 = j-1;
        break;
    end
end

% Busca un valor de distancia al centroide menor que la serie de ataque 5%
Percentil_serie_ataque_05 = -1;
for j=1:184
    if(distancia_ordenada(j)>DistCentroide_005)
        Percentil_serie_ataque_05 = j-1;
        break;
    end
end

% Busca un valor de distancia al centroide menor que la serie de ataque
% gaussiana al 10%
Percentil_serie_ataque_gauss = -1;
for j=1:184
    if(distancia_ordenada(j)>DistCentroide_gauss)
        Percentil_serie_ataque_gauss = j-1;
        break;
    end
end

% Busca un valor de distancia al centroide menor que la serie de ataque
% tipo meseta al 10%
Percentil_serie_ataque_meseta = -1;
for j=1:184
    if(distancia_ordenada(j)>DistCentroide_meseta)
        Percentil_serie_ataque_meseta = j-1;
        break;
    end
end

% Busca un valor de distancia al centroide para la serie original
Percentil_serie_original = -1;
for h=1:184
    if(distancia_ordenada(h) > DistCentroide(alphas_serie_original,centroide_objetivo))
        Percentil_serie_original = h-1;
        break;
    end
end

% Esta gráfica es para ver de forma visual qué ha ocurrido
% Valores para las barras
Percentiles = ([Percentil_serie_original, Percentil_serie_ataque_05, Percentil_serie_ataque_075, ...
    Percentil_serie_ataque_10, Percentil_serie_ataque_gauss, Percentil_serie_ataque_meseta]./184).*100;

% Valores originales
Percentiles_originales = [Percentil_serie_original, Percentil_serie_ataque_05, Percentil_serie_ataque_075, ...
    Percentil_serie_ataque_10, Percentil_serie_ataque_gauss, Percentil_serie_ataque_meseta];
% Colores para las barras (se puede ajustar según las preferencias)
bar_colors = [
    0 0.4470 0.7410; % Azul (Percentil serie original)
    0.8500 0.3250 0.0980; % Naranja (Percentil serie ataque 05)
    0.9290 0.6940 0.1250; % Amarillo (Percentil serie ataque 075)
    0.4940 0.1840 0.5560; % Púrpura (Percentil serie ataque 10)
    0.4660 0.6740 0.1880; % Verde (Percentil serie ataque gauss)
    0.3010 0.7450 0.9330; % Cian (Percentil serie ataque meseta)
];

figure;
% Crear la gráfica de barras
b = bar(Percentiles, 'FaceColor', 'flat');
% Asignar los colores a las barras
for k = 1:length(Percentiles)
    b.CData(k, :) = bar_colors(k, :);
end

% Configurar las etiquetas del eje x
set(gca, 'XTickLabel', {'Percentil serie original', 'Percentil serie ataque 05', 'Percentil serie ataque 075', ...
                        'Percentil serie ataque 10', 'Percentil serie ataque gauss', 'Percentil serie ataque meseta'}, 'FontWeight', 'bold');
set(gca, 'XTick', 1:6); % Asegura que se etiqueten las posiciones correctas
% Ajustar el rango del eje Y
ylim([0 100]);
% Agregar la leyenda
%legend(bar_colors, {'Percentil serie original', 'Percentil serie ataque 05', 'Percentil serie ataque 075', ...
       % 'Percentil serie ataque 10', 'Percentil serie ataque gauss', 'Percentil serie ataque meseta'}, ...
       % 'Location', 'northeastoutside', 'FontWeight', 'bold'); % Coloca la leyenda fuera de la gráfica

% Ampliar el tamaño de letra de los ejes y la leyenda
ax = gca;
ax.FontSize = 14; % Cambia el tamaño de letra de los ejes
% Cambiar el tamaño de letra de la leyenda
%lgd = legend;
%lgd.FontSize = 14;
% Etiquetas de los ejes
ylabel('Porcentaje (%)', 'FontSize', 16, 'FontWeight', 'bold');
% Título 
title('Comparación de Percentiles Normalizados', 'FontSize', 16, 'FontWeight', 'bold');
% Añadir texto con los valores normalizados debajo del límite superior de cada barra
for i = 1:length(Percentiles)
    text(i, Percentiles(i) - 5, sprintf('%.d/184', Percentiles_originales(i)), 'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'top', 'FontSize', 14, 'FontWeight', 'bold');
end


%% Script para modificar imagen una vez está abierta, 
% para exportarla a un documento
% Obtener el identificador de la figura y el eje
fig = gcf;  % Obtiene la figura actual
ax = gca;   % Obtiene el eje actual

% Cambiar el tamaño y estilo de las etiquetas de los ejes
ax.FontSize = 14;       % Aumenta el tamaño de la fuente
ax.FontWeight = 'bold'; % Cambia la fuente a negrita

% Añadir un título a la figura
title('Comparación de PDFs', 'FontSize', 14, 'FontWeight', 'bold');

% Opcional: Cambiar el tamaño y estilo de las etiquetas de los ejes x e y
xlabel('Valor', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Densidad de Probabilidad', 'FontSize', 14, 'FontWeight', 'bold');
% Cambiar el tamaño de letra de la leyenda
lgd = legend;
lgd.FontSize = 14;