function [ventana_alto_trafico] = enventanar_max(indice_maximo,dia_entero)
% Define el rango de índices para las 300 muestras alrededor del máximo
indices_de_maximos = indice_maximo - 450 : indice_maximo + 449;
% Asegúrate de que el rango de índices esté dentro de los límites del vector
rango_indices = max(1, min(indices_de_maximos, length(dia_entero)));
% Crea un nuevo vector con las 300 muestras alrededor del máximo
ventana_alto_trafico = dia_entero(rango_indices);
end

