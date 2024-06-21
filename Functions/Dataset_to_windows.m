function [semana_en_dias,ventanas_15mins,alpha_params] = Dataset_to_windows(dataset_orig)

primer_valor_tiempo = dataset_orig(1,1);
ultimo_valor_tiempo = dataset_orig(length(dataset_orig(:,1)),1); 
tiempo = linspace(primer_valor_tiempo, ultimo_valor_tiempo, length(dataset_orig(:,1)));  % Vector de tiempo en segundos

% Convertir tiempo a formato de fecha
fecha_inicio = datetime(primer_valor_tiempo, 'ConvertFrom', 'posixtime', 'Format', 'yyyy-MM-dd HH:mm:ss');
fecha_fin = datetime(ultimo_valor_tiempo, 'ConvertFrom', 'posixtime', 'Format', 'yyyy-MM-dd HH:mm:ss');
fechas = datetime(tiempo, 'ConvertFrom', 'posixtime', 'Format', 'yyyy-MM-dd HH:mm:ss');

% Ajusta las fechas una hora hacia adelante por el horario de verano
fechas_ajustadas = fechas + hours(2);

% Enventanar los datasets
% Cambiado para usar los 5 dias laborables de cada semana
semana_paquetes = dataset_orig(:,3);
longitudSubvector = floor(length(semana_paquetes) / 7);
semana_en_dias = reshape(semana_paquetes(1:7 * longitudSubvector), longitudSubvector, 7);
alpha_params = cell(1, 5);
for i=1:5
    % Ventanas a partir de las 11:00 de Lunes a Viernes (muestra 39.622), se hacen
    % ventanas de 15 minutos (900 muestras)
    num_ventanas = 8;
    indice = round(length(semana_en_dias)/24*11); 
    for j=1:num_ventanas
        ventanas_15mins(:,j) = enventanar(indice,semana_en_dias(:,i));
        indice = indice + 900;
    end
    
    % Aquí podemos observar que por media conjunta de Paquetes/s, la ventana 1,
    % 5 y 6 son las que mayor tráfico conjunto tienen, en ese orden.
    
    % Parámetros Alfa - estables, crea una matriz con los parámetros
    % alfaestables de las ventanas de 15 minutos previamente creadas y los
    % guarda en 4 filas de 8 columnas (una columna por cada ventana)
    %   [alpha1 alpha2 alpha3 ... alpha8] 
    %   [beta1  beta2  beta3  ... beta8] 
    %   [gamma1 gamma2 gamma3 ... gamma8] 
    %   [delta1 delta2 delta3 ... delta8] 
    alpha_params{i} = alphas(ventanas_15mins,num_ventanas);

end
