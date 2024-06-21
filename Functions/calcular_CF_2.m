function eCF = calcular_CF_2(serie_original)
frecuencia_minima = -5;
frecuencia_maxima = 5;
                               
% Calculo de la Funcion característica empírica eCF
N = length(serie_original);
precision_f = 0.01;
w = frecuencia_minima:precision_f:frecuencia_maxima;
numero_angulos = size(w,2);
eCF = zeros(1,numero_angulos) + 1i*zeros(1, numero_angulos);
for j=1:numero_angulos
        for k = 1:N
            eCF(j) = eCF(j) + exp(1i*w(j)*serie_original(k));
            %eCF(j) = exp(1i*w(j)*serie_original(k));
        end 
        eCF(j) = eCF(j) / N;
    
end
     

% Graficas del modulo y fase de la función característica emíprica
figure;
subplot(2,1,1);
plot(w, abs(eCF));
title('Modulo de la Función Característica');
xlabel('w');
ylabel('Mod(ECF(w))');

subplot(2,1,2);
plot(w, angle(eCF));
title('Fase de la Función Característica');
xlabel('w');
ylabel('Fase(ECF(w))');
end

