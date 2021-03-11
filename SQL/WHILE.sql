
DECLARE @numIte INT      --  Número de Iteraciones
DECLARE @iter INT        --  Iterador 



--  Consultar el Máximo Indice y el Indice Inicial para las Iteraciones
SELECT
@numIte = MAX(indice),
@Iter = MIN(indice)
FROM @tablaIndicador

--  Iterando por cada Vigencia del Indicador
WHILE @Iter < @numIte
BEGIN


--  Incrementar el Ciclo
SET @Iter = @Iter + 1
END