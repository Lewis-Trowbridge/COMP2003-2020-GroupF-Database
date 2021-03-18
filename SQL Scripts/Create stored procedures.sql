-- Add admin

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[add_admin] (
    
    @admin_username VARCHAR (100),
    @admin_password VARCHAR (100),
    @admin_level INT,
    @admin_salt VARCHAR (15)
)

AS 
BEGIN
BEGIN TRANSACTION
BEGIN TRY

DECLARE @error NVARCHAR(MAX)
DECLARE @admin_id INT
SET @admin_id = @@IDENTITY

INSERT INTO dbo.admins
    (admin_id, admin_username, admin_password, admin_level, admin_salt)
VALUES 
    (@admin_id, @admin_username, @admin_password, @admin_level, @admin_salt)

 IF @@TRANCOUNT > 0
        COMMIT

END TRY
BEGIN CATCH
SET @error = 'Error'
    IF @@TRANCOUNT > 0 BEGIN
      ROLLBACK TRANSACTION
      END
    RAISERROR (@error, 1,0)
END CATCH
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- Add error

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

-- Delete timer

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[deleteTimer]
AS 
BEGIN
DELETE FROM bookings
WHERE DATEADD(DAY, -21, GETDATE()) > GETDATE()
END
GO
