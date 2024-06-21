function [media, mediana] = Media_y_Mediana(alfas, deltas, gammas)
media = zeros(1,3);
mediana = zeros(1,3);

media(1) = mean(alfas);
media(2) = mean(gammas);
media(3) = mean(deltas);

mediana(1) = median(alfas);
mediana(2) = median(gammas);
mediana(3) = median(deltas);
end

