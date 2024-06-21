clear; close all;clc; warning off;
addpath('./Datasets/');
addpath('./Functions/');

%% Mio
% Estructura de los archivos BPSyPSS ->
% - Columna 1 : Tiempo (segundos)
% - Columna 2 : Bytes transmitidos desde el segundo anterior hasta el segundo actual
% - Columna 3 : Paquetes transmitidos desde el segundo anterior hasta el segundo actual

% Se ha probado todas las semanas, las unicas validas son las siguientes:
mayo3 = load("./Datasets/may_week3_csv/BPSyPPS.txt");
abril3 = load("./Datasets/april_week3_csv/BPSyPPS.txt");
junio2 = load("./Datasets/june_week2_csv/BPSyPPS.txt");
marzo4 = load("./Datasets/march_week4_csv/BPSyPPS.txt");
junio3 = load("./Datasets/june_week3_csv/BPSyPPS.txt");

f = ["pdf"]; % Formato para guardar imagenes vectoriales
%semana_mayo_3 = Carga_y_plotea_week(mayo3);
%saveas(gcf,'/Imagenes_vectorizadas/mayo3',f);

%plotWeekDays(Mayo3_enDias);
%figure;
%plot(1:1:901,ventanas_15mins_Mayo3(:,7));
%xlim([0 901])
%xlabel('Ventana de 15 minutos', 'FontSize', 16, 'FontWeight', 'bold');
%ylabel('paquetes/s', 'FontSize', 16, 'FontWeight', 'bold');
%title('Miércoles, Mayo 3, de 12:30 a 12:45', 'FontSize', 16, 'FontWeight', 'bold')
% Establecer el formato del eje x en días y horas
%ax = gca;
%ax.FontSize = 14; % Cambiar el tamaño de la letra de los ejes
%saveas(gcf,'ventana7_mayo3',f);


[Mayo3_enDias,ventanas_15mins_Mayo3,alpha_params_Mayo3] = Dataset_to_windows(mayo3);
[Abril3_enDias,ventanas_15mins_Abril3,alpha_params_Abril3] = Dataset_to_windows(abril3);
[Junio2_enDias,ventanas_15mins_Junio2,alpha_params_Junio2] = Dataset_to_windows(junio2);
[Marzo4_enDias,ventanas_15mins_Marzo4,alpha_params_Marzo4] = Dataset_to_windows(marzo4);
[Junio3_enDias,ventanas_15mins_Junio3,alpha_params_Junio3] = Dataset_to_windows(junio3);

num_ventanas = 8;
% Ha generado 1 matriz de 4x8 para cada semana, 8 = número de series de 15
% minutos desde las 11:00
% El formato de alpha_params_week es el siguiente:
%   [alpha1 alpha2 alpha3 ... alpha8] 
%   [beta1  beta2  beta3  ... beta8] 
%   [gamma1 gamma2 gamma3 ... gamma8] 
%   [delta1 delta2 delta3 ... delta8] 

ALFA_PARAMS = {alpha_params_Mayo3 alpha_params_Abril3 alpha_params_Junio2 alpha_params_Marzo4 alpha_params_Junio3};
% FORMATO ALFA_PARAMS: [MAYO3 ABRIL3 JUNIO2 MARZO4 JUNIO3]
% FORMATO MAYO3 y el resto: [Lunes Martes Miercoles Jueves Viernes]
% FORMATO lunes y resto de dias : (Ventana_1 Ventana_2...Ventana_8)
% Formato ventanas -> 4x8 double
% En total hay 200 puntos para cada parámetro estable (8x5x5)
alfas = zeros(1,200);
betas = zeros(1,200);
gammas = zeros(1,200);
deltas = zeros(1,200);


