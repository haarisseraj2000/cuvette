{\rtf1\ansi\ansicpg1252\cocoartf2761
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww34360\viewh21600\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 -- Query 1: Top 5 customers by total purchase amount\
SELECT \
    c.CustomerId,\
    c.FirstName || ' ' || c.LastName AS CustomerName,\
    SUM(i.Total) AS TotalSpent\
FROM \
    customers c\
JOIN \
    invoices i ON c.CustomerId = i.CustomerId\
GROUP BY \
    c.CustomerId\
ORDER BY \
    TotalSpent DESC\
LIMIT 5;\
\
-- Query 2: Most popular genre by total tracks sold\
SELECT \
    g.Name AS Genre,\
    COUNT(ii.TrackId) AS TracksSold\
FROM \
    invoice_items ii\
JOIN \
    tracks t ON ii.TrackId = t.TrackId\
JOIN \
    genres g ON t.GenreId = g.GenreId\
GROUP BY \
    g.GenreId\
ORDER BY \
    TracksSold DESC\
LIMIT 1;\
\
-- Query 3: Employees who are managers and their subordinates\
SELECT \
    mgr.EmployeeId AS ManagerId,\
    mgr.FirstName || ' ' || mgr.LastName AS ManagerName,\
    emp.EmployeeId AS SubordinateId,\
    emp.FirstName || ' ' || emp.LastName AS SubordinateName\
FROM \
    employees emp\
JOIN \
    employees mgr ON emp.ReportsTo = mgr.EmployeeId\
ORDER BY \
    ManagerId, SubordinateName;\
\
-- Query 4: Most sold album for each artist\
WITH AlbumSales AS (\
    SELECT \
        ar.Name AS ArtistName,\
        al.Title AS AlbumTitle,\
        al.AlbumId,\
        COUNT(ii.InvoiceLineId) AS TracksSold\
    FROM \
        artists ar\
    JOIN \
        albums al ON ar.ArtistId = al.ArtistId\
    JOIN \
        tracks t ON al.AlbumId = t.AlbumId\
    JOIN \
        invoice_items ii ON t.TrackId = ii.TrackId\
    GROUP BY \
        ar.ArtistId, al.AlbumId\
),\
RankedAlbums AS (\
    SELECT *,\
           RANK() OVER (PARTITION BY ArtistName ORDER BY TracksSold DESC) AS rank\
    FROM AlbumSales\
)\
SELECT \
    ArtistName,\
    AlbumTitle,\
    TracksSold\
FROM \
    RankedAlbums\
WHERE \
    rank = 1\
ORDER BY \
    ArtistName;\
\
-- Query 5: Monthly sales trends in the year 2013\
SELECT \
    strftime('%Y-%m', i.InvoiceDate) AS Month,\
    SUM(ii.Quantity * ii.UnitPrice) AS TotalSales\
FROM \
    invoices i\
JOIN \
    invoice_items ii ON i.InvoiceId = ii.InvoiceId\
WHERE \
    i.InvoiceDate BETWEEN '2013-01-01' AND '2013-12-31'\
GROUP BY \
    strftime('%Y-%m', i.InvoiceDate)\
ORDER BY \
    Month;\
\
}