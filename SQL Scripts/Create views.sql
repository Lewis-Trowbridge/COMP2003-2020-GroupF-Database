SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[app_venue_view] AS

SELECT 
venues.venue_id,
venue_name,
venue_postcode,
add_line_one,
add_line_two,
city, 
county,
ISNULL(SUM(venue_table_capacity), 0) AS total_capacity

FROM venues

LEFT OUTER JOIN venue_tables ON venues.venue_id=venue_tables.venue_id

GROUP BY venues.venue_id, venue_name, venue_postcode, add_line_one, add_line_two, city, county
GO