% Aquí guardo todos los parámetros estables en un mismo vector
%           alfas(1,200)
%           betas(1,200)
%           gammas(1,200)
%           deltas(1,200)
for semana=1:numel(ALFA_PARAMS)
    for dia=1:numel(ALFA_PARAMS{1, 1})
        for ventana=1:num_ventanas
        alfas((ventana - 1) * (5 * 5) + (semana - 1) * 5 + dia) = ALFA_PARAMS{1, semana}{1, dia}(1,ventana);
        betas((ventana - 1) * (5 * 5) + (semana - 1) * 5 + dia) = ALFA_PARAMS{1, semana}{1, dia}(2,ventana);
        gammas((ventana - 1) * (5 * 5) + (semana - 1) * 5 + dia) = ALFA_PARAMS{1, semana}{1, dia}(3,ventana);
        deltas((ventana - 1) * (5 * 5) + (semana - 1) * 5 + dia) = ALFA_PARAMS{1, semana}{1, dia}(4,ventana);
        end
    end
end


% PROBAR REPRESENTAR CON COLORES LA BETA, Y VER QUE SIGNIFICADO TIENE EL
% CLUSTER DE ABAJO (PUEDE SER SEMANA SANTA) -> ver posible semana santa en
% el calendario de Granada -> Comprobado.

% Graficar en 3D
scatter3(alfas, gammas, deltas, [], alfas, 'filled');
xlabel('Alpha', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Gamma', 'FontSize', 16, 'FontWeight', 'bold');
zlabel('Delta', 'FontSize', 16, 'FontWeight', 'bold');
title('Diagrama de dispersión 3D de parámetros alpha-estables', 'FontSize', 16, 'FontWeight', 'bold');
ax = gca;
ax.FontSize = 14; % Cambiar el tamaño de la letra de los ejes
colorbar;
%saveas(gcf,'diagrama_disp_1',f);

% Los casos de beta alejada de 1 no importa ya que es una gausiana(alfa=2)
% por lo tanto representar en 3 dimensiones alfa,delta,gamma para
% visualizarlo mejor

% Clusterización con K-means - Puedo elegir varios clusters
num_clusters = 2;
[idx, centros,coeficiente_silueta] = clusterizacion(alfas, gammas, deltas, num_clusters);

% Comprobado 2 centroides mejor que 1 y que 3,4...
coeficiente_silueta_medio = mean(coeficiente_silueta);

% Inicializo vectores para stables sin festivos
alfas_sf = zeros(1,84);
gammas_sf = zeros(1,84);
deltas_sf = zeros(1,84);
cont=0;
% Ver índices del segundo cluster para estudio analítico
indices_2do_cluster = [];
for i=1:200
    if(idx(i)==2)
        indices_2do_cluster = [indices_2do_cluster,i];
        cont = cont + 1;
    else
        alfas_sf(i-cont) = alfas(i);
        gammas_sf(i-cont) = gammas(i);
        deltas_sf(i-cont) = deltas(i);
    end
end

% Marzo4{1, 4},1 y Marzo4{1, 5},1  
% Marzo4{1, 4},2 y Marzo4{1, 5},2   
% Marzo4{1, 4},3 y Marzo4{1, 5},3  
% Marzo4{1, 4},4 y Marzo4{1, 5},4
% Marzo4{1, 4},5 y Marzo4{1, 5},5 
% Marzo4{1, 4},6 y Marzo4{1, 5},6
% ... CONCLUSION -> Jueves y Viernes de la semana 4 de marzo
% Se representan los datos sin festivos

% Diagrama de dispersión sin los festivos
scatter3(alfas_sf, gammas_sf, deltas_sf, [], alfas_sf, 'filled');
xlabel('Alfas_sf');
ylabel('Gammas_sf');
zlabel('Deltas_sf');
title('Representación en 3D de Alfas, Gammas y Deltas sin festivos');
colorbar;

% ESTUDIAR SIGNIFICATIVO DE LOS CLUSTERS REPRESENTADOS (MEJOR CON 2) (DÍA, HORA...)
% ESTUDIAR CON EL CASO MEDIO EN VEZ DE CENTROIDES
[media_stables, mediana_stables] = Media_y_Mediana(alfas,deltas,gammas);

% Quitando los festivos tenemos estos parametros estadísticos:
[media_stables_sf, mediana_stables_sf] = Media_y_Mediana(alfas_sf,deltas_sf,gammas_sf);


%% CF - FUNCIÓN CARACTERÍSTICA ESTABLE

distribucion_estable_centroide1 = makedist('Stable', 'alpha', centros(1,1), 'beta', 1, 'gam', centros(1,2), 'delta', centros(1,3));
distribucion_estable_medias_1 = makedist('Stable', 'alpha', media_stables(1), 'beta', 1, 'gam', media_stables(2), 'delta', media_stables(3));
distribucion_estable_medias_sf = makedist('Stable', 'alpha', media_stables_sf(1), 'beta', 1, 'gam', media_stables_sf(2), 'delta', media_stables_sf(3));
distribucion_estable_medianas_1 = makedist('Stable', 'alpha', mediana_stables(1), 'beta', 1, 'gam', mediana_stables(2), 'delta', mediana_stables(3));
distribucion_estable_medianas_sf = makedist('Stable', 'alpha', mediana_stables_sf(1), 'beta', 1, 'gam', mediana_stables_sf(2), 'delta', mediana_stables_sf(3));

% Generar paquetes con muestras aleatorias que sigan mi distribucion. Este
% ejemplo no tiene en cuenta reducir la magnitud de los paquetes como indicó Jorge
% !! DUDA !! ¿Cambiar valores de delta y gamma o reducir con un factor de escala?
% COEFICIENTE CUADRÁTICO D
num_muestras = 901;
muestras_centroide_1 = random(distribucion_estable_centroide1, num_muestras,1);
muestras_medias_1 = random(distribucion_estable_medias_1, num_muestras,1);
muestras_medias_sf = random(distribucion_estable_medias_sf, num_muestras,1);
muestras_medianas_1 = random(distribucion_estable_medias_1, num_muestras,1);
muestras_medianas_sf = random(distribucion_estable_medias_sf, num_muestras,1);

% Representar series temporales generadas según su distribución estable
figure;
plot(muestras_centroide_1);
xlabel('Ventana 900 muestras'); ylabel('Paquetes');
title('Tráfico maligno generado con Centroide 1');

figure;
plot(muestras_medias_1);
xlabel('Ventana 900 muestras'); ylabel('Paquetes');
title('Tráfico maligno generado con media');

figure;
plot(muestras_medias_sf);
xlabel('Ventana 900 muestras'); ylabel('Paquetes');
title('Tráfico maligno generado con media sin festivos');

figure;
plot(muestras_medianas_1);
xlabel('Ventana 900 muestras'); ylabel('Paquetes');
title('Tráfico maligno generado con mediana');

figure;
plot(muestras_medianas_sf);
xlabel('Ventana 900 muestras'); ylabel('Paquetes');
title('Tráfico maligno generado con mediana sin festivos');

% Diagrama de dispersión con medias y medianas - El centroide coincide con
% la media, se eha utilizado como algoritmo de clusterización K - means
figure;
scatter3(alfas_sf, gammas_sf, deltas_sf, [], alfas_sf, 'filled');
xlabel('Alpha', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Gamma', 'FontSize', 16, 'FontWeight', 'bold');
zlabel('Delta', 'FontSize', 16, 'FontWeight', 'bold');
title('Comparación en 3D de centroide-media-mediana', 'FontSize', 16, 'FontWeight', 'bold');
colorbar;
hold on
ax = gca;
ax.FontSize = 14; % Cambiar el tamaño de la letra de los ejes
scatter3(centros(1,1), centros(1,2), centros(1,3), 150,"red", 'filled');
scatter3(media_stables_sf(1,1), media_stables_sf(1,2), media_stables_sf(1,3), 150,"red", 'filled');
scatter3(mediana_stables_sf(1,1), mediana_stables_sf(1,2), mediana_stables_sf(1,3), 150,"magenta", 'filled');
h1 = plot3(NaN, NaN, NaN, 'or', 'MarkerFaceColor', 'red'); % Rojo
h2 = plot3(NaN, NaN, NaN, 'ok', 'MarkerFaceColor', 'red'); % Negro
h3 = plot3(NaN, NaN, NaN, 'om', 'MarkerFaceColor', 'magenta'); % Magenta
legend([h1, h2, h3], {'Centroide Objetivo', 'Media alfaestables', 'Mediana alfaestables'}, 'FontSize', 14, 'FontWeight', 'bold');

%% SUPERPOSICIÓN DE TRÁFICO - haciendo pruebas - CON DISTRIBUCIONES ESTABLES CONJUNTAS (objetos medios de todas las series temporales)

% A partir de aquí empiezan resultados de generar tráfico, si se revisa
% posteriormente, esta parte no se realiza teniendo en cuenta la propiedad
% de la suma explicada en la memoria, por tanto se recomienda saltar al
% script PARTE ANALÍTICA - NOLAN 1.6 - SUMA DE ALFAESTABLES

% Revisar la corrección de los máximos -> mirar pag 32 en adelante del
% libro de Nolan (apartado 1.6)

for i=1:8
    Serie_sintetica_generica = Superponer_trafico(i,muestras_centroide_1,ventanas_15mins_Mayo3(:,i));
end


%% SUPERPOSICIÓN DE TRÁFICO - haciendo pruebas - CON DISTRIBUCIONES ESTABLES PARTICULARIZANDO UNA VENTANA
[Serie_sintetica_window, Parametros_Stables_ventanaEnConcreto, serie_sumada_ventanaEnConcreto] = Superponer_trafico_1ventana(ventanas_15mins_Mayo3(:,1));
alfas_serie_sumada_ventanaEnConcreto = Representacion3D_comparativa(serie_sumada_ventanaEnConcreto,Parametros_Stables_ventanaEnConcreto, alfas_sf, gammas_sf, deltas_sf,centroide_objetivo);

%% Cambiando parámetros - Reduccion de Delta para ajustar escala de las series sintéticas
% Permite que α y β determinen la forma de la distribución,
% mientras que γ y δ determinan la escala y la ubicación de la manera estándar

% SERIE SINTÉTICA 1 -> reduciendo delta, reducimos la amplitud media de la
% serie,situandola en un valor por deajo de la original
centroide1 = centros(1,:);
centroide1(1,3) = centroide1(1,3).*(10e-2);
[serie_sumada_1,muestras_centroide_Delta_Gamma_Changed_1] = Serie_sintetica_Delta_Gamma_changed(centroide1,ventanas_15mins_Mayo3(:,1));


% SERIE SINTÉTICA 2 -> reduciendo gamma, reducimos la escala relativa de
% serie, pero sigue situada en un valor medio de amplitud muy cercano a la
% serie original
centroide2 = centros(1,:);
centroide2(1,2) = centroide2(1,2).*(10e-2);
[serie_sumada_2,muestras_centroide_Delta_Gamma_Changed_2] = Serie_sintetica_Delta_Gamma_changed(centroide2,ventanas_15mins_Mayo3(:,1));



% SERIE SINTÉTICA 3 -> reduciendo delta y gamma a valores más intermedios
% que en las series sinteticas 1 y 2
centroide3 = centros(1,:);
centroide3(1,2) = centroide3(1,2).*(0.3);
centroide3(1,3) = centroide3(1,3).*(0.3);
[serie_sumada_3,muestras_centroide_Delta_Gamma_Changed_3] = Serie_sintetica_Delta_Gamma_changed(centroide3,ventanas_15mins_Mayo3(:,1));
% 3D comprobación estdística. Series como estaban anteriormente
% EN ROJO -> stables serie sintética
% EN NEGRO -> stables serie superpuesta
alfas_serie_sumada_3 = Representacion3D_comparativa(serie_sumada_3,centroide3, alfas_sf, gammas_sf, deltas_sf,centroide_objetivo);



% SERIE SINTÉTICA 4 -> reduciendo delta y gamma a valores más intermedios
% que en las series sinteticas 1 y 2
centroide4 = centros(1,:);
centroide4(1,2) = centroide4(1,2).*(0.3);
centroide4(1,3) = centroide4(1,3).*(0.1);
[serie_sumada_4,muestras_centroide_Delta_Gamma_Changed_4] = Serie_sintetica_Delta_Gamma_changed(centroide4,ventanas_15mins_Mayo3(:,1));
% 3D comprobación estdística. Series como estaban anteriormente
% EN ROJO -> stables serie sintética
% EN NEGRO -> stables serie superpuesta
alfas_serie_sumada_4 = Representacion3D_comparativa(serie_sumada_4,centroide4, alfas_sf, gammas_sf, deltas_sf,centroide_objetivo);



% SERIE SINTÉTICA 5 -> aumentando gamma con respecto a la 4 para tener mas
% amplitud sin subir la delta demasiado (MEJOR HASTA AHORA)
centroide5 = centros(1,:);
centroide5(1,2) = centroide5(1,2).*(0.4);
centroide5(1,3) = centroide5(1,3).*(0.1);
[serie_sumada_5,muestras_centroide_Delta_Gamma_Changed_5] = Serie_sintetica_Delta_Gamma_changed(centroide5,ventanas_15mins_Mayo3(:,1));
% 3D comprobación estdística. Series como estaban anteriormente
% EN ROJO -> stables serie sintética
% EN NEGRO -> stables serie superpuesta
alfas_serie_sumada_5 = Representacion3D_comparativa(serie_sumada_5,centroide5, alfas_sf, gammas_sf, deltas_sf,centroide_objetivo);


% SERIE SINTÉTICA 6 -> aumentando gamma con respecto a la 5, ya que la
% delta está bien pero podemos aumentar gamma, NO AUMENTA
centroide6 = centros(1,:);
centroide6(1,2) = centroide6(1,2).*(0.6);
centroide6(1,3) = centroide6(1,3).*(0.1);
[serie_sumada_6,muestras_centroide_Delta_Gamma_Changed_6] = Serie_sintetica_Delta_Gamma_changed(centroide6,ventanas_15mins_Mayo3(:,1));
% 3D comprobación estdística. Series como estaban anteriormente
% EN ROJO -> stables serie sintética
% EN NEGRO -> stables serie superpuesta
alfas_serie_sumada_6 = Representacion3D_comparativa(serie_sumada_6,centroide6, alfas_sf, gammas_sf, deltas_sf,centroide_objetivo);

% medir distancia al centroide 
%% PRUEBAS TUNEANDO GAMMA Y/O DELTA

for i=0.4:0.05:0.6
    centroidei = centros(1,:);
    centroidei(1,2) = centroidei(1,2)*(i);
    centroidei(1,3) = centroidei(1,3).*(0.1);
    [serie_sumada_i,muestras_centroide_Delta_Gamma_Changed_i] = Serie_sintetica_Delta_Gamma_changed(centroidei,ventanas_15mins_Mayo3(:,1));
    % 3D comprobación estdística. Series como estaban anteriormente
    % EN ROJO -> stables serie sintética
    % EN NEGRO -> stables serie superpuesta
    alfas_serie_sumada_i = Representacion3D_comparativa(serie_sumada_i,centroidei, alfas_sf, gammas_sf, deltas_sf,centroide_objetivo);
end


%% PARTE ANALÍTICA - NOLAN 1.6 - SUMA DE ALFAESTABLES
% Dado un suceso X -> (α, γ, β, δ), 
% si tenemos X1 + X2, con distr. estable, la suma también lo será
% X1 + X2 ∼ S (α, β, γ, δ; 0).
alpha_obj = centros(1,1); 
gamma_obj = centros(1,2);
delta_obj = centros(1,3);
centroide_objetivo = [alpha_obj gamma_obj delta_obj];

% Como serie original se utiliza Mayo, Lunes, ventana 7
% por similitud quasi exacta en el parametro alpha y poder aplicar Nolan
% alpha_obj ∼= alpha1
[stables_original] = (ALFA_PARAMS{1, 1}{1, 1}(:,7));
gamma_1 = stables_original(3,1);
delta_1 = stables_original(4,1);

gamma_2 = (gamma_obj^alpha_obj-gamma_1^alpha_obj)^(1/alpha_obj);
%delta_2 = delta_obj-delta_1-(tan(pi*alpha_obj/2))*(gamma_obj-gamma_1-gamma_2); 
delta_2 = delta_obj-delta_1;


% SERIE SINTÉTICA 7 -> con los valores calculados de Nolan. 
stables_calculados = [alpha_obj, gamma_2, delta_2];
[serie_sumada_7,muestras_centroide_Delta_Gamma_Changed_7] = Serie_sintetica_Delta_Gamma_changed(stables_calculados,ventanas_15mins_Mayo3(:,7));
% 3D comprobación estdística. Series como estaban anteriormente
% EN ROJO -> stables serie sintética
% EN NEGRO -> stables serie superpuesta
alfas_serie_sumada_7 = Representacion3D_comparativa(serie_sumada_7,stables_calculados, alfas_sf, gammas_sf, deltas_sf,centroide_objetivo);



% SERIE SINTÉTICA 8 -> Corrigiendo el parámetro Delta para aumentar la
% localización de la serie sintética y que no haya valores negativos.
% Pruebo con el 10% del valor del centroide pero manteniendo gamma
% calculado según Nolan -> CORREGIDOS VALORES NEGATIVOS 
stables_calculados_2 = [alpha_obj, gamma_2, delta_obj*0.1];
[serie_sumada_8,muestras_centroide_Delta_Gamma_Changed_8] = Serie_sintetica_Delta_Gamma_changed(stables_calculados_2,ventanas_15mins_Mayo3(:,7));
% 3D comprobación estdística. Series como estaban anteriormente
% EN ROJO -> stables serie sintética
% EN NEGRO -> stables serie superpuesta
alfas_serie_sumada_8 = Representacion3D_comparativa(serie_sumada_8,stables_calculados_2, alfas_sf, gammas_sf, deltas_sf,centroide_objetivo);


% SERIE SINTÉTICA 9 -> con valores calculados en excel según Nolan a un 5%
stables_calculados_3 = [alpha_obj 739.6215052 2237.779476];
[serie_sumada_9,muestras_centroide_Delta_Gamma_Changed_9] = Serie_sintetica_Delta_Gamma_changed(stables_calculados_3,ventanas_15mins_Mayo3(:,7));
% 3D comprobación estdística. Series como estaban anteriormente
% EN ROJO -> stables serie sintética
% EN NEGRO -> stables serie superpuesta
% EN ROSA -> stables centroide objetivo
alfas_serie_sumada_9 = Representacion3D_comparativa(serie_sumada_9,stables_calculados_3, alfas_sf, gammas_sf, deltas_sf,centroide_objetivo);
figure;
histogram(serie_sumada_9);


% SERIE SINTÉTICA 10 -> con valores calculados en excel según Nolan a un 10%
stables_calculados_4 = [alpha_obj 1114.471391 4637.782691];
[serie_sumada_10,muestras_centroide_Delta_Gamma_Changed_10] = Serie_sintetica_Delta_Gamma_changed(stables_calculados_4,ventanas_15mins_Mayo3(:,7));
% 3D comprobación estdística. Series como estaban anteriormente
% EN ROJO -> stables serie sintética
% EN NEGRO -> stables serie superpuesta
% EN ROSA -> stables centroide objetivo
alfas_serie_sumada_10 = Representacion3D_comparativa(serie_sumada_10,stables_calculados_4, alfas_sf, gammas_sf, deltas_sf,centroide_objetivo);
%figure;
%histogram(serie_sumada_10);



% SERIE SINTÉTICA 11 -> con valores calculados en excel según Nolan a un 7.5%
stables_calculados_5 = [alpha_obj 939.3054713 3432.329166];
[serie_sumada_11,muestras_centroide_Delta_Gamma_Changed_11] = Serie_sintetica_Delta_Gamma_changed(stables_calculados_5,ventanas_15mins_Mayo3(:,7));
% 3D comprobación estdística. Series como estaban anteriormente
% EN ROJO -> stables serie sintética
% EN NEGRO -> stables serie superpuesta
% EN ROSA -> stables centroide objetivo
alfas_serie_sumada_11 = Representacion3D_comparativa(serie_sumada_11,stables_calculados_5, alfas_sf, gammas_sf, deltas_sf,centroide_objetivo);
figure;
histogram(serie_sumada_11);


% Crear el subplot
figure;
% Primer histograma
subplot(3, 1, 1); % 3 filas, 1 columna, posición 1
histogram(serie_sumada_9,'Normalization', 'pdf');
title('Histograma 1: Serie de ataque al 5 %');
% Segundo histograma
subplot(3, 1, 2); % 3 filas, 1 columna, posición 2
histogram(serie_sumada_10,'Normalization', 'pdf');
title('Histograma 2: Serie de ataque al 7.5 %');
% Tercer histograma
subplot(3, 1, 3); % 3 filas, 1 columna, posición 3
histogram(serie_sumada_11,'Normalization', 'pdf');
title('Histograma 3: Serie de ataque al 10 %');
% Personalizar la gráfica
xlabel('Tráfico en paquetes/s');
ylabel('Densidad de probabilidad normalizada');


%% Mirar si con alfa = 2 y beta = 0 que ocurre --> comprobado, es peor
% Para ello utilizo fórmula Nolan 1.6, inf*0 => 0
alpha_tr = 2;
beta_tr = 0;
gamma_tr = (((1.1*centroide_objetivo(2))^2)-(centroide_objetivo(2)^2))^0.5; % Se aplica el 10 % (comparar posteriormente con 10 % normal)
delta_tr = 0.1*centroide_objetivo(3);
stables_tr = [alpha_tr gamma_tr delta_tr]; % CAMBIANDO LA LÍNEA DEL MAKEDIST DE LA FUNCIÓN

% SERIE SINTÉTICA truncada -> aplha = 2, beta = 0
[serie_sumada_tr,muestras_serie_tr] = Serie_sintetica_Delta_Gamma_changed(stables_tr,ventanas_15mins_Mayo3(:,7));
% 3D comprobación estdística. Series como estaban anteriormente
% EN ROJO -> stables serie sintética
% EN NEGRO -> stables serie superpuesta
% EN ROSA -> stables centroide objetivo
alfas_serie_sumada_tr = Representacion3D_comparativa(serie_sumada_tr,stables_tr, alfas_sf, gammas_sf, deltas_sf,centroide_objetivo);
figure;
histogram(serie_sumada_tr);
figure;
histogram(ventanas_15mins_Mayo3(:,7));


%% Costes - Distancia al centroide
% Calculando la distancia de la serie superpuesta (sintética + original)
% al centroide - Distancia Euclídea
alfas_serie_sumada_10 = [alfas_serie_sumada_10(1,1) alfas_serie_sumada_10(3,1) alfas_serie_sumada_10(4,1)];
distancia_centroide_10 = sqrt(sum((alfas_serie_sumada_10 - centroide_objetivo).^2));

alfas_serie_sumada_tr = [alfas_serie_sumada_tr(1,1) alfas_serie_sumada_tr(3,1) alfas_serie_sumada_tr(4,1)];
distancia_centroide_tr = sqrt(sum((alfas_serie_sumada_tr - centroide_objetivo).^2));

coste_max = max(distancia_centroide_tr,distancia_centroide_10);
Distancia_centroides = [distancia_centroide_tr distancia_centroide_10]./coste_max;

% Representación de costes (distancia a centroide) normalizado a la maxima
figure;
stem([1 3],Distancia_centroides);
xlim([0 4]);
xlabel('Costes');ylabel('Distancia centroide Norm');
legend('1. Gausiana truncada 10% - 3. Serie normal 10%')
grid on;


% Representación en 3D de los costes
figure;
scatter3(alfas_sf, gammas_sf, deltas_sf, [], alfas_sf, 'filled');
xlabel('Alfas_sf');
ylabel('Gammas_sf');
zlabel('Deltas_sf');
title('Representación en 3D de Alfas, Gammas y Deltas');
colorbar;
hold on
scatter3(centroide_objetivo(1,1), centroide_objetivo(1,2), centroide_objetivo(1,3),"red", 'filled');
scatter3(alfas_serie_sumada_10(1,1), alfas_serie_sumada_10(1,2), alfas_serie_sumada_10(1,3),"black", 'filled');
scatter3(alfas_serie_sumada_tr(1,1), alfas_serie_sumada_tr(1,2), alfas_serie_sumada_tr(1,3),"magenta", 'filled');
h1 = plot3(NaN, NaN, NaN, 'or', 'MarkerFaceColor', 'red'); % Rojo
h2 = plot3(NaN, NaN, NaN, 'ok', 'MarkerFaceColor', 'black'); % Negro
h3 = plot3(NaN, NaN, NaN, 'om', 'MarkerFaceColor', 'magenta'); % Magenta
legend([h1, h2, h3], {'Centroide Objetivo', 'Alfas Serie Sumada 10', 'Alfas Serie Sumada TR'});
plot3([centroide_objetivo(1,1), alfas_serie_sumada_10(1,1)], ...
      [centroide_objetivo(1,2), alfas_serie_sumada_10(1,2)], ...
      [centroide_objetivo(1,3), alfas_serie_sumada_10(1,3)], 'k-'); % Línea negra

plot3([centroide_objetivo(1,1), alfas_serie_sumada_tr(1,1)], ...
      [centroide_objetivo(1,2), alfas_serie_sumada_tr(1,2)], ...
      [centroide_objetivo(1,3), alfas_serie_sumada_tr(1,3)], 'k-'); % Línea negra
hold off

%% Post Primera entrega de la memoria 

% Generación de meseta al 10%
% Calcular el valor medio de la serie original
valor_medio = mean(ventanas_15mins_Mayo3(:,7));
% Generar una meseta al 10% del valor medio
num_elements = 901;
media_meseta = valor_medio * 0.10;
desviacion_estandar_meseta = media_meseta * 0.2;  
meseta_aleatoria = media_meseta + desviacion_estandar_meseta * randn(num_elements, 1);


%% Aquí termina este script de representación, caracterización y generación
% paso a guardar los datos finales y realizar el estudio analítico en "Analytic_studio.m"
% alfa estables de la serie original a comparar para pasar a
% Analytic_studio
alphas_serie_original = alphas(ventanas_15mins_Mayo3(:,7),1);
serie_original = ventanas_15mins_Mayo3(:,7);


save('stables_calculados.mat', 'stables_calculados_4');
save('serie_sintetica_10.mat', 'muestras_centroide_Delta_Gamma_Changed_10');
save('serie_sintetica_075.mat', 'muestras_centroide_Delta_Gamma_Changed_11');
save('serie_sintetica_05.mat', 'muestras_centroide_Delta_Gamma_Changed_9');
save('serie_sintetica_meseta.mat', 'meseta_aleatoria');
save('serie_original.mat', 'serie_original');
save('alphas_serie_original.mat', 'alphas_serie_original');
save('serie_sintetica_gauss.mat', 'muestras_serie_tr');
save('centroide_objetivo.mat','centroide_objetivo');
save('stables_sf.mat', 'alfas_sf', 'gammas_sf', 'deltas_sf');
