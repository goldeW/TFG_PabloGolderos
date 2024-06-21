function [vectorWeek] = Carga_y_plotea_week(vectorWeek_orig)

primer_valor_tiempo = vectorWeek_orig(1,1);
ultimo_valor_tiempo = vectorWeek_orig(length(vectorWeek_orig(:,1)),1); 
tiempo = linspace(primer_valor_tiempo, ultimo_valor_tiempo, length(vectorWeek_orig(:,1)));  % Vector de tiempo en segundos

% Convertir tiempo a formato de fecha
fecha_inicio = datetime(primer_valor_tiempo, 'ConvertFrom', 'posixtime', 'Format', 'yyyy-MM-dd HH:mm:ss');
fecha_fin = datetime(ultimo_valor_tiempo, 'ConvertFrom', 'posixtime', 'Format', 'yyyy-MM-dd HH:mm:ss');
fechas = datetime(tiempo, 'ConvertFrom', 'posixtime', 'Format', 'yyyy-MM-dd HH:mm:ss');
% Ajusta las fechas una hora hacia adelante por el horario de verano
fechas_ajustadas = fechas + hours(2);

% Graficar los datos en función de las fechas
figure;
plot(fechas_ajustadas, vectorWeek_orig(:,3));
legend('Tráfico en paquetes/s', 'FontSize', 14, 'FontWeight', 'bold')
% Configurar el formato de los ejes
grid on;
xlabel('Fecha y Hora', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Datos(paquetes)', 'FontSize', 16, 'FontWeight', 'bold');
title('Flujo de paquetes may week 3', 'FontSize', 16, 'FontWeight', 'bold');

% Establecer el formato del eje x en días y horas
ax = gca;
ax.FontSize = 14; % Cambiar el tamaño de la letra de los ejes
ax.FontWeight = 'bold'; % Poner en negrita la letra de los ejes
ax.XAxis.TickLabelFormat = 'MM-dd HH:mm'; % cambia el formato de eje x
datetick('x', 'keepLimits');

semana_paquetes = vectorWeek_orig(:,3);
longitudSubvector = floor(length(semana_paquetes) / 7);
semana_en_dias = reshape(semana_paquetes(1:7 * longitudSubvector), longitudSubvector, 7);

vectorWeek = [semana_en_dias(:,1) semana_en_dias(:,2)];
end

