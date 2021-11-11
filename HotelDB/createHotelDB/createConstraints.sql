
alter table bookings add constraint valid_check_out check (CheckOut > CheckIn);

alter table rooms add constraint valid_room_status check (RoomStatusID between 1 and 4);
alter table rooms drop constraint valid_room_status;
alter table rooms add constraint valid_room_type check (RoomTypeID between 1 and 7);
alter table rooms drop constraint valid_room_type;
alter table rooms add constraint valid_room_number check (RoomNumber between 100*Floor and 100*(Floor+1)-1);
alter table rooms add constraint valid_floor_number check (Floor > 0);

alter table staff add constraint valid_staff_position check (StaffPositionID between 1 and 7);
alter table staff_positions add constraint minimum_salary check (Salary > 1400);
alter table room_service add constraint valid_rs_payment_type check(PaymentTypeID between 1 and 5);
alter table room_service add constraint valid_rs_payment_time check(PaymentTimeID between 1 and 3);
alter table room_service add constraint valid_rs_service_type check(ServiceTypeID between 1 and 8);
alter table room_service_types add constraint valid_staff_position check(StaffPositionID between 1 and 8);
alter table staff add constraint valid_staff_position check (StaffPositionID between 1 and 8);
alter table room_service_types add constraint valid_rs_staff_position check (StaffPositionID between 1 and 8);

update bills
    set bills.Total= datediff(dd,bookings.CheckIn,bookings.CheckOut)*room_types.Price
    from bills
    join bookings on bills.BookingID = bookings.BookingID
    join booked_rooms on bookings.BookingID = booked_rooms.BookingID
    join rooms on booked_rooms.RoomID = rooms.RoomID
    join room_types on room_types.RoomTypeID = rooms.RoomTypeID;
select * from bills;
