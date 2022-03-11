use library;

-- 1. Show the members under the name "Jens S." who were born before 1970 that became members of the library in 2013.
SELECT*FROM library.tmember WHERE cName like 'Jens S.%'  AND YEAR(dBirth) > 1970 AND YEAR(dNewMember) = 2013;

-- 2. Show those books that have not been published by the publishing companies with ID 15 and 32, except if they were published before 2000.
SELECT*FROM library.tbook WHERE nPublishingYear > 2000 AND nPublishingCompanyID = 15  or nPublishingCompanyID = 32 AND nPublishingYear > 2000;

-- 3. Show the name and surname of the members who have a phone number, but no address.
SELECT*FROM library.tmember WHERE cAddress IS NULL AND cPhoneNo IS NOT NULL;

-- 4. Show the authors with surname "Byatt" whose name starts by an "A" (uppercase) and contains an "S" (uppercase).
SELECT*FROM library.tauthor WHERE cSurname = 'Byatt' AND cName like 'A%' AND cName like '%S%';

-- 5. Show the number of books published in 2007 by the publishing company with ID 32.
SELECT*FROM library.tbook WHERE nPublishingYear = 2007 AND nPublishingCompanyID = 32;

-- 6. For each day of the year 2014, show the number of books loaned by the member with CPR "0305393207";
SELECT*FROM library.tloan WHERE cCPR = 0305393207 AND YEAR(dLoan) = 2014;

-- 7. Modify the previous clause so that only those days where the member was loaned more than one book appear.
-- i dont undestand the question

-- 8. Show all library members from the newest to the oldest. Those who became members on the same day will be sorted alphabetically (by surname and name) within that day.
SELECT *FROM library.tmember order by  dNewMember ASC;

-- 9. Show the title of all books published by the publishing company with ID 32 along with their theme or themes.
SELECT library.tbook.cTitle, library.ttheme.cName
from tbook
join tbooktheme on tbook.nBookID = tbooktheme.nBookID
join ttheme on ttheme.nThemeID = tbooktheme.nThemeID;

-- 10. Show the name and surname of every author along with the number of books authored by them, but only for authors who have registered books on the database.
SELECT library.tauthor.cName , library.tauthor.cSurname, COUNT(tauthorship.nAuthorID) AS No_books
from tauthor
left join tauthorship on tauthor.nAuthorID = tauthorship.nAuthorID
group by library.tauthor.cName, library.tauthor.cSurname;

-- 11. Show the name and surname of all the authors with published books along with the lowest publishing year for their books.
SELECT library.tauthor.cName, library.tauthor.cSurname, min(library.tbook.nPublishingYear) as lowestYear
from tauthor
join tauthorship on tauthor.nAuthorID = tauthorship.nAuthorID
join tbook on tauthorship.nBookID = tbook.nBookID;

-- 12. For each signature and loan date, show the title of the corresponding books and the name and surname of the member who had them loaned.
SELECT cTitle, cName, cSurname
from tloan
join tmember on tloan.cCPR = tmember.cCPR
join tbookcopy on tloan.cSignature = tbookcopy.cSignature
join tbook on tbookcopy.nBookID = tbook.nBookID;

-- 13. Repeat exercises 9 to 12 using the modern JOIN notation.
-- already done with join

-- 14. Show all theme names along with the titles of their associated books. All themes must appear (even if there are no books for some particular themes). Sort by theme name.
SELECT cTitle, ttheme.cName
from tbook
join tbooktheme
    on tbook.nBookID = tbooktheme.nBookID
join ttheme
    on tbooktheme.nThemeID = ttheme.nThemeID;

-- 15. Show the name and surname of all members who joined the library in 2013 along with the title of the books they took on loan during that same year. All members must be shown, even if they did not take any book on loan during 2013. Sort by member surname and name.
SELECT cName, cSurname, dNewMember, cTitle, dLoan
from tmember;

-- 16. Show the name and surname of all authors along with their nationality or nationalities and the titles of their books. Every author must be shown, even though s/he has no registered books. Sort by author name and surname.
SELECT t.cName, t.cSurname, t3.cName, t5.cTitle
from tauthor t
join tnationality t2 on t.nAuthorID = t2.nAuthorID
join tcountry t3 on t2.nCountryID = t3.nCountryID
join tauthorship t4 on t.nAuthorID = t4.nAuthorID or null
join tbook t5 on t4.nBookID = t5.nBookID
order by t.cSurname;

