CREATE PROCEDURE [dbo].[edit_venue_table] (
	@venue_table_id INT,
	@venue_table_number INT,
	@venue_table_capacity INT
)
AS
BEGIN
	IF (@venue_table_number IS NOT NULL)
		BEGIN
		UPDATE [dbo].[venue_tables] SET venue_table_num = @venue_table_number WHERE venue_table_id = @venue_table_id;
		END
	IF (@venue_table_capacity IS NOT NULL)
		BEGIN
		UPDATE [dbo].[venue_tables] SET venue_table_capacity = @venue_table_capacity WHERE venue_table_id = @venue_table_id;
		END
END
GO