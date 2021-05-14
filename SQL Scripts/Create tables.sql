-- Create tables


-- Admins
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[admins](
	[admin_id] [int] IDENTITY(1,1) NOT NULL,
	[admin_username] [varchar](50) NOT NULL,
	[admin_password] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[admin_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[admin_username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[admin_username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


-- Venues
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[venues](
	[venue_id] [int] IDENTITY(1,1) NOT NULL,
	[venue_name] [varchar](50) NOT NULL,
	[venue_postcode] [varchar](10) NOT NULL,
	[add_line_one] [varchar](100) NOT NULL,
	[add_line_two] [varchar](100) NULL,
	[city] [varchar](50) NOT NULL,
	[county] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[venues] ADD PRIMARY KEY CLUSTERED 
(
	[venue_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO


-- Customers
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[customers](
	[customer_id] [int] IDENTITY(1,1) NOT NULL,
	[customer_name] [varchar](50) NOT NULL,
	[customer_contact_number] [varchar](15) NOT NULL,
	[customer_username] [varchar](50) NOT NULL,
	[customer_password] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[customer_username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[customer_username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[customer_username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


-- Admin locations
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[admin_locations](
	[venue_id] [int] NOT NULL,
	[admin_id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[admin_locations] ADD PRIMARY KEY CLUSTERED 
(
	[venue_id] ASC,
	[admin_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[admin_locations]  WITH CHECK ADD FOREIGN KEY([admin_id])
REFERENCES [dbo].[admins] ([admin_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[admin_locations]  WITH CHECK ADD FOREIGN KEY([venue_id])
REFERENCES [dbo].[venues] ([venue_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO


-- Venue tables
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[venue_tables](
	[venue_table_id] [int] IDENTITY(1,1) NOT NULL,
	[venue_id] [int] NOT NULL,
	[venue_table_num] [int] NOT NULL,
	[venue_table_capacity] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[venue_tables] ADD PRIMARY KEY CLUSTERED 
(
	[venue_table_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[venue_tables]  WITH CHECK ADD FOREIGN KEY([venue_id])
REFERENCES [dbo].[venues] ([venue_id])
GO

-- Bookings
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bookings](
	[booking_id] [int] IDENTITY(1,1) NOT NULL,
	[booking_time] [datetime] NOT NULL,
	[booking_size] [int] NOT NULL,
	[venue_id] [int] NOT NULL,
	[venue_table_id] [int] NOT NULL,
	[staff_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[booking_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bookings]  WITH CHECK ADD FOREIGN KEY([staff_id])
REFERENCES [dbo].[staff] ([staff_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[bookings]  WITH CHECK ADD FOREIGN KEY([venue_table_id])
REFERENCES [dbo].[venue_tables] ([venue_table_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[bookings]  WITH CHECK ADD FOREIGN KEY([venue_id])
REFERENCES [dbo].[venues] ([venue_id])
GO


-- Booking attendees
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[booking_attendees](
	[booking_id] [int] NOT NULL,
	[customer_id] [int] NOT NULL,
	[booking_attended] [bit] NOT NULL,
 CONSTRAINT [PK_booking_attendees] PRIMARY KEY CLUSTERED 
(
	[booking_id] ASC,
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[booking_attendees] ADD  DEFAULT ((0)) FOR [booking_attended]
GO
ALTER TABLE [dbo].[booking_attendees]  WITH CHECK ADD FOREIGN KEY([booking_id])
REFERENCES [dbo].[bookings] ([booking_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[booking_attendees]  WITH CHECK ADD FOREIGN KEY([customer_id])
REFERENCES [dbo].[customers] ([customer_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO



-- Staff
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[staff](
	[staff_id] [int] IDENTITY(1,1) NOT NULL,
	[staff_name] [varchar](50) NOT NULL,
	[staff_contact_num] [varchar](15) NOT NULL,
	[staff_position] [varchar](20) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[staff] ADD PRIMARY KEY CLUSTERED 
(
	[staff_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO


-- Staff shifts
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[staff_shifts](
	[staff_shift_id] [int] IDENTITY(1,1) NOT NULL,
	[staff_id] [int] NOT NULL,
	[staff_start_time] [datetime] NOT NULL,
	[staff_end_time] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[staff_shifts] ADD PRIMARY KEY CLUSTERED 
(
	[staff_shift_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[staff_shifts]  WITH CHECK ADD FOREIGN KEY([staff_id])
REFERENCES [dbo].[staff] ([staff_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO


-- Employment
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[employment](
	[venue_id] [int] NOT NULL,
	[staff_id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[employment] ADD PRIMARY KEY CLUSTERED 
(
	[venue_id] ASC,
	[staff_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[employment]  WITH CHECK ADD FOREIGN KEY([staff_id])
REFERENCES [dbo].[staff] ([staff_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[employment]  WITH CHECK ADD FOREIGN KEY([venue_id])
REFERENCES [dbo].[venues] ([venue_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

-- Flags
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[flags](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[flag_title] [varchar](450) NULL,
	[flag_location_page] [varchar](450) NULL,
	[flag_category] [varchar](450) NULL,
	[flag_persistent] [bit] NULL,
	[flag_urgency] [int] NULL,
	[flag_desc] [varchar](2000) NULL,
	[flag_venue_id] [int] NULL,
	[flag_date] [datetime] NULL,
	[flag_resolved] [bit] NULL
) ON [PRIMARY]
GO


