clear; close all;clc; warning off;
addpath('./Datasets/');
addpath('./Functions/');
addpath('./Datos_finales/');

%% Cargar datos obtenidos de Representación.m
load("serie_original.mat");
load("serie_sintetica.mat");
load("serie_sumada.mat");
load("alphas_serie_sintetica.mat");
load("alphas_serie_sumada.mat");
load("alphas_serie_original.mat");
load("serie_sumada_tr.mat");
load("muestras_serie_tr.mat");
load("centroide_objetivo.mat");

j=1i;
alfa_original=alphas_serie_original(1); gamma_original=alphas_serie_original(3); delta_original=alphas_serie_original(4);
alfa_sintetica=stables_calculados_4(1); gamma_sintetica=stables_calculados_4(2); delta_sintetica=stables_calculados_4(3);
alfa_sumada=alfas_serie_sumada_10(1); gamma_sumada=alfas_serie_sumada_10(2); delta_sumada=alfas_serie_sumada_10(3);

% ESTE SCRIPT NO TIENE IMPACTO EN EL TFG COMO TAL
% Se deja subido por si es de utilidad para futuros proyectos relacionados


%% Pruebas ECF
distribucion_estable_original = makedist('Stable', 'alpha', alfa_original, 'beta', 1, 'gam', gamma_original, 'delta', delta_original);

% Definir la función característica
phi = @(t) exp(1i * delta_original * t - gamma_original^alfa_original * abs(t).^alfa_original .* (1 - 1i * sign(t) * alfa_original * pi/2));

% Definir un vector de frecuencias (puedes ajustar esto según tus necesidades)
frecuencias = linspace(-2, 2, 1000);

% función característica
fcn_caracteristica = charfun(distribucion_estable_original, frecuencias);

% Graficar el módulo
subplot(2,1,1);
plot(frecuencias, modulo_normalizado);
xlabel('Frecuencia');
ylabel('Módulo Normalizado');
title('Módulo de la Función Característica Normalizado');

% Graficar la fase
subplot(2,1,2);
plot(frecuencias, fase);
xlabel('Frecuencia');
ylabel('Fase (radianes)');
title('Fase de la Función Característica');

% Ajustar espaciado entre subgráficos
sgtitle('Función Característica de la Distribución Estable');

%% ECF - Función Característica Empírica
% TFM benjamin pagina 66 pdf
% TFG benjamin pagina 22 pdf
N = 901; % numero de muestras
j=1i;
T = 900; % T = t * N para muestras discretas
         % t tiene que ser igual a 1
t = 1;
w = -(pi/t):(2*pi)/(N*t):(pi/t)-(2*pi/(N*t));

ECF = zeros(N,1);
for i=1:N
    ECF(i) = (1/N).*(sum(exp(j*t*serie_sumada_10(i))));
    %ECF(i)=exp(1i*w(i)*serie_sumada_10(i));
end

 % Graficas de la parte real e imaginaria de la función característica
figure;
subplot(2,1,1);
plot(w, abs(ECF));
title('Modulo de la Función Característica');
xlabel('w');
ylabel('Mod(CF(w))');

subplot(2,1,2);
plot(w, angle(ECF));
title('Fase de la Función Característica');
xlabel('w');
ylabel('Fase(CF(w))');
%% ECDF - función de distribución acumulada empírica, acotada entre 0 y 1
[f_empirica, x_empirica] = ecdf(serie_sumada_10);
% Visualizar la Función Característica Empírica (ECDF)
figure;
plot(x_empirica, f_empirica);
title('Función Característica Empírica (ECF) de la Serie Temporal');
xlabel('x');
ylabel('F(x)');
grid on;

%% Generación de paquetes apuntes
% SHAFT *
% STACHELDRAHT
% TFN 
% Trinoo (no podría)


% ojo a Nolan pag 22 para ver gausiana truncada
% then (X − δ)/γ ∼ S (α, β, 1, 0; 0). This is not true for the
% S (α, β, γ, δ; 1) parameterization when α = 1

% mirar dataNormalization.py para normalizacion una vez tenga matematizada
% le ECF y representada

Sea X la variable aleatoria del tráfico normal en una red  (paquetes por segundo), que sigue una distribución α-estable.
Sea Y la variable aleatoria del tráfico de DoS en una red (paquetes por segundo) , que sigue otra distribución α-estable, diferente de X.
Cuando se suman ambas variables en un caso real de ataque, tendriamos       Z=X+Y.
Esta suma de variables aleatorias hace que   la FDP de Z se obtenga como la FDP de X e Y.
Si se trabaja con funciones características, tendremos que φZ=φX·φY , lo cual simplifica el modelo matemático por 2 motivos:
 
Las distribuciones α-estable tienen expresión cerrada para su función característica pero no para su FDP.
Un producto es fácilmente computable.
 
Segun lo anterior, si tenemos cierto tráfico y obtenemos su función característica, podemos dividirla entre φX            
y comparar el resultado con φY   (¿con una correlación? ¿multiplicando por el conjugado    (Teorema de la Correlación)?).   Si el resultado presenta una alta correlación, estariamos            
ante un ataque de DoS. Si no, podemos considerar que el tráfico sigue siendo normal.

%% pruebas funcion calcular_ECF - Parametrización K=0 (α!=1)
% Formato stables_calculados(alpha,gamma,delta)
% Vector de frecuencias (omega) según la teoría de Nolan
w = -5:0.01:5;


CF_original_1 = calcular_CF_1(alfa_original,gamma_original,delta_original,w);
CF_sintetica_1 = calcular_CF_1(alfa_sintetica,gamma_sintetica,delta_sintetica,w);
CF_sumada_1 = calcular_CF_1(alfa_sumada,gamma_sumada,delta_sumada,w);

% Mirar diferencia entre ./ y /
comprobacion_1_1= CF_sumada_1./CF_original_1;
comprobacion_1_2= CF_sumada_1/CF_original_1;
figure;
subplot(2,1,1);
plot(w,abs(comprobacion_1_1));
xlabel('w');ylabel('|CF_sumada./CF_orig|');
legend('|CF_sumada./CF_orig|');
subplot(2,1,2);
stem(abs(comprobacion_1_2));
xlabel('w');ylabel('|CF_sumada/CF_orig|');
legend('|CF_sumada/CF_orig|');


% Test cambiando la w pero con misma formula
k = (-N/2:N/2-1);
w2 = k/N * (pi/delta_original)^(1/alfa_original) * sin(pi*alfa_original/2)/alfa_original * ((1-alfa_original)^(1-alfa_original)/((2*pi)^(1-alfa_original)));
CF_original_2 = calcular_CF_1(alfa_original,gamma_original,delta_original,w2);
CF_sintetica_2 = calcular_CF_1(alfa_sintetica,gamma_sintetica,delta_sintetica,w2);
CF_sumada_2 = calcular_CF_1(alfa_sumada,gamma_sumada,delta_sumada,w2);

% NORMALIZACIÓN
% if X ∼ S (α, β, γ, δ; 0), then (X − δ)/γ ∼ S (α, β, 1, 0; 0). This is not true for the
% S (α, β, γ, δ; 1) parameterization when α = 1.

% EN rEPRESENTACIÓN, ver nube de puntos con centroide y distancias
% CHEQUEAR PAPER 
% referencias a otros TFG's (volver a mirar alberto)

% Mirar diferencia entre ./ y /
comprobacion_2_1= CF_sumada_2./CF_original_2;
comprobacion_2_2= CF_sumada_2/CF_original_2;
figure;
subplot(2,1,1);
plot(w2,abs(comprobacion_2_1));
xlabel('w2');ylabel('|CF_sumada./CF_orig|');
legend('|CF_sumada./CF_orig|');
subplot(2,1,2);
stem(abs(comprobacion_2_2));
xlabel('w2');ylabel('Mod(CF_sumada/CF_orig)');
legend('Abs(CF_sumada/CF_orig)');



%% test de Luis

eCF_original = calcular_CF_2(serie_original);
eCF_sintetica = calcular_CF_2(muestras_centroide_Delta_Gamma_Changed_10);
eCF_sumada = calcular_CF_2(serie_sumada_10);