-- 17. Show the title of those books which have had different editions published in both 1970 and 1989.
SELECT cTitle
from tbook WHERE cTitle = cTitle
AND nPublishingYear = 1970 OR cTitle = cTitle AND nPublishingYear = 1989;

-- 18. Show the surname and name of all members who joined the library in December 2013 followed by the surname and name of those authors whose name is “William”.
SELECT library.tmember.cName, library.tmember.cSurname, library.tauthor.cName, library.tauthor.cSurname
FROM tauthor, tmember
WHERE YEAR(dNewMember)=2013 and MONTH(dNewMember)=12 AND tauthor.cName = 'William';

-- 19. Show the name and surname of the first chronological member of the library using subqueries.


-- 20. For each publishing year, show the number of book titles published by publishing companies from countries that constitute the nationality for at least three authors. Use subqueries.


-- 21. Show the name and country of all publishing companies with the headings "Name" and "Country".
SELECT library.tpublishingcompany.cName AS Name, library.tcountry.cName AS Country
FROM tpublishingcompany
join tcountry on tcountry.nCountryID = tpublishingcompany.nCountryID;

-- 22. Show the titles of the books published between 1926 and 1978 that were not published by the publishing company with ID 32.
SELECT library.tbook.cTitle
FROM tbook where library.tbook.nPublishingCompanyID not like 32 AND library.tbook.nPublishingYear <1926 or library.tbook.nPublishingCompanyID not like 32 AND library.tbook.nPublishingYear > 1978;

-- 23. Show the name and surname of the members who joined the library after 2016 and have no address.
SELECT library.tmember.cName, library.tmember.cSurname
FROM tmember WHERE YEAR(dNewMember) = 2016 AND library.tmember.cAddress IS NOT NULL;

-- 24. Show the country codes for countries with publishing companies. Exclude repeated values.
SELECT DISTINCT library.tpublishingcompany.cName ,library.tcountry.cName, library.tcountry.nCountryID
FROM tpublishingcompany
join library.tcountry on tcountry.nCountryID = tpublishingcompany.nCountryID;

-- 25. Show the titles of books whose title starts by "The Tale" and that are not published by "Lynch Inc".
SELECT DISTINCT cTitle
FROM tbook
join tpublishingcompany t on tbook.nPublishingCompanyID = t.nPublishingCompanyID
where regexp_like(cTitle, 'the Tale'); -- AND library.tpublishingcompany.cName not regexp(library.tpublishingcompany.cName, 'lynch inc')
-- The tale of Despereauc should not be there. but i tried 10 diffrent things and couldn't get it to work right

-- 26. Show the list of themes for which the publishing company "Lynch Inc" has published books, excluding repeated values.
SELECT DISTINCT library.ttheme.cName
FROM ttheme
join tbooktheme on ttheme.nThemeID = tbooktheme.nThemeID
join tbook on tbooktheme.nBookID = tbook.nBookID
join tpublishingcompany on tbook.nPublishingCompanyID = tbook.nPublishingCompanyID
where tpublishingcompany.cName regexp 'lynch inc';

-- 27. Show the titles of those books which have never been loaned.
SELECT cTitle
FROM tbook
join tbookcopy on tbook.nBookID = tbookcopy.nBookID
join tloan on tloan.cSignature != tbookcopy.cSignature;

-- 28. For each publishing company, show its number of existing books under the heading "No. of Books".
SELECT DISTINCT library.tpublishingcompany.cName, COUNT(library.tpublishingcompany.nPublishingCompanyID) AS "No. of Books"
FROM tpublishingcompany
left join tbook t on tpublishingcompany.nPublishingCompanyID = t.nPublishingCompanyID
group by library.tpublishingcompany.cName;

-- 29. Show the number of members who took some book on a loan during 2013.
SELECT COUNT(dLoan)
from tloan where YEAR(dLoan)= 2013;

-- 30. For each book that has at least two authors, show its title and number of authors under the heading "No. of Authors".
SELECT cTitle, COUNT(library.tauthorship.nBookID) AS "No. of Authors"
FROM tbook
left join tauthorship on tbook.nBookID = tauthorship.nBookID
WHERE tauthorship.nBookID <= 2
group by cTitle;