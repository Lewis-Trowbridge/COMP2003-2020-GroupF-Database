CREATE PROCEDURE [dbo].[add_venue_table] (
	@venue_id INT,
	@venue_table_number INT,
	@venue_table_capacity INT
)
AS
BEGIN
	INSERT INTO venue_tables (venue_id, venue_table_num, venue_table_capacity) VALUES (@venue_id, @venue_table_number, @venue_table_capacity);
END
GO