--  find available room with following specifications:
--  budget between 300 and 400
--  2 people : double/twin
--  has TV and AC
select r.RoomNumber, r.Floor,rt.Price,rt.RoomType
from rooms r join room_types rt on r.RoomTypeID = rt.RoomTypeID
join room_status rs on r.RoomStatusID = rs.RoomStatusID
where (
        rs.RoomStatus = 'Available' and
        (rt.Price between 300 and 400) and
        rt.RoomType in ('double','twin') and
        rt.TV > 0 and
        rt.AC > 0
        )
order by rt.Price,r.RoomNumber;
---------------------------------------------------------------------------------------------------------------------
--  find the most experienced cleaning staff and print since how many years has he/she been working in the hotel
select s.FirstName,s.LastName,datediff(yy,s.EmploymentDate,convert(date,getdate())) as Years_of_experience
     from staff s join staff_positions sp on s.StaffPositionID = sp.StaffPositionID
     where sp.StaffPosition like 'Cleaning staff' and
        s.EmploymentDate = (select min(s2.EmploymentDate)
     from staff s2);
---------------------------------------------------------------------------------------------------------------------
--  display the staff member with the highest salary and its position in the hotel
select s.FirstName,s.LastName,sp.Salary,sp.StaffPosition
from staff s join staff_positions sp on s.StaffPositionID = sp.StaffPositionID
where sp.Salary = (select max(sp2.Salary)
    from staff_positions sp2);
---------------------------------------------------------------------------------------------------------------------
--  name and contact information of the guests who have checked in last week and booked more than 1 room
-- and how many rooms they booked
select g.FirstName,g.LastName,g.Phone,g.Email,
       (select count(b2.RoomID)
           from booked_rooms b2
           where b2.BookingID = b.BookingID) as NrRoomsBooked
    from guests g join bookings b on g.GuestID = b.GuestID
where (datepart(wk,b.CheckIn) = datepart(wk,getdate()) - 1 and
        (select count(b2.RoomID)
           from booked_rooms b2
           where b2.BookingID = b.BookingID) > 1);
---------------------------------------------------------------------------------------------------------------------
--  print the name and contact info of the guests who booked a presidential suite and paid at Check-in
select g.FirstName,g.LastName,g.Phone,g.Email
    from guests g join bookings b on g.GuestID = b.GuestID
    join booked_rooms b2 on b.BookingID = b2.BookingID
    join rooms r on b2.RoomID = r.RoomID
    join room_types rt on rt.RoomTypeID = r.RoomTypeID
    join bills b3 on b.BookingID = b3.BookingID
    join payment_time pt on b3.PaymentTimeID = pt.PaymentTimeID
where pt.PaymentTime = 'At Check-out' and rt.RoomType = 'presidential suite';
---------------------------------------------------------------------------------------------------------------------
--  some guests chose to pay at check-out:
--    display the name of the guests, the total amount to be paid for the room,
--    and for the room service, if it was not yet paid
--    and the method of payment
select g.FirstName,g.LastName,bl.Total,
       -- room service fee
       (select sum(rst.Price)
       from guests g1 join bookings bk1 on g1.GuestID = bk1.GuestID
        join booked_rooms br1 on br1.BookingID = bk1.BookingID
        join room_service rs on rs.RoomID = br1.RoomID

        join room_service_types rst on rs.ServiceTypeID = rst.ServiceTypeID
        join payment_time ptime1 on rs.PaymentTimeID = ptime1.PaymentTimeID

        where g1.GuestID = g.GuestID and ptime1.PaymentTime = 'At Check-out'
        group by g1.GuestID
        ) as RoomServiceFee,
       ptype2.PaymentType as PaymentType
    -- join guests with bookings
    from guests g join bookings bk on g.GuestID = bk.GuestID
    -- join bookings with bills
    join bills bl on bk.BookingID = bl.BookingID
    join payment_time ptime2 on bl.PaymentTimeID = ptime2.PaymentTimeID
    join payment_type ptype2 on bl.PaymentTypeID = ptype2.PaymentTypeID
where ptime2.PaymentTime = 'At Check-out'
order by g.FirstName,g.LastName;
---------------------------------------------------------------------------------------------------------------------
-- print the room number and name of the guests who requested room service but didn't yet pay for it (only at check out)
-- and how much they own (unless the room service was free)
select r.RoomNumber,g.FirstName,g.LastName,
       (select sum(rst1.Price)
       from room_service rs1 join room_service_types rst1 on rs1.ServiceTypeID = rst1.ServiceTypeID
       join payment_time pt1 on rs.PaymentTimeID = pt1.PaymentTimeID
        where pt1.PaymentTime = 'At Check-out' and rs1.RoomID = r.RoomID
        group by rs1.RoomID
       )as RoomServiceTotal
