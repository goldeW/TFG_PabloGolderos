function [CF] = calcular_CF_1(alpha,gamma,delta)
    frecuencia_minima = -5;
    frecuencia_maxima = 5;
                                   
    % Calculo de la Funcion característica empírica eCF
    % N = length(serie_original);
    precision_f = 0.01;
    w = frecuencia_minima:precision_f:frecuencia_maxima;
    numero_angulos = size(w,2);
    CF = zeros(1,numero_angulos) + 1i*zeros(1, numero_angulos);
    %CF = zeros(1,w) + 1i*zeros(1, w);
    parte1 = -gamma^alpha * abs(w).^alpha;
    parte2 = 1 + 1i * tan(pi * alpha / 2) * sign(w) .* (abs(gamma * w).^(1-alpha) - 1);
    parte3 = 1i * delta * w;

    CF = exp(parte1 .* parte2 + parte3);
    %CF = exp(-(gamma.^alfa).*(abs(w).^alfa).*(1+1i.*tan(pi*alfa/2).*(sign(w)).*((abs(gamma.*w)).^(1-alfa)-1))+1i.*delta.*w);
    
    % Graficas de la parte real e imaginaria de la función característica
    figure;
    subplot(2,1,1);
    plot(w, abs(CF));
    title('Modulo de la Función Característica');
    xlabel('w');
    ylabel('Mod(CF(w))');
    
    subplot(2,1,2);
    plot(w, angle(CF));
    title('Fase de la Función Característica');
    xlabel('w');
    ylabel('Fase(CF(w))');

end

