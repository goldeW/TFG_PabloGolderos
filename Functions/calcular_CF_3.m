function [CF] = calcular_CF_3(alpha,gamma,delta,w,version)
% Cumulant Function de la parte alfaestable
    
if version == 0

    % Formulas de la version 0

    % Segun la parametrización de matlab S(alpha, beta, gamma, delta;0)

    if alpha ==1

         X = -gamma*abs(w);
         Y = -((2*gamma)/pi)* ...
             abs(w).* ...
             ( sign(w).*log(gamma*abs(w)) ) + ...
             delta*w;

    else

        X = -(gamma*abs(w)).^alpha;
        Y = (sign(w)*tan(pi*alpha/2)) .*...
            (-gamma*abs(w) - X)    + ...
            delta*w;

    end

elseif version == 1

    %Formulas de la version 1

    if alpha == 1

        X = -gamma*abs(w);
        Y = -((2*gamma)/pi)* ...
             abs(w).* ...
             ( sign(w).*log(abs(w)) ) + ...
             delta*w;

    else

        X = -(gamma*abs(w)).^alpha;
        Y = -(sign(w)*tan(pi*alpha/2)) .*...
            ( X )    + ...
            delta*w; 

        

    end

end

 CF  = exp(X + 1i*Y);

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