from rooms r join booked_rooms br on r.RoomID = br.RoomID
join bookings b on br.BookingID = b.BookingID
join guests g on b.GuestID = g.GuestID
join room_service rs on r.RoomID = rs.RoomID
join payment_time pt on rs.PaymentTimeID = pt.PaymentTimeID
where pt.PaymentTime = 'At Check-out' and
      (select sum(rst1.Price)
       from room_service rs1 join room_service_types rst1 on rs1.ServiceTypeID = rst1.ServiceTypeID
       join payment_time pt1 on rs.PaymentTimeID = pt1.PaymentTimeID
        where pt1.PaymentTime = 'At Check-out' and rs1.RoomID = r.RoomID
        group by rs1.RoomID
       ) > 0
order by RoomServiceTotal desc,r.RoomNumber,g.FirstName,g.LastName;
---------------------------------------------------------------------------------------------------------------------
-- there was a room service request with id 22: find a suitable staff to handle it and print the nr of the room
-- choose the oldest staff member (the most experienced one)
-- also print the type of room service and the position of the employee
select r.RoomNumber,r.Floor,rst.ServiceType,s.FirstName,s.LastName,sp.StaffPosition
from room_service rs join rooms r on rs.RoomID = r.RoomID
join room_service_types rst on rst.ServiceTypeID = rs.ServiceTypeID
join staff_positions sp on rst.StaffPositionID = sp.StaffPositionID
join staff s on sp.StaffPositionID = s.StaffPositionID
where rs.RoomServiceID = 22  and
      s.EmploymentDate = (select min(s1.EmploymentDate) from staff s1 where s1.StaffPositionID = s.StaffPositionID);
---------------------------------------------------------------------------------------------------------------------
-- which type of room service was the most requested and by how many guests: print the 3 most popular services
select top 3 rst.ServiceType,count(rs.RoomServiceID) as NrRequests
from room_service rs join room_service_types rst on rs.ServiceTypeID = rst.ServiceTypeID
group by rs.ServiceTypeID,rst.ServiceType
order by NrRequests desc,rst.ServiceType;
---------------------------------------------------------------------------------------------------------------------
-- print all the staff who have been employed last year, the name of the month in which they were employed and their salary
select s.FirstName,s.LastName,datename(month,s.EmploymentDate) as FirstMonth,sp.Salary
from staff s join staff_positions sp on s.StaffPositionID = sp.StaffPositionID
where datepart(year,s.EmploymentDate) = datepart(year,getdate())-1
order by s.EmploymentDate, Salary desc, s.FirstName,s.LastName;
---------------------------------------------------------------------------------------------------------------------
-- display the year in which the majority of the staff was employed and the nr of employments
select top 1 datepart(year,s.EmploymentDate) as YearWithMostEmployments,
       (select count(s1.StaffID)
           from staff s1
           where datepart(year,s1.EmploymentDate) = datepart(year,s.EmploymentDate)
          group by datepart(year,s1.EmploymentDate)) as NrEmployments
from staff s
group by datepart(year,s.EmploymentDate)
order by NrEmployments desc;
---------------------------------------------------------------------------------------------------------------------
-- display the busiest day from last week, when the most people checked in
select top 1 datename(weekday,b.CheckIn) as BusiestDay,
       (select count(b1.BookingID)
           from bookings b1
           where b1.CheckIn = b.CheckIn) as NrCheckIns
from bookings b join booked_rooms br on b.BookingID = br.BookingID
where datepart(week,b.CheckIn) = datepart(week,getdate())-1
group by b.CheckIn
order by NrCheckIns desc;
---------------------------------------------------------------------------------------------------------------------
-- display the rooms which will be freed today (from which the guests have to check out today)
select r.RoomNumber,r.Floor
from rooms r join booked_rooms br on r.RoomID = br.RoomID
join bookings b on b.BookingID = br.BookingID
where convert(date,getdate())=b.CheckOut
order by r.Floor,r.RoomNumber;
---------------------------------------------------------------------------------------------------------------------
--  count how many people asked to iron a shirt through the room service
select count(rs.RoomServiceID) as NrShirtIroningRequests
from room_service rs join room_service_types rst on rs.ServiceTypeID = rst.ServiceTypeID
where rst.ServiceType = 'Iron shirt'
group by rs.ServiceTypeID;
---------------------------------------------------------------------------------------------------------------------
--  find out which rooms need to be repaired
select r.RoomNumber,r.Floor
from rooms r join room_status rs on rs.RoomStatusID = r.RoomStatusID
where rs.RoomStatus = 'Needs repairing';
---------------------------------------------------------------------------------------------------------------------
