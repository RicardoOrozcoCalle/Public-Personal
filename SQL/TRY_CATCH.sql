DECLARE @cantRegistros INT
BEGIN TRY

    BEGIN TRAN

        SELECT @cantRegistros =  @@ROWCOUNT

    COMMIT TRAN        

END TRY
BEGIN CATCH

    ROLLBACK TRAN

    SELECT @cantRegistros =  0

END CATCH