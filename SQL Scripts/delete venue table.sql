CREATE PROCEDURE [dbo].[delete_venue_table] (
	@venue_table_id INT
)
AS
BEGIN
	DELETE FROM [dbo].[venue_tables] WHERE venue_table_id = @venue_table_id;
END
GO