function [vector_dias] = weekToDays(data_semana)
% Funcion que divide un dataset de una semana en una matriz de (tamano_dia x 7)
longitudSubvector = floor(length(data_semana) / 7);
vector_dias = reshape(data_semana(1:7 * longitudSubvector), longitudSubvector, 7);
end


