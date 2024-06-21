function [alpha_params] = alphas(ventanas_15mins,num_ventanas)

for i=1:num_ventanas
    Parametros_AlphaStable = fitdist(ventanas_15mins(:,i), 'Stable');
    alpha = Parametros_AlphaStable.alpha;
    beta = Parametros_AlphaStable.beta;
    gamma = Parametros_AlphaStable.gam;
    delta = Parametros_AlphaStable.delta;
    alpha_params(:,i) = [alpha, beta, gamma, delta];
end

%figure;
%plot(alpha_params(1,:));
%title('Parametro Alpha de 11:00 a 13:00');
%xlabel('Tiempo');ylabel('Alpha');
%grid on;

%figure;
%plot(alpha_params(2,:));
%title('Parametro Beta de 11:00 a 13:00');
%xlabel('Tiempo');ylabel('Beta');
%grid on;

%figure;
%plot(alpha_params(3,:));
%title('Parametro Gamma de 11:00 a 13:00');
%xlabel('Tiempo');ylabel('Gamma');
%grid on;

%figure;
%plot(alpha_params(4,:));
%title('Parametro Delta de 11:00 a 13:00');
%xlabel('Tiempo');ylabel('Delta');
%grid on;
end

