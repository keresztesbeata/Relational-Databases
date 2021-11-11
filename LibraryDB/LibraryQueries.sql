-- list the publisher with the most published books since 2010

select b.Publisher,
       (select count(*)
            from Books b1
        where b1.Publisher = b.Publisher) as publishingRecord
    from Books b
where b.Year >= 2010 
group by b.Publisher
order by publishingRecord desc
limit 1;

-- list all the contemporary authors who have written books about Holocaust, and how many
-- except the books written in german
select a.Name,
       (select count(b1.AuthorId)
            from Books b1
        where (b1.AuthorId = a.Id and b1.Category = 'Holocaust' and b1.Language != 'German'))
           as noBooks
    from Authors a
where a.Died is null and noBooks > 0    
order by a.Name;

-- the library pass has to be renewed every 3 years
-- show the library passes that have expired in the last 2 months and which haven't been updated yet:
-- list name and contact information of these users, and the days they are late renewing their pass

select u.Name,u.Phone,u.Email,round(julianday('now') - julianday(u.RegistrationDate) - 3*365 - 2) as daysLate
    from Users u
where ( UpToDate = false
        and date('now') - RegistrationDate = 3
        and strftime('%m',RegistrationDate) = strftime('%m','now','-1 month') ) -- expired last month
union
select u.Name,u.Phone,u.Email, round(julianday('now') - julianday(u.RegistrationDate) - 3*365 - 2) as daysLate
    from Users u
where (UpToDate = false
        and date('now') - RegistrationDate = 3
        and strftime('%m',RegistrationDate) = strftime('%m','now')) -- expired this month
order by daysLate;

-- list the 3 most loyal members of the library (the ones who have been using frequenting the library the longest)
-- and the time(in years) since they have joined the library

select u.Name, datetime('now') - u.RegistrationDate as yearsSinceJoining
    from Users u
order by yearsSinceJoining desc
limit 3;

-- overdue books:
-- the name of the users who didn't return the books in time
-- how many days it was late ( current_date - (return_date+1)), because the due date expires after the return_date
-- the number of books which he/she borrowed
-- the contact information of the borrower

select u.Name,round(julianday('now') - julianday(br.ReturnDate))-1 as 'DaysLate',
    (select count(*)
        from BorrowedBooks as br2
            where br2.UserId = br.UserId) as noBooks,
    u.Phone,u.Email
        from BorrowedBooks br join Books b on br.BookId = b.Id
                            join Users u on br.UserId = u.Id
    where DaysLate > 0
    group by u.Name
    order by DaysLate desc;

-- list the 3 most popular book category, from which the most people borrowed last week

select b.Category,
    (select count(br.BookId)
        from BorrowedBooks br1 join Books b1 on br1.BookId = b1.Id
    where b1.Category=b.Category) as noBooks
        from BorrowedBooks br join Books b on br.BookId = b.Id
where strftime('%W',br.BorrowingDate) == strftime('%W','now','-7 day')   -- last week
 and strftime('%w',br.BorrowingDate) >= 1    -- starting from Monday = 1
group by b.Category
order by noBooks desc
limit 3;

-- recommendations of books similar to 'War and peace', having:
-- same category
-- same language
-- same author or other authors from the same period

select b.Title,a.Name
-- all the books from the same category and the same language
    from Books b join Authors a on b.AuthorId = a.Id
where (b.Category = (select b1.Category
                        from Books b1
                     where b1.Title = 'War and peace')
    and b.Language = (select b1.Language
                        from Books b1
                     where b1.Title = 'War and peace')
    and b.Title != 'War and peace')
intersect
select b.Title, a.Name
-- books from the same author or other author's of the era (+- 20 years)
from Books b join Authors a on b.AuthorId = a.Id
where (a.Id = (select b1.AuthorId
                    from Books b1
                    where b1.Title = 'War and peace')
    or abs(a.Born - (select a1.Born
                    from Books b1 join Authors a1 on b1.AuthorId = a1.Id
                    where b1.Title = 'War and peace')) <= 20 );
	
	