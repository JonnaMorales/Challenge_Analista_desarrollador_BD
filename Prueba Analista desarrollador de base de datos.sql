--A.
SELECT e.nombre_empresa, t.nombre_trabajador, COUNT(l.id_licencia) AS cantidad_licencias
FROM licencias_medicas l
JOIN trabajadores t ON l.id_trabajador = t.id_trabajador
JOIN empresas e ON l.id_empresa = e.id_empresa
WHERE t.estado = 'ACTIVO'
AND e.estado = 'ACTIVO'
GROUP BY e.nombre_empresa, t.nombre_trabajador
--B.
SELECT e.rut_empresa, e.nombre_empresa
FROM empresas e
LEFT JOIN licencias_medicas l ON e.id_empresa = l.id_empresa
WHERE l.id_licencia IS NULL
AND e.estado = 'ACTIVO'
GROUP BY e.rut_empresa, e.nombre_empresa
--C.
SELECT e.nombre_empresa, l.anio, COUNT(l.id_licencia) AS cantidad_licencias, SUM(l.monto_reembolsado) AS monto_reembolsado
FROM licencias_medicas l
JOIN empresas e ON l.id_empresa = e.id_empresa
WHERE l.anio >= 2015
AND e.estado = 'ACTIVO'
GROUP BY e.nombre_empresa, l.anio
--D.
SELECT t.rut_trabajador, t.nombre_trabajador, COUNT(l.id_licencia) AS cantidad_licencias
FROM licencias_medicas l
JOIN trabajadores t ON l.id_trabajador = t.id_trabajador
JOIN empresas e ON l.id_empresa = e.id_empresa
WHERE t.estado = 'ACTIVO'
AND e.estado = 'ACTIVO'
AND l.fecha_inicio >= CONCAT(YEAR(NOW()), '-01-01')
AND l.fecha_termino IS NULL
GROUP BY t.rut_trabajador, t.nombre_trabajador
-- E.
SELECT e.rut_empresa, e.nombre_empresa, AVG(l.renta1 + l.renta2 + l.renta3) AS promedio_de_rentas
FROM licencias_medicas l
JOIN empresas e ON l.id_empresa = e.id_empresa
WHERE e.estado = 'ACTIVO'
GROUP BY e.rut_empresa, e.nombre_empresa

-- F.
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
-- G.
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
