# TFG_PabloGolderos
Hey! I'm Pablo Golderos Espadas, I'm a Telecommunications Engineer and this is my TFG (final degree project) about "Generation of time series of network traffic attacks with alpha-stable distributions".

Files:
- Representación.m -> Contains the first part of the job excluding the extraction of the data to text format. This program contains from the data loading to the production of the final_data. The representation, packaging and characterization of alpha-stables in functions is performed in order not to overload the file. The formats in which the information is grouped and saved are described in the Matlab script itself. After producing the attack time series, the final_data are exported and detectability checks are performed in the following program.
- Analytic_studio.m -> Contains a first part in which the Flash-crowd image is generated for memory, and later a scrpit that generates plateau type attacks (only run if you want to test, but for the comparative part, skip and import the final data). From here, the rest of the scripts are checks and detectability evaluation of the imported attacks.
- Test_CFs.m -> This program has no impact on the TFG, it is "frustrated tests" of trying to evaluate the attack detectability using CF's (Characteristic Functions). It is left uploaded in case it is useful.
- Functions (folder) -> Contains all the functions used in the previous scripts.
- Datos_finales (folder) -> Contains the data exported from Representation.m. It is important to emphasize that, when generating series in Matlab, each time the "random" command is executed, no matter how much the statistical distribution object passed to it is the same, the results may differ slightly from each other. Therefore, these are the data with which the detectability evaluation was performed.
- Distribution_Fitter (folder) -> These are the .dfit sessions generated with this tool in Matlab.


Archivos:
- Representación.m -> Contiene la primera parte del trabajo sin contar la extracción de los datos a formato de texto. Este programa contiene desde la carga de datos hasta la producción de los Datos_finales. Se realiza la representación, enventanado y caracterización de alfa-estables en funciones para no sobrecargar el fichero. Los formatos en los que se va agrupando y guardando la información están descritos sobre el propio script de Matlab. Tras llegar a producir las series temporales de ataque, se exportan los Datos_finales y se realizan comprobaciones a cerca de la detectabilidad en el siguiente programa.
- Analytic_studio.m -> Contiene una primera parte en la que se genera la imagen del Flash-crowd para la memoria, y más adelante un scrpit que genera ataques de tipo meseta (solo ejecutar si se quieren hacer pruebas, pero para la parte de comparativa, saltar e importar los datos finales). A partir de aquí, el respo de scripts son comprobaciones y evaluación de detectabilidad de los ataques importados.
- Test_CFs.m -> Este programa no ha tenido impacto en al TFG, son "pruebas frustradas" de intentar evaluar la detectabilidad del ataque utilizando CF's (Funciones Características). Se deja subido por si fuera de utilidad.
- Functions (carpeta) -> Contiene todas las funciones utilizadas en los scripts anteriores.
- Datos_finales (carpeta) -> Contiene los datos exportados de Representacion.m. Es importante recalcar que, al generar series en Matlab, cada vez que se ejecuta el comando "random", por mucho que el objeto de distribución estadística que se le pase sea el mismo, los resultados pueden distar entre si ligeramente. Por tanto, estos son los datos con los que se realizó la evaluación de detectabilidad.
- Distribution_Fitter (carpeta) -> Son las sesiones .dfit generadas con dicha herramienta en Matlab.




