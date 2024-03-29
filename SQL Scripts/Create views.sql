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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[app_bookings_view] AS

SELECT 
bookings.booking_id,
booking_time,
booking_size, 
booking_attended,
booking_attendees.customer_id,
venues.venue_id,
venue_name,
venue_postcode,
venue_tables.venue_table_id,
venue_table_num,
venue_table_capacity,
add_line_one,
add_line_two,
city,
county

FROM bookings, booking_attendees, venues, venue_tables, customers

WHERE bookings.venue_id = venues.venue_id
AND bookings.venue_table_id = venue_tables.venue_table_id
AND booking_attendees.booking_id = bookings.booking_id
AND customers.customer_id = booking_attendees.customer_id
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[web_bookings_view] AS

SELECT

venue_id,
customer_name,
customer_contact_number,
booking_time,
staff_name,
staff_contact_num

FROM 
bookings,
booking_attendees,
customers,
staff

WHERE bookings.booking_id = booking_attendees.booking_id
AND bookings.staff_id = staff.staff_id
AND booking_attendees.customer_id = customers.customer_id
GO
