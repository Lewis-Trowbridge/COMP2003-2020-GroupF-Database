-- Start Admin Controller 
-- Add admin

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[add_admin] (
    
    @admin_username VARCHAR (50),
    @admin_password VARCHAR (255),
    @response VARCHAR(max) OUTPUT
)

AS 
BEGIN
    BEGIN TRANSACTION

        BEGIN TRY

            DECLARE @admin_id INT;

            INSERT INTO dbo.admins
                (admin_username, admin_password)
            VALUES 
                (@admin_username, @admin_password)

            SET @admin_id = CAST(SCOPE_IDENTITY() AS VARCHAR(MAX))

            SET @response = CONCAT('200 ', @admin_id)

            IF @@TRANCOUNT > 0
                    COMMIT

        END TRY
        BEGIN CATCH
                SET @response = '500'
                IF @@TRANCOUNT > 0 BEGIN
                ROLLBACK TRANSACTION
                END
        END CATCH
END
GO

-- Edit admin

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[edit_admin] (@admin_id INT, 
    @admin_username VARCHAR (50),
    @admin_password VARCHAR (255),
    @response VARCHAR(MAX) OUTPUT)
AS
BEGIN
    BEGIN TRY   

        SET @response = '404';
	    IF(@admin_id IS NOT NULL AND @admin_id !=0 AND (SELECT COUNT(admin_id) FROM admins WHERE admin_id = @admin_id) > 0)
        BEGIN        
    BEGIN TRANSACTION

        IF (@admin_username IS NOT NULL AND @admin_username != '')
        BEGIN
            UPDATE admins
            SET admin_username = @admin_username
            WHERE admins.admin_id = @admin_id
        END
        IF (@admin_password IS NOT NULL AND @admin_password != '')
        BEGIN
            UPDATE admins
            SET admin_password = @admin_password
            WHERE admins.admin_id = @admin_id
        END
		
        SET @response = '200';

        IF @@TRANCOUNT > 0
        COMMIT TRANSACTION
		
        END
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION
        SET @response = '500';
		
    END CATCH
END
GO

-- Delete Admin

CREATE PROCEDURE [dbo].[delete_admin](
	@admin_id int
	)
AS
BEGIN
BEGIN TRANSACTION
BEGIN TRY

DECLARE @error NVARCHAR(MAX)

DELETE FROM dbo.admins WHERE admin_id = @admin_id
DELETE FROM dbo.admin_locations WHERE admin_id = @admin_id

IF @@TRANCOUNT > 0 
    COMMIT
END TRY
BEGIN CATCH
SET @error = 'error'
    IF @@TRANCOUNT > 0 BEGIN
        ROLLBACK TRANSACTION
        END
    RAISERROR (@error,1,0)
END CATCH
END

-- **** End Admin Controller ****

-- Add error

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[add_error]

@flag_title VARCHAR(450),
@flag_location_page VARCHAR(450),
@flag_category VARCHAR(450),
@flag_persistent BIT,
@flag_urgency INT,
@flag_desc VARCHAR(2000),
@flag_venue_id INT, 
@flag_date DATETIME,
@flag_resolved BIT

AS

BEGIN

INSERT INTO flags ( flag_title, flag_location_page, 
flag_category,flag_persistent, flag_urgency, 
flag_desc, flag_venue_id, flag_date, flag_resolved)

VALUES ( @flag_title, @flag_location_page, 
@flag_category, @flag_persistent, @flag_urgency, 
@flag_desc, @flag_venue_id, @flag_date, @flag_resolved)


END;
GO
-- **** Start StaffController Procedure ****
-- Add staff
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[add_staff](
    @staff_name VARCHAR(50),
    @staff_contact_num VARCHAR(15),
    @staff_position VARCHAR(10),
    @venue_id INT
)
AS
BEGIN
BEGIN TRANSACTION
BEGIN TRY

DECLARE @error NVARCHAR(MAX)
DECLARE @staff_id INT

INSERT INTO dbo.staff
(
    staff_name, staff_contact_num, staff_position
)
VALUES
(
    @staff_name, @staff_contact_num, @staff_position
)
INSERT INTO dbo.employment
(
    venue_id, staff_id
)
VALUES
(
    @venue_id, SCOPE_IDENTITY()
)

IF @@TRANCOUNT > 0 
    COMMIT
END TRY
BEGIN CATCH
SET @error = 'error'
    IF @@TRANCOUNT > 0 BEGIN
        ROLLBACK TRANSACTION
        END
    RAISERROR (@error,1,0)
END CATCH
END
GO

