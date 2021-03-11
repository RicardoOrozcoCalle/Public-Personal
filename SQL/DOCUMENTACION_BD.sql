USE [DATABASE]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--	========================================================================================================================
--	Autor			: @Autor 
--	Fecha Creación	: 2020-05-19
--	Compañia		: IGerencia 
--	========================================================================================================================
--	Nombre View			:	[SCHEMA].[vDocumentacion]
--	Descripción View	:	View con la Documentación General de la Base de Datos
--	Nota View			:	Incluye Tablas, Columnas de Tablas, PKs, FKs, CHEKs, DEFAULTs, UNIQUEs, Vistas,
--							Columnas de Vistas
--	========================================================================================================================
--	Control de Cambios 
--	2020-05-19 Ricardo Orozco Calle (rorozco) -- Creación de la View 
--	========================================================================================================================

ALTER VIEW [SCHEMA].[vDocumentacion]
AS
	SELECT
		ROW_NUMBER() OVER(ORDER BY Ordenes.Indice, Propiedades.IndiceCategoria, Propiedades.NombreUbicacion) AS IndiceDocumentacion,
		CAST(Propiedades.NombreSchema AS VARCHAR(500)) AS NombreSchema,
		CAST(Propiedades.NombreUbicacion AS VARCHAR(500)) AS NombreUbicacion,
		CAST(Propiedades.Nombre AS VARCHAR(500)) AS Nombre,
		CAST(Propiedades.PropiedadNombreSchema AS VARCHAR(500)) AS PropiedadNombreSchema,		
		CAST(Propiedades.PropiedadNombre AS VARCHAR(500)) AS PropiedadNombre,		
		CAST(Propiedades.Descripcion AS VARCHAR(500)) AS Descripcion,	
		CAST(Propiedades.Tipo AS VARCHAR(500)) AS Tipo		
	FROM
	(
		SELECT
			SchemaName AS NombreSchema,
			TableName AS Nombre,
			'' AS NombreUbicacion,
			[Database Schema] AS PropiedadNombreSchema,		
			[Display Name] AS PropiedadNombre,		
			[Description] AS Descripcion,	
			PropertyType AS Tipo,
			ROW_NUMBER() OVER(ORDER BY TableName) AS IndiceCategoria
		FROM
		(
			SELECT 
				'Table' AS PropertyType
				,SCH.name AS SchemaName
				,TBL.name AS TableName
				,SEP.name AS DescriptionType
				,SEP.value AS DescriptionDefinition
			FROM sys.schemas SCH
			INNER JOIN sys.tables TBL ON TBL.schema_id = SCH.schema_id 
			LEFT JOIN sys.extended_properties SEP ON TBL.object_id = SEP.major_id AND SEP.class = 1 AND SEP.minor_id = 0 AND (SEP.value <> '1' AND SEP.value <> 1)
			WHERE SCH.name = 'SCHEMA_NAME'
		) P
		PIVOT (MAX(DescriptionDefinition) FOR DescriptionType IN ([Database Schema], [Display Name], [Description])) AS PivotTable
		UNION ALL
		SELECT
			SchemaName AS NombreSchema,
			ColumnName AS Nombre,
			TableName AS NombreUbicacion,
			[Database Schema] AS PropiedadNombreSchema,		
			[Display Name] AS PropiedadNombre,		
			[Description] AS Descripcion,	
			PropertyType AS Tipo,
			ROW_NUMBER() oVER(ORDER BY TableName, Indice) AS IndiceCategoria
		FROM
		(
			SELECT 
				'Table Column' AS PropertyType
				,SCH.name AS SchemaName
				,TBL.name AS TableName
				,COL.name AS ColumnName
				,SEP.name AS DescriptionType
				,SEP.value AS DescriptionDefinition
				,COL.column_id AS Indice
			FROM sys.schemas SCH
			INNER JOIN sys.tables TBL ON TBL.schema_id = SCH.schema_id
			INNER JOIN sys.columns COL ON COL.object_id = TBL.object_id
			LEFT JOIN sys.extended_properties SEP ON SEP.major_id = COL.object_id AND SEP.minor_id = COL.column_id 
			WHERE SCH.name = 'SCHEMA_NAME'
		) P
		PIVOT (MAX(DescriptionDefinition) FOR DescriptionType IN ([Database Schema], [Description], [Display Name])) AS PivotTable
		UNION ALL
		SELECT
			SchemaName AS NombreSchema,
			PrimaryKeyName AS Nombre,
			TableName AS NombreUbicacion,
			[Database Schema] AS PropiedadNombreSchema,		
			[Display Name] AS PropiedadNombre,		
			[Description] AS Descripcion,	
			PropertyType AS Tipo,
			ROW_NUMBER() OVER(ORDER BY TableName) AS IndiceCategoria
		FROM
		(
			SELECT 
				'Primary Key' AS PropertyType
				,SCH.name AS SchemaName
				,TBL.name AS TableName
				,SKC.name AS PrimaryKeyName
				,SEP.name AS DescriptionType
				,SEP.value AS DescriptionDefinition
				,TBL.object_id AS TableObjectID
				,SKC.object_id AS SubObjectID 
			FROM sys.tables TBL
			INNER JOIN sys.schemas SCH ON TBL.schema_id = SCH.schema_id 
			INNER JOIN sys.key_constraints SKC ON TBL.object_id = SKC.parent_object_id AND SKC.type_desc = N'PRIMARY_KEY_CONSTRAINT'
			FULL OUTER JOIN sys.extended_properties SEP ON SEP.major_id = SKC.object_id  
			WHERE SCH.name = 'SCHEMA_NAME'
		) P
		PIVOT (MAX(DescriptionDefinition) FOR DescriptionType IN ([Database Schema], [Description], [Display Name])) AS PivotTable
		UNION ALL
		SELECT
			SchemaName AS NombreSchema,
			ForeignKeyName AS Nombre,
			TableName AS NombreUbicacion,
			[Database Schema] AS PropiedadNombreSchema,		
			[Display Name] AS PropiedadNombre,		
			[Description] AS Descripcion,
			PropertyType AS Tipo,
			ROW_NUMBER() OVER(ORDER BY TableName, ForeignKeyName) AS IndiceCategoria
		FROM
		(
			SELECT 
				'Foreign Key' AS PropertyType
				,SCH.name AS SchemaName
				,TBL.name AS TableName
				,SFK.name AS ForeignKeyName 
				,SEP.name AS DescriptionType
				,SEP.value AS DescriptionDefinition
			FROM sys.schemas SCH
			INNER JOIN sys.tables TBL ON TBL.schema_id = SCH.schema_id
			INNER JOIN sys.foreign_keys SFK ON SFK.parent_object_id = TBL.object_id 
			LEFT JOIN sys.extended_properties SEP ON SEP.major_id = SFK.object_id 
			WHERE SCH.name = 'SCHEMA_NAME'
		) P
		PIVOT (MAX(DescriptionDefinition) FOR DescriptionType IN ([Database Schema], [Description], [Display Name])) AS PivotTable
		UNION ALL
		SELECT
			SchemaName AS NombreSchema,
			CheckConstraintName AS Nombre,
			TableName AS NombreUbicacion,
			[Database Schema] AS PropiedadNombreSchema,		
			[Display Name] AS PropiedadNombre,		
			[Description] AS Descripcion,	
			PropertyType AS Tipo,
			ROW_NUMBER() OVER(ORDER BY TableName, CheckConstraintName) AS IndiceCategoria
		FROM
		(
			SELECT 
				'Check Constraint' AS PropertyType
				,SCH.name AS SchemaName
				,TBL.name AS TableName
				,CHK.name AS CheckConstraintName
				,SEP.name AS DescriptionType
				,SEP.value AS DescriptionDefinition 
			FROM sys.schemas SCH
			INNER JOIN sys.tables TBL ON SCH.schema_id = TBL.schema_id 
			INNER JOIN sys.check_constraints CHK ON CHK.parent_object_id = TBL.object_id
			LEFT JOIN sys.extended_properties SEP ON SEP.major_id = CHK.object_id 		
			WHERE SCH.name = 'SCHEMA_NAME'
		) P
		PIVOT (MAX(DescriptionDefinition) FOR DescriptionType IN ([Database Schema], [Description], [Display Name])) AS PivotTable
		UNION ALL
		SELECT
			SchemaName AS NombreSchema,
			DefaultConstraintName AS Nombre,
			TableName AS NombreUbicacion,
			[Database Schema] AS PropiedadNombreSchema,		
			[Display Name] AS PropiedadNombre,		
			[Description] AS Descripcion,
			PropertyType AS Tipo,
			ROW_NUMBER() OVER(ORDER BY TableName, DefaultConstraintName) AS IndiceCategoria
		FROM
		(
			SELECT 
				'Default Constraint' AS PropertyType
				,SCH.name AS SchemaName
				,TBL.name AS TableName
				,SDC.name AS DefaultConstraintName
				,SEP.name AS DescriptionType
				,SEP.value AS DescriptionDefinition 
			FROM sys.schemas SCH
			INNER JOIN sys.tables TBL ON SCH.schema_id = TBL.schema_id
			INNER JOIN sys.default_constraints SDC ON SDC.parent_object_id = TBL.object_id
			LEFT JOIN sys.extended_properties SEP ON SDC.object_id = SEP.major_id
			WHERE SCH.name = 'SCHEMA_NAME'
		) P
		PIVOT (MAX(DescriptionDefinition) FOR DescriptionType IN ([Database Schema], [Description], [Display Name])) AS PivotTable
		UNION ALL
		SELECT
			SchemaName AS NombreSchema,
			UniqueConstraintName AS Nombre,
			TableName AS NombreUbicacion,
			[Database Schema] AS PropiedadNombreSchema,		
			[Display Name] AS PropiedadNombre,		
			[Description] AS Descripcion,
			PropertyType AS Tipo,
			ROW_NUMBER() OVER(ORDER BY TableName, UniqueConstraintName) AS IndiceCategoria
		FROM
		(
			SELECT 
				'Unique Constraint' AS PropertyType
				,SCH.name AS SchemaName
				,TBL.name AS TableName
				,SKC.name AS UniqueConstraintName
				,SEP.name AS DescriptionType
				,SEP.value AS DescriptionDefinition 
			FROM sys.schemas SCH 
			INNER JOIN sys.tables TBL ON TBL.schema_id = SCH.schema_id 
			INNER JOIN sys.key_constraints SKC ON TBL.object_id = SKC.parent_object_id AND SKC.type_desc = N'UNIQUE_CONSTRAINT'
			LEFT JOIN sys.extended_properties SEP ON SEP.major_id = SKC.object_id  
			WHERE SCH.name = 'SCHEMA_NAME'
		) P
		PIVOT (MAX(DescriptionDefinition) FOR DescriptionType IN ([Database Schema], [Description], [Display Name])) AS PivotTable
		UNION ALL
		SELECT
			SchemaName AS NombreSchema,
			ViewName AS Nombre,
			'' AS NombreUbicacion,
			[Database Schema] AS PropiedadNombreSchema,		
			[Display Name] AS PropiedadNombre,
			[Description] AS Descripcion,
			PropertyType AS Tipo,
			ROW_NUMBER() OVER(ORDER BY ViewName) AS IndiceCategoria
		FROM
		(
			SELECT 
				'View' AS PropertyType
				,SCH.name AS SchemaName
				,VIW.name AS ViewName
				,SEP.name AS DescriptionType
				,SEP.value AS DescriptionDefinition
			FROM sys.schemas SCH
			INNER JOIN sys.views VIW ON VIW.schema_id = SCH.schema_id 
			LEFT JOIN sys.extended_properties SEP ON SEP.major_id = VIW.object_id AND SEP.class = 1 AND SEP.minor_id = 0 AND (SEP.value <> '1' AND SEP.value <> 1)
			WHERE SCH.name = 'SCHEMA_NAME'
		) P
		PIVOT (MAX(DescriptionDefinition) FOR DescriptionType IN ([Database Schema], [Description], [Display Name])) AS PivotTable
		UNION ALL
		SELECT
			SchemaName AS NombreSchema,
			ColumnName AS Nombre,
			ViewName AS NombreUbicacion,
			[Database Schema] AS PropiedadNombreSchema,		
			[Display Name] AS PropiedadNombre,	
			[Description] AS Descripcion,
			PropertyType AS Tipo,
			ROW_NUMBER() oVER(ORDER BY ViewName, Indice) AS IndiceCategoria
		FROM
		(
			SELECT 
				'View Column' AS PropertyType
				,SCH.name AS SchemaName
				,VIW.name AS ViewName
				,COL.name AS ColumnName
				,SEP.name AS DescriptionType
				,SEP.value AS DescriptionDefinition
				,COL.column_id AS Indice
			FROM sys.schemas SCH
			INNER JOIN sys.views VIW ON VIW.schema_id = SCH.schema_id
			INNER JOIN sys.columns COL ON COL.object_id = VIW.object_id
			LEFT JOIN sys.extended_properties SEP ON SEP.major_id = COL.object_id AND SEP.minor_id = COL.column_id 
			WHERE SCH.name = 'SCHEMA_NAME'
		) P
		PIVOT (MAX(DescriptionDefinition) FOR DescriptionType IN ([Database Schema], [Description], [Display Name])) AS PivotTable
		UNION
		SELECT
			SchemaName AS NombreSchema,
			FunctionName AS Nombre,
			'' AS NombreUbicacion,
			[Database Schema] AS PropiedadNombreSchema,		
			[Display Name] AS PropiedadNombre,	
			[Description] AS Descripcion,	
			PropertyType AS Tipo,
			ROW_NUMBER() OVER(ORDER BY FunctionName) AS IndiceCategoria
		FROM
		(
			SELECT 
				'Function' AS PropertyType
				,SCH.name AS SchemaName
				,SOB.name AS FunctionName
				,SEP.name AS DescriptionType
				,SEP.value AS DescriptionDefinition
			FROM sys.schemas SCH
			INNER JOIN sys.objects SOB ON SOB.schema_id = SCH.schema_id AND SOB.type_desc LIKE N'%FUNCTION%'
			LEFT JOIN sys.extended_properties SEP ON SEP.major_id = SOB.object_id AND SEP.class = 1 AND SEP.minor_id = 0 AND (SEP.value <> '1' AND SEP.value <> 1) 		
			WHERE SCH.name = 'SCHEMA_NAME'
		) P
		PIVOT (MAX(DescriptionDefinition) FOR DescriptionType IN ([Database Schema], [Description], [Display Name])) AS PivotTable
		UNION ALL
		SELECT
			SchemaName AS NombreSchema,
			ParameterName AS Nombre,
			FunctionName AS NombreUbicacion,
			[Database Schema] AS PropiedadNombreSchema,		
			[Display Name] AS PropiedadNombre,
			[Description] AS Descripcion,
			PropertyType AS Tipo,
			ROW_NUMBER() oVER(ORDER BY FunctionName, Indice) AS IndiceCategoria
		FROM
		(
			SELECT 
				'Function Parameter' AS PropertyType
				,SCH.name AS SchemaName
				,SOB.name AS FunctionName
				,PAR.name AS ParameterName
				,SEP.name AS DescriptionType
				,SEP.value AS DescriptionDefinition
				,PAR.parameter_id AS Indice
			FROM sys.schemas SCH
			INNER JOIN sys.objects SOB ON SOB.schema_id = SCH.schema_id AND SOB.type_desc LIKE N'%FUNCTION%'
			INNER JOIN sys.parameters PAR ON PAR.object_id = SOB.object_id 				
			LEFT JOIN sys.extended_properties SEP ON SEP.major_id = PAR.object_id AND SEP.minor_id = PAR.parameter_id AND SEP.class_desc = 'PARAMETER'	
			WHERE SCH.name = 'SCHEMA_NAME' AND PAR.parameter_id != 0
		) P
		PIVOT (MAX(DescriptionDefinition) FOR DescriptionType IN ([Database Schema], [Description], [Display Name])) AS PivotTable
		UNION ALL
		SELECT
			SchemaName AS NombreSchema,
			ProcedureName AS Nombre,
			'' AS NombreUbicacion,
			[Database Schema] AS PropiedadNombreSchema,		
			[Display Name] AS PropiedadNombre,	
			[Description] AS Descripcion,
			PropertyType AS Tipo,
			ROW_NUMBER() OVER(ORDER BY ProcedureName) AS IndiceCategoria
		FROM
		(
			SELECT 
				'Procedure' AS PropertyType
				,SCH.name AS SchemaName
				,PRC.name AS ProcedureName
				,SEP.name AS DescriptionType
				,SEP.value AS DescriptionDefinition
			FROM sys.schemas SCH
			INNER JOIN sys.procedures PRC ON PRC.schema_id = SCH.schema_id
			LEFT JOIN sys.extended_properties SEP ON SEP.major_id = PRC.object_id AND SEP.class = 1 AND SEP.minor_id = 0 		  
			WHERE SCH.name = 'SCHEMA_NAME'
		) P
		PIVOT (MAX(DescriptionDefinition) FOR DescriptionType IN ([Database Schema], [Description], [Display Name])) AS PivotTable
		UNION ALL
		SELECT
			SchemaName AS NombreSchema,
			ParameterName AS Nombre,
			ProcedureName AS NombreUbicacion,
			[Database Schema] AS PropiedadNombreSchema,		
			[Display Name] AS PropiedadNombre,	
			[Description] AS Descripcion,	
			PropertyType AS Tipo,
			ROW_NUMBER() oVER(ORDER BY ProcedureName, Indice) AS IndiceCategoria
		FROM
		(
			SELECT 
				'Procedure Parameter' AS PropertyType
				,SCH.name AS SchemaName
				,SPR.name AS ProcedureName
				,PAR.name AS ParameterName
				,SEP.name AS DescriptionType
				,SEP.value AS DescriptionDefinition
				,PAR.parameter_id AS Indice
			FROM sys.schemas SCH
			INNER JOIN sys.procedures SPR ON SPR.schema_id = SCH.schema_id 
			INNER JOIN sys.parameters PAR ON PAR.object_id = SPR.object_id 				
			LEFT JOIN sys.extended_properties SEP ON SEP.major_id = PAR.object_id AND SEP.minor_id = PAR.parameter_id				
			WHERE SCH.name = 'SCHEMA_NAME' 
		) P
		PIVOT (MAX(DescriptionDefinition) FOR DescriptionType IN ([Database Schema], [Description], [Display Name])) AS PivotTable
	) AS Propiedades
	INNER JOIN
	(
		SELECT 'Table' AS Tipo, 1 AS Indice UNION
		SELECT 'Table Column' AS Tipo, 2 AS Indice UNION
		SELECT 'Primary Key' AS Tipo, 3 AS Indice UNION
		SELECT 'Foreign Key' AS Tipo, 4 AS Indice UNION
		SELECT 'Default Constraint' AS Tipo, 5 AS Indice UNION
		SELECT 'Unique Constraint' AS Tipo, 6 AS Indice UNION
		SELECT 'Check Constraint' AS Tipo, 7 AS Indice UNION
		SELECT 'View' AS Tipo, 8 AS Indice UNION
		SELECT 'View Column' AS Tipo, 9 AS Indice UNION
		SELECT 'Function' AS Tipo, 10 AS Indice UNION
		SELECT 'Function Parameter' AS Tipo, 11 AS Indice UNION
		SELECT 'Procedure' AS Tipo, 12 AS Indice UNION
		SELECT 'Procedure Parameter' AS Tipo, 13 AS Indice
	) AS Ordenes
		ON Propiedades.[Tipo] = Ordenes.[Tipo]

GO


