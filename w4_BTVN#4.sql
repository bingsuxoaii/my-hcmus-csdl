﻿USE QLCB

--17
SELECT SBDEN, COUNT(*) AS SOLUONG_CB_HACANH
FROM CHUYENBAY
GROUP BY SBDEN
ORDER BY SBDEN ASC

--18
SELECT SBDI, COUNT(*) AS SOLUONG_CB_XUATPHAT
FROM CHUYENBAY  
GROUP BY SBDI
ORDER BY SBDI ASC

--19
SELECT CB.SBDI, LB.NGAYDI, COUNT(*) AS SOLUONG_CB_XUATPHAT
FROM CHUYENBAY CB JOIN LICHBAY LB ON CB.MACB=LB.MACB
GROUP BY CB.SBDI, LB.NGAYDI

--20
SELECT CB.SBDEN, LB.NGAYDI, COUNT(*) AS SOLUONG_CB_HACANH
FROM CHUYENBAY CB JOIN LICHBAY LB ON CB.MACB=LB.MACB
GROUP BY CB.SBDEN, LB.NGAYDI

--21
SELECT LB.MACB, LB.NGAYDI , COUNT(NV.MANV) AS SOLUONG_NV_KO_LA_PHICONG
FROM PHANCONG PC JOIN LICHBAY LB ON LB.MACB=PC.MACB AND LB.NGAYDI=PC.NGAYDI 
LEFT JOIN (SELECT * FROM NHANVIEN WHERE LOAINV=0) AS NV ON PC.MANV=NV.MANV
GROUP BY LB.MACB, LB.NGAYDI

--22
SELECT COUNT(*) AS SOLUONG_CB
FROM CHUYENBAY CB JOIN LICHBAY LB ON LB.MACB=CB.MACB
WHERE CB.SBDI='MIA' AND LB.NGAYDI='11/01/2000'

--23
SELECT LB.MACB, LB.NGAYDI, COUNT(*) AS SOLUONG_NV
FROM PHANCONG PC JOIN LICHBAY LB ON LB.MACB=PC.MACB AND LB.NGAYDI=PC.NGAYDI 
GROUP BY LB.MACB, LB.NGAYDI
ORDER BY SOLUONG_NV DESC

--24
SELECT LB.MACB, LB.NGAYDI, COUNT(*) AS SOLUONG_KH
FROM DATCHO DC JOIN LICHBAY LB ON LB.MACB=DC.MACB AND LB.NGAYDI=DC.NGAYDI
GROUP BY LB.MACB, LB.NGAYDI
ORDER BY SOLUONG_KH DESC

--25
SELECT LB.MACB, LB.NGAYDI, SUM(NV.LUONG) AS TONGLUONG_NV
FROM PHANCONG PC JOIN LICHBAY LB ON LB.MACB=PC.MACB AND LB.NGAYDI=PC.NGAYDI 
JOIN NHANVIEN NV ON PC.MANV=NV.MANV 
GROUP BY LB.MACB, LB.NGAYDI
ORDER BY TONGLUONG_NV ASC

--26
SELECT AVG(LUONG) AS LUONGTB_NV_KO_LA_PHICONG
FROM NHANVIEN WHERE LOAINV=0

--27
SELECT AVG(LUONG) AS LUONGTB_CUA_PHICONG
FROM NHANVIEN WHERE LOAINV=1

--28
SELECT LB.MALOAI, COUNT(*) AS SOLUONG_CB_HC_ORD
FROM CHUYENBAY CB JOIN LICHBAY LB ON LB.MACB=CB.MACB
WHERE CB.SBDEN='ORD'
GROUP BY LB.MALOAI

--29
SELECT SBDI, COUNT(*) AS SOLUONG_CB
FROM CHUYENBAY 
WHERE GIODI BETWEEN '10:00' AND '22:00'
GROUP BY SBDI
HAVING COUNT(*)>2

--30
SELECT NV.TEN AS TEN_PHICONG
FROM NHANVIEN NV JOIN PHANCONG PC ON NV.MANV=PC.MANV AND NV.LOAINV=1 
GROUP BY NV.TEN, PC.NGAYDI
HAVING COUNT(*)>=2

--31
SELECT LB.MACB, LB.NGAYDI
FROM DATCHO DC JOIN LICHBAY LB ON LB.MACB=DC.MACB AND LB.NGAYDI=DC.NGAYDI
GROUP BY LB.MACB, LB.NGAYDI
HAVING COUNT(MAKH)<3

--32
SELECT LB.SOHIEU, LB.MALOAI
FROM PHANCONG PC JOIN LICHBAY LB ON LB.MACB=PC.MACB AND PC.NGAYDI=LB.NGAYDI
WHERE PC.MANV='1001'
GROUP BY LB.SOHIEU, LB.MALOAI
HAVING COUNT(PC.NGAYDI)>2

--33
SELECT HANGSX, COUNT(*) AS SOLUONG_MB_HANGSX
FROM LOAIMB
GROUP BY HANGSX
