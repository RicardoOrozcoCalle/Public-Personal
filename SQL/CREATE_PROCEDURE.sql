SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--	========================================================================================================================
--	Autor			: rorozco 
--	Fecha Creación	: AAAA-MM-DD
--	Compañia		: IGerencia 
--	========================================================================================================================
--	Nombre Stored Procedure			:	NombreStoredProcedure
--	Descripción Stored Procedure	:	DescripcionStoredProcedure
--	Parámetros Stored Procedure		:
--		*	Parámetro_1
--			-	Descripción_Parámetro_1
--		*	Parámetro_2
--			-	Descripción_Parámetro_2
--		*	Parámetro_3
--			-	Descripción_Parámetro_3
--	Nota Stored Procedure			:	NotaStoredProcedure
--	========================================================================================================================
--	Control de Cambios 
--	AAAA-MM-DD Ricardo Orozco Calle (rorozco) -- Creación del Stored Procedure 
--	========================================================================================================================

CREATE PROCEDURE <Procedure_Name, sysname, ProcedureName> 

--	Parámetros
--		@Param1
--		@Param2

AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>

END
GO
