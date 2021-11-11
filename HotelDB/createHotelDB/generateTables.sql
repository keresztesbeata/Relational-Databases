create table guests
(
    GuestID   int identity
        constraint guests_pk
            primary key nonclustered,
    FirstName text        not null,
    LastName  text        not null,
    Phone     varchar(13) not null,
    Email     text        not null
)
go

create table bookings
(
    BookingID int identity
        constraint room_bookings_pk
            primary key nonclustered,
    GuestID   int           not null
        constraint room_bookings_guests_GuestID_fk
            references guests,
    CheckIn   date          not null,
    CheckOut  date          not null,
    NrPeople  int default 1 not null,
    constraint valid_check_out
        check ([CheckOut] > [CheckIn])
)
go

create unique index room_bookings_RoomBookingID_uindex
    on bookings (BookingID)
go

create unique index guests_GuestID_uindex
    on guests (GuestID)
go

create table payment_time
(
    PaymentTimeID int identity
        constraint payment_time_pk
            primary key nonclustered,
    PaymentTime   text not null
)
go

create unique index payment_time_PaymentTimeID_uindex
    on payment_time (PaymentTimeID)
go

create table payment_type
(
    PaymentTypeID int identity
        constraint payment_type_pk
            primary key nonclustered,
    PaymentType   text not null
)
go

create table bills
(
    BillID        int identity
        constraint bills_pk
            primary key nonclustered,
    BookingID     int            not null
        constraint bills_bookings_BookingID_fk
            references bookings,
    PaymentTypeID int  default 1 not null
        constraint bills_payment_type_PaymentTypeID_fk
            references payment_type
        constraint valid_payment_type
            check ([PaymentTypeID] >= 1 AND [PaymentTypeID] <= 5),
    PaymentTimeID int  default 1 not null
        constraint bills_payment_time_PaymentTimeID_fk
            references payment_time
        constraint valid_payment_time
            check ([PaymentTimeID] >= 1 AND [PaymentTimeID] <= 3),
    Total         real default 0 not null
)
go

create unique index bills_BillID_uindex
    on bills (BillID)
go

create unique index bills_BookingID_uindex
    on bills (BookingID)
go

create unique index payment_type_PaymentTypeID_uindex
    on payment_type (PaymentTypeID)
go

create table room_status
(
    RoomStatusID int identity
        constraint room_status_pk
            primary key nonclustered,
    RoomStatus   text not null
)
go

create unique index room_status_RoomStatusID_uindex
    on room_status (RoomStatusID)
go

create table room_types
(
    RoomTypeID int            not null
        constraint room_types_pk
            primary key nonclustered,
    RoomType   text           not null,
    BedsNumber int  default 1 not null,
    TV         int  default 0,
    MiniFridge int  default 0,
    AC         int  default 0,
    Price      real default 0
)
go

create unique index room_types_RoomTypeID_uindex
    on room_types (RoomTypeID)
go

create table rooms
(
    RoomID       int identity
        constraint rooms_pk
            primary key nonclustered,
    RoomNumber   int           not null,
    Floor        int           not null
        constraint valid_floor_number
            check ([Floor] > 0),
    RoomStatusID int default 1 not null
        constraint rooms_room_status_RoomStatusID_fk
            references room_status
        constraint valid_room_status
            check ([RoomStatusID] >= 1 AND [RoomStatusID] <= 4),
    RoomTypeID   int           not null
        constraint rooms_room_types_RoomTypeID_fk
            references room_types
        constraint valid_room_type
            check ([RoomTypeID] >= 1 AND [RoomTypeID] <= 7),
    constraint valid_room_number
        check ([RoomNumber] >= 100 * [Floor] AND [RoomNumber] <= (100 * ([Floor] + 1) - 1))
)
go

create table booked_rooms
(
    RoomID    int not null
        constraint booked_rooms_rooms_RoomID_fk
            references rooms,
    BookingID int not null
        constraint booked_rooms_bookings_BookingID_fk
            references bookings
)
go

create unique index rooms_RoomID_uindex
    on rooms (RoomID)
go

create table staff_positions
(
    StaffPositionID         int identity
        constraint staff_positions_pk
            primary key nonclustered,
    StaffPositionDefinition text not null,
    Salary                  real not null
        constraint minimum_salary
            check ([Salary] > 1400)
)
go

create table room_service_types
(
    ServiceTypeID   int identity
        constraint room_service_types_pk
            primary key nonclustered,
    ServiceType     text not null,
    Price           real default 0,
    StaffPositionID int  not null
        constraint room_service_types_staff_positions_StaffPositionID_fk
            references staff_positions
        constraint valid_rs_staff_position
            check ([StaffPositionID] >= 1 AND [StaffPositionID] <= 8)
)
go

create table room_service
(
    RoomServiceID int identity
        constraint room_service_pk
            primary key nonclustered,
    RoomID        int not null
        constraint room_service_rooms_RoomID_fk
            references rooms,
    ServiceTypeID int not null
        constraint room_service_room_service_types_ServiceTypeID_fk
            references room_service_types
        constraint valid_rs_service_type
            check ([ServiceTypeID] >= 1 AND [ServiceTypeID] <= 8),
    PaymentTypeID int not null
        constraint room_service_payment_type_PaymentTypeID_fk
            references payment_type
        constraint valid_rs_payment_type
            check ([PaymentTypeID] >= 1 AND [PaymentTypeID] <= 5),
    PaymentTimeID int not null
        constraint room_service_payment_time_PaymentTimeID_fk
            references payment_time
        constraint valid_rs_payment_time
            check ([PaymentTimeID] >= 1 AND [PaymentTimeID] <= 3)
)
go

create unique index room_service_RoomServiceID_uindex
    on room_service (RoomServiceID)
go

create unique index room_service_types_ServiceTypeID_uindex
    on room_service_types (ServiceTypeID)
go

create table staff
(
    StaffID         int identity
        constraint staff_pk
            primary key nonclustered,
    FirstName       text not null,
    LastName        text not null,
    StaffPositionID int  not null
        constraint staff_staff_positions_StaffPositionID_fk
            references staff_positions
        constraint valid_staff_position
            check ([StaffPositionID] >= 1 AND [StaffPositionID] <= 8),
    EmploymentDate  date not null
)
go

create unique index staff_StaffID_uindex
    on staff (StaffID)
go

create unique index staff_positions_StaffPositionID_uindex
    on staff_positions (StaffPositionID)
go