-- Edit staff
CREATE PROCEDURE [dbo].[edit_staff](
	@staff_id INT,
	@staff_name VARCHAR(50),
    @staff_contact_num	VARCHAR(15),
    @staff_position VARCHAR(10)
	)
AS
BEGIN
BEGIN TRANSACTION
BEGIN TRY
DECLARE @error NVARCHAR(MAX)

UPDATE dbo.staff
SET	
	staff_name = @staff_name,
	staff_contact_num = @staff_contact_num,
	staff_position = @staff_position
WHERE
	staff_id = @staff_id
IF @@TRANCOUNT > 0 
    COMMIT
END TRY
BEGIN CATCH
SET @error = 'error'
    IF @@TRANCOUNT > 0 BEGIN
        ROLLBACK TRANSACTION
        END
    RAISERROR (@error,1,0)
END CATCH
END

GO

-- Delete staff

CREATE PROCEDURE [dbo].[delete_staff](
	@staff_id int
	)
AS
BEGIN
BEGIN TRANSACTION
BEGIN TRY

DECLARE @error NVARCHAR(MAX)

DELETE FROM dbo.staff WHERE staff_id = @staff_id
DELETE FROM dbo.employment WHERE staff_id = @staff_id

IF @@TRANCOUNT > 0 
    COMMIT
END TRY
BEGIN CATCH
SET @error = 'error'
    IF @@TRANCOUNT > 0 BEGIN
        ROLLBACK TRANSACTION
        END
    RAISERROR (@error,1,0)
END CATCH
END

GO

-- **** End StaffController Procedure ****

-- **** Start CustomersController procedures ****

-- Add customer

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[add_customer] (
    @customer_name VARCHAR(50),
    @customer_contact_number VARCHAR(15),
    @customer_username VARCHAR (50),
    @customer_password VARCHAR (255),
    @response_message VARCHAR(MAX) OUTPUT
)
AS
BEGIN
BEGIN TRANSACTION

    BEGIN TRY

        INSERT INTO dbo.customers(customer_name, customer_contact_number, customer_username, customer_password)
        VALUES
        (@customer_name, @customer_contact_number, @customer_username, @customer_password)
		
		DECLARE @customer_id VARCHAR(MAX)

		SELECT @customer_id = CAST(SCOPE_IDENTITY() AS VARCHAR(MAX))
		
        SET @response_message = CONCAT('200 ', @customer_id)

        IF @@TRANCOUNT > 0 COMMIT
		
    END TRY

    BEGIN CATCH
		
		DECLARE @existing_username VARCHAR(MAX)
		
		SELECT @existing_username = customer_username FROM customers WHERE customer_username = @existing_username
		
		IF ISNULL(@existing_username, 'username already exists') = 'username already exists'
		BEGIN
			SET @response_message = '208'
		END
		ELSE
		BEGIN
			SET @response_message = '500'
		END

        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
		

    END CATCH
END
    
    
GO

-- Delete customer

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delete_customer] (
    @customer_id INT,
    @response VARCHAR(MAX) OUTPUT
)
AS

BEGIN

    BEGIN TRANSACTION

        BEGIN TRY

            DECLARE @existing_customer INT
            SELECT @existing_customer = customer_id FROM customers WHERE customer_id = @customer_id
            IF ISNULL(@existing_customer, -1) = -1
            BEGIN
                SET @response = '404'

                IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
            END
            ELSE
            BEGIN
                DELETE FROM customers WHERE customers.customer_id = @customer_id

                SET @response = '200'

                IF @@TRANCOUNT > 0 COMMIT
            END
        
        END TRY
        BEGIN CATCH
            SET @response = '500'
			
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        END CATCH

END
GO

-- Edit customer
CREATE PROCEDURE [dbo].[edit_customer] (@customer_id INT, 
    @customer_name VARCHAR(50),
    @customer_contact_number VARCHAR(15),
    @customer_username VARCHAR (50),
    @customer_password VARCHAR (255),
    @response_message INT OUTPUT)
AS
BEGIN
BEGIN TRANSACTION
    BEGIN TRY   

        SET @response_message = 404;
	    

        IF (@customer_name IS NOT NULL AND @customer_name != '')
        BEGIN
            UPDATE customers
            SET customer_name = @customer_name
            WHERE customers.customer_id = @customer_id
        END
        IF (@customer_contact_number IS NOT NULL AND @customer_contact_number != '')
        BEGIN
            UPDATE customers
            SET customer_contact_number = @customer_contact_number
            WHERE customers.customer_id = @customer_id
        END
        IF (@customer_username IS NOT NULL AND @customer_username != '')
        BEGIN
            UPDATE customers
            SET customer_username = @customer_username
            WHERE customers.customer_id = @customer_id
        END
        IF (@customer_password IS NOT NULL AND @customer_password != '')
        BEGIN
            UPDATE customers
            SET customer_password = @customer_password
            WHERE customers.customer_id = @customer_id
        END
		
        SET @response_message = 200;

        COMMIT;
		
    END TRY

    BEGIN CATCH

        SET @response_message = 500;
        ROLLBACK TRANSACTION;
		

    END CATCH
END
GO

-- End Edit customer

-- **** End CustomersController procedures ****

-- **** Start VenueController procedures ****

-- Add venue
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[add_venue] (
    @venue_name VARCHAR (50),
    @add_line_one VARCHAR (100),
    @add_line_two VARCHAR (100),
    @venue_postcode VARCHAR (10),
    @city VARCHAR (50),
    @county VARCHAR (50),
    @admin_id INT,
    @venue_id INT OUTPUT
)
AS 
BEGIN
BEGIN TRANSACTION
BEGIN TRY

DECLARE @error NVARCHAR(MAX)
DECLARE @id_vaule INT

INSERT INTO dbo.venues
    (venue_name, add_line_one, add_line_two, venue_postcode, city, county)
VALUES 
    (@venue_name, @add_line_one, @add_line_two, @venue_postcode, @city, @county)

SET @id_vaule = SCOPE_IDENTITY()

INSERT INTO dbo.admin_locations
    (venue_id, admin_id)
VALUES
    (@id_vaule, @admin_id)

 IF @@TRANCOUNT > 0
        COMMIT
SET @venue_id = @id_vaule
END TRY
BEGIN CATCH
SET @error = 'error'
    IF @@TRANCOUNT > 0 BEGIN
      ROLLBACK TRANSACTION
      END
    RAISERROR (@error, 1,0)
END CATCH
END
GO
-- Edit Venue
CREATE PROCEDURE [dbo].[edit_venue](
	@venue_id INT,
	@venue_name VARCHAR(50),
	@venue_postcode VARCHAR(10),
	@add_line_one VARCHAR(100),
	@add_line_two VARCHAR(100),
	@city VARCHAR(50),
	@county VARCHAR(50)
	)
AS
BEGIN
BEGIN TRANSACTION
BEGIN TRY
DECLARE @error NVARCHAR(MAX)

UPDATE dbo.venues
SET
	venue_name = @venue_name,
	add_line_one = @add_line_one,
	add_line_two = @add_line_two,
	venue_postcode = @venue_postcode,
	city = @city,
	county = @county
WHERE
	venue_id = @venue_id

IF @@TRANCOUNT > 0 
    COMMIT
END TRY
BEGIN CATCH
SET @error = 'error'
    IF @@TRANCOUNT > 0 BEGIN
        ROLLBACK TRANSACTION
        END
    RAISERROR (@error,1,0)
END CATCH
END

-- Delete Venue
CREATE PROCEDURE [dbo].[delete_venue](
	@venue_id int
	)
AS
BEGIN
BEGIN TRANSACTION
BEGIN TRY

DECLARE @error NVARCHAR(MAX)

DELETE FROM dbo.venues WHERE venue_id = @venue_id

IF @@TRANCOUNT > 0 
    COMMIT
END TRY
BEGIN CATCH
SET @error = 'error'
    IF @@TRANCOUNT > 0 BEGIN
        ROLLBACK TRANSACTION
        END
    RAISERROR (@error,1,0)
END CATCH
END

-- **** End VenueController procedures ****
-- **** Start VenueTableController procedures ****

-- Add Venue Table
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

-- Edit Venue Table
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

-- Delete Venue Table
CREATE PROCEDURE [dbo].[delete_venue_table] (
	@venue_table_id INT
)
AS
BEGIN
	DELETE FROM [dbo].[venue_tables] WHERE venue_table_id = @venue_table_id;
END
GO

-- **** End VenueTableController procedures ****

-- Delete timer

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delete_old_bookings]
AS 
BEGIN
DELETE FROM bookings
WHERE DATEADD(DAY, -21, GETDATE()) > GETDATE()
END
GO

-- Book table
	
