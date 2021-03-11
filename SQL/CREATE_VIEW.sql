SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--	========================================================================================================================
--	Autor			: rorozco 
--	Fecha Creación	: AAAA-MM-DD
--	Compañia		: IGerencia 
--	========================================================================================================================
--	Nombre View			:	NombreView
--	Descripción View	:	DescripcionView
--	Nota View			:	NotaView
--	========================================================================================================================
--	Control de Cambios 
--	AAAA-MM-DD Ricardo Orozco Calle (rorozco) -- Creación de la View 
--	========================================================================================================================

CREATE VIEW <schema_name, sysname, dbo>.<view_name, sysname, Top10Sales>
AS

	<select_statement, , SELECT TOP 10 * FROM Sales.SalesOrderHeader ORDER BY TotalDue DESC>

GO