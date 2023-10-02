--A.	Listado de cuantas licencias médicas ha tenido cada trabajador con COVID por cada empresa con contrato vigente. (Columnas resultantes: nombre empresa, nombre trabajador, cantidad licencias).
SELECT e.nombre_empresa, t.nombre_trabajador, COUNT(l.id_licencia) AS cantidad_licencias
FROM licencias_medicas l
JOIN trabajadores t ON l.id_trabajador = t.id_trabajador
JOIN empresas e ON l.id_empresa = e.id_empresa
WHERE t.estado = 'ACTIVO'
AND e.estado = 'ACTIVO'
GROUP BY e.nombre_empresa, t.nombre_trabajador
--B.	Listar empresas las cuales no tienen trabajadores vigentes, pero si han tenido al menos una licencia médica. (Columnas resultantes: rut empresa, nombre empresa).
SELECT e.rut_empresa, e.nombre_empresa
FROM empresas e
LEFT JOIN licencias_medicas l ON e.id_empresa = l.id_empresa
WHERE l.id_licencia IS NULL
AND e.estado = 'ACTIVO'
GROUP BY e.rut_empresa, e.nombre_empresa
--C.	Listar cantidad de licencias médicas y el monto reembolsado, por cada empresa, por año a partir del 2015. (Columnas resultantes: nombre empresa, año, cantidad licencias, monto reembolsado).
SELECT e.nombre_empresa, l.anio, COUNT(l.id_licencia) AS cantidad_licencias, SUM(l.monto_reembolsado) AS monto_reembolsado
FROM licencias_medicas l
JOIN empresas e ON l.id_empresa = e.id_empresa
WHERE l.anio >= 2015
AND e.estado = 'ACTIVO'
GROUP BY e.nombre_empresa, l.anio
--D.	Lista de trabajadores que tienen contrato vigente, en al menos una empresa, y han tenido licencia médica continua desde el inicio del año actual junto con la cantidad de licencias que lleva. (Columnas resultantes: rut trabajador, nombre trabajador, cantidad licencias).
SELECT t.rut_trabajador, t.nombre_trabajador, COUNT(l.id_licencia) AS cantidad_licencias
FROM licencias_medicas l
JOIN trabajadores t ON l.id_trabajador = t.id_trabajador
JOIN empresas e ON l.id_empresa = e.id_empresa
WHERE t.estado = 'ACTIVO'
AND e.estado = 'ACTIVO'
AND l.fecha_inicio >= CONCAT(YEAR(NOW()), '-01-01')
AND l.fecha_termino IS NULL
GROUP BY t.rut_trabajador, t.nombre_trabajador
-- E.	Promedio de renta pagada por cada empresa, asumiendo que las rentas se almacenan con la key “renta1” a “rentaN”. (Columnas resultantes: rut empresa, nombre empresa, promedio de rentas).
SELECT e.rut_empresa, e.nombre_empresa, AVG(l.renta1 + l.renta2 + l.renta3) AS promedio_de_rentas
FROM licencias_medicas l
JOIN empresas e ON l.id_empresa = e.id_empresa
WHERE e.estado = 'ACTIVO'
GROUP BY e.rut_empresa, e.nombre_empresa

-- F.	Listado de cada empresa, solo con los 3 trabajadores que han tenido los mayores reembolsos, ordenándolos de mayor a menor e indicando su posición (1,2 o 3). (Columnas resultantes: nombre empresa, rut trabajador, nombre trabajador, monto reembolsado, posición).
SELECT e.nombre_empresa, t.rut_trabajador, t.nombre_trabajador, SUM(l.renta1 + l.renta2 + l.renta3) AS monto_reembolsado,
DENSE_RANK() OVER (PARTITION BY e.nombre_empresa ORDER BY monto_reembolsado DESC) AS posicion
FROM licencias_medicas l
JOIN trabajadores t ON l.id_trabajador = t.id_trabajador
JOIN empresas e ON l.id_empresa = e.id_empresa
WHERE t.estado = 'ACTIVO'
AND e.estado = 'ACTIVO'
AND l.fecha_inicio >= CONCAT(YEAR(NOW()), '-01-01')
AND l.fecha_termino IS NULL
GROUP BY e.nombre_empresa, t.rut_trabajador, t.nombre_trabajador
ORDER BY monto_reembolsado DESC
LIMIT 3;
-- G.	Lista de trabajadores que tienen licencia medica vigente, con su monto reembolsado y las 3 primeras rentas que se almacenaron para el calculo de su reembolso. (Columnas resultantes: rut trabajador, nombre trabajador, monto reembolsado, renta1, renta2, renta3).
SELECT t.rut_trabajador, t.nombre_trabajador, SUM(l.renta1 + l.renta2 + l.renta3) AS monto_reembolsado, l.renta1, l.renta2, l.renta3
FROM licencias_medicas l
JOIN trabajadores t ON l.id_trabajador = t.id_trabajador
JOIN empresas e ON l.id_empresa = e.id_empresa
WHERE t.estado = 'ACTIVO'
AND e.estado = 'ACTIVO'
AND l.fecha_inicio >= CONCAT(YEAR(NOW()), '-01-01')
AND l.fecha_termino IS NULL
GROUP BY t.rut_trabajador, t.nombre_trabajador
ORDER BY monto_reembolsado DESC
LIMIT 3;