CREATE PROCEDURE [dbo].[book_table] @venue_table_id int, @customer_id int, 
@booking_time DATETIME, @booking_size int, @booking_id int OUTPUT, @status_code INT OUTPUT
AS
BEGIN	
	BEGIN TRY
		BEGIN TRANSACTION

			SET @status_code = 201;
					
			DECLARE @venue_id INT;
			SET @venue_id = (SELECT venue_id FROM venue_tables WHERE venue_table_id = @venue_table_id); --gets the @venue_id from @venue_table_id
		
			INSERT INTO bookings(booking_time, booking_size, venue_id, venue_table_id)					
			VALUES (@booking_time, @booking_size, @venue_id, @venue_table_id);

			INSERT INTO booking_attendees(booking_id, customer_id, booking_attended)
			VALUES (IDENT_CURRENT('bookings'), @customer_id, 0);

			IF (NOT(CONVERT(TIME, @booking_time) >= (SELECT TOP 1 opening_times.venue_opening_time FROM opening_times WHERE opening_times.venue_id = @venue_id) AND
			CONVERT(TIME, @booking_time) <= (SELECT TOP 1 opening_times.venue_closing_time FROM opening_times WHERE opening_times.venue_id = @venue_id)))
			BEGIN
				PRINT('Error - not in opening times');
				SET @status_code = 400;
				ROLLBACK;
			END
		
			--IF checks that the booking is free -- got to check the booking is free an hour before and during (2 hours sounds about right)
			IF ((SELECT COUNT(bookings.booking_id) FROM bookings WHERE bookings.venue_table_id = @venue_table_id AND DATEADD(HOUR,2,bookings.booking_time) > @booking_time AND DATEADD(HOUR,-2,bookings.booking_time) < @booking_time) - 1 != 0)
			BEGIN
				PRINT('Error - already a booking at that time');
				SET @status_code = 400;
				ROLLBACK;
			END

			IF (@booking_size = 0)
			BEGIN
				PRINT('Error - Booking for 0 people');
				SET @status_code = 400;
				ROLLBACK;
			END

			SET @booking_id = IDENT_CURRENT('bookings');

		COMMIT;

		RETURN @booking_id;

	END TRY		
BEGIN CATCH
	PRINT 'Error';
	SET @status_code = 500;
END CATCH
END
GO
-- **** End Book table ****


-- Delete booking

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delete_booking] (
    @booking_id INT,
    @response VARCHAR(MAX) OUTPUT
)
AS

BEGIN

    BEGIN TRANSACTION
    
        BEGIN TRY

        DECLARE @existing_booking INT
            SELECT @existing_booking = booking_id FROM bookings WHERE booking_id = @booking_id
            IF ISNULL(@existing_booking, -1) = -1
            BEGIN
                SET @response = '404'

                IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
            END
            ELSE
            BEGIN
                DELETE FROM bookings WHERE booking_id = @booking_id
                DELETE FROM booking_attendees WHERE booking_id = @booking_id

                SET @response = '200'

                IF @@TRANCOUNT > 0 COMMIT
            END
        
        END TRY
        BEGIN CATCH
            SET @response = '500'
			
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        END CATCH

END
GO

-- Booking Attended
CREATE PROCEDURE [dbo].[attended_bookings] (
	@booking_id INT,
    @staff_id INT
)
AS
BEGIN
	UPDATE [dbo].[booking_attendees] SET booking_attended = 1 WHERE (booking_id = @booking_id);
    UPDATE [dbo].[bookings] SET staff_id = @staff_id WHERE (booking_id = @booking_id);
END
GO

-- Booking Cancel
CREATE PROCEDURE [dbo].[cancel_bookings] (
	@booking_id INT
)
AS
BEGIN
	DELETE FROM bookings WHERE booking_id = @booking_id
END
GO

create procedure clock_in_staff @staff_id INT
AS
BEGIN
BEGIN TRY
BEGIN TRANSACTION

    IF ((SELECT COUNT(*) FROM staff WHERE staff_id = @staff_id) = 1)
    BEGIN

    -- This statement closes any open slots
    IF ((SELECT COUNT(*) FROM staff_shifts WHERE staff_shifts.staff_id = @staff_id AND staff_end_time IS NULL AND staff_start_time IS NOT NULL) = 1)
    BEGIN
        PRINT 'Shift Closed';
        UPDATE staff_shifts SET staff_end_time = CURRENT_TIMESTAMP WHERE staff_shifts.staff_id = @staff_id AND staff_end_time IS NULL AND staff_start_time IS NOT NULL;
    END

    -- IF there are no open slots, create an open entry
    ELSE
    BEGIN
        PRINT 'Shift Opened';
        INSERT INTO staff_shifts(staff_id, staff_start_time) VALUES(@staff_id, CURRENT_TIMESTAMP)
    END

    END

    -- Only one thing should be inserted / updated
    IF (@@TRANCOUNT != 1)
    BEGIN
        PRINT 'Error - Multiple Entries'; 
        ROLLBACK;
    END

    COMMIT;

END TRY
BEGIN CATCH
    PRINT 'Error';    
END CATCH

END

GO

