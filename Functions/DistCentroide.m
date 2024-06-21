function [DistCentroide] = DistCentroide(alfas_serie_sumada,centroide_objetivo)
alfas_serie_sumada = [alfas_serie_sumada(1,1) alfas_serie_sumada(3,1) alfas_serie_sumada(4,1)];
distancia_centroide = sqrt(sum((alfas_serie_sumada - centroide_objetivo).^2));
DistCentroide = distancia_centroide;
end

