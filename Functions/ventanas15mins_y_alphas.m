function [alpha_params] = ventanas15mins_y_alphas(num_ventanas,indice,semana_en_dias)

for i=1:num_ventanas
    ventanas_15mins(:,i) = enventanar(indice,semana_en_dias(:,3));
    medias_ventanas_15mins(:,i) = mean(ventanas_15mins(:,i));
    indice = indice + 900;
    figure;
    plot(ventanas_15mins(:,i)); 
    title(['Ventana de 15 mins numero ' num2str(i)]);

    % alfaestables
    alpha_params = alphas(ventanas_15mins,num_ventanas);

    ejex_8ventanas = 1:8;
    figure;
    plot(ejex_8ventanas, medias_ventanas_15mins);
    xlabel('Ventanas (15 mins cada una a partir de las 11)');
    ylabel('Media de paquetes');
    title('Media de paquetes en ventanas de 15 mins de 11:00 a 13:00');

end