% Mirar diferencia entre ./ y /
%comprobacion_eCF_1= eCF_original./eCF_original;
comprobacion_eCF_1= eCF_sumada./eCF_original;
%comprobacion_eCF_2= eCF_sumada/eCF_original;
figure;
subplot(2,1,1);
plot(w, abs(comprobacion_eCF_1));
xlabel('w');ylabel('|CF_sumada./CF_orig|');
legend('|CF_sumada./CF_orig|');
subplot(2,1,2);
plot(w, angle(comprobacion_eCF_1));
xlabel('w');ylabel('Fase(CF_sumada./CF_orig)');
legend('Fase(CF_sumada/CF_orig)');




%% ECF - intento 5

CF_original = calcular_CF_1(alfa_original,gamma_original,delta_original);
CF_sintetica = calcular_CF_1(alfa_sintetica,gamma_sintetica,delta_sintetica);
CF_sumada = calcular_CF_1(alfa_sumada,gamma_sumada,delta_sumada);


% Mirar diferencia entre ./ y /
comprobacion_CF_1= CF_sumada./CF_original;

figure;
subplot(2,1,1);
plot(w, abs(comprobacion_CF_1));
xlabel('w');ylabel('|CF_sumada./CF_orig|');
legend('|CF_sumada./CF_orig|');
subplot(2,1,2);
plot(w, angle(comprobacion_CF_1));
xlabel('w');ylabel('Fase(CF_sumada./CF_orig)');
legend('Fase(CF_sumada/CF_orig)');


%% CF - Intento 6
w = -5:0.01:5;

eCF_original = calcular_CF_2(serie_original);
eCF_sintetica = calcular_CF_2(muestras_centroide_Delta_Gamma_Changed_10);
eCF_sumada = calcular_CF_2(serie_sumada_10);


% Mirar diferencia entre ./ y /
comprobacion_eCF_1= eCF_sumada./eCF_original;

figure;
subplot(2,1,1);
plot(w, abs(comprobacion_eCF_1));
xlabel('w');ylabel('|CF_sumada./CF_orig|');
legend('|CF_sumada./CF_orig|');
subplot(2,1,2);
plot(w, angle(comprobacion_eCF_1));
xlabel('w');ylabel('Fase(CF_sumada./CF_orig)');
legend('Fase(CF_sumada/CF_orig)');


%% CF - Intento 7 - con CF_3
w = -0.5:0.01:0.5;

CF_original = calcular_CF_3(alfa_original,gamma_original,delta_original,w,0);
CF_sintetica = calcular_CF_3(alfa_sintetica,gamma_sintetica,delta_sintetica,w,0);
CF_sumada = calcular_CF_3(alfa_sumada,gamma_sumada,delta_sumada,w,0);


% Mirar diferencia entre ./ y /
comprobacion_CF_3= CF_sumada./conj(CF_original);


figure;
subplot(2,1,1);
plot(w, abs(comprobacion_CF_3));
xlabel('w');ylabel('|CF_sumada./CF_orig|');
legend('|CF_sumada./CF_orig|');
subplot(2,1,2);
plot(w, angle(comprobacion_CF_3));
xlabel('w');ylabel('Fase(CF_sumada./CF_orig)');
legend('Fase(CF_sumada/CF_orig)');



%% Prueba con CF_stable
CF_original = cf_Stable(serie_original,alfa_original,0,1,1,1);
CF_sintetica = cf_Stable(serie_sintetica,alfa_sintetica,0,1,1,1);
CF_sumada = cf_Stable(serie_sumada_10,alfa_sumada,0,1,1,1);

%% Comprobar distribuciones
pd_original = makedist('Stable','alpha',alfa_original,'beta',1,'gam',gamma_original,'delta',delta_original);
pd2_sintetica = makedist('Stable','alpha',alfa_sintetica,'beta',1,'gam',gamma_sintetica,'delta',delta_sintetica);
pd3_sumada = makedist('Stable','alpha',alfa_sumada,'beta',1,'gam',gamma_sumada,'delta',delta_sumada);

x = -900:1:900;
pdf_original = pdf(pd_original,x);
pdf_sintetica = pdf(pd2_sintetica,x);
pdf_sumada = pdf(pd3_sumada,x);

figure
plot(x,pdf_original,'b-');
hold on
plot(x,pdf_sintetica,'r-.');
plot(x,pdf_sumada,'k--');
title('Comparacion de PDFs')
legend('asd')
hold off

