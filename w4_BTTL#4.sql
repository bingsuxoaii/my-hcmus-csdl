﻿USE QLDT

--Q27
SELECT COUNT(*) AS SOLUONG_GV , SUM(LUONG) AS TONGLUONG
FROM GIAOVIEN

--Q28
SELECT BM.MABM, COUNT(*) AS SOLUONG_GV , AVG(LUONG) AS LUONGTB
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM=BM.MABM 
GROUP BY BM.MABM

--Q29
SELECT CD.TENCD, COUNT(*) AS SO_DT
FROM CHUDE CD JOIN DETAI DT ON CD.MACD=DT.MACD
GROUP BY CD.MACD,CD.TENCD

--Q30
SELECT HOTEN, COUNT (DISTINCT TG.MADT) AS SO_DTTG
FROM GIAOVIEN GV LEFT JOIN THAMGIADT TG ON GV.MAGV=TG.MAGV
GROUP BY GV.MAGV,GV.HOTEN

--Q31
SELECT HOTEN, COUNT (DISTINCT DT.MADT) AS SO_DTCN
FROM GIAOVIEN GV LEFT JOIN DETAI DT ON GV.MAGV=DT.GVCNDT
GROUP BY GV.MAGV,GV.HOTEN

--Q32
SELECT GV.HOTEN, COUNT (NT.TEN) AS SO_NT
FROM GIAOVIEN GV LEFT JOIN NGUOITHAN NT ON GV.MAGV=NT.MAGV
GROUP BY GV.MAGV,GV.HOTEN

--Q33
SELECT HOTEN
FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV=TG.MAGV
GROUP BY GV.MAGV,GV.HOTEN
HAVING COUNT (DISTINCT TG.MADT)>=3

--Q34
SELECT COUNT(DISTINCT TG.MAGV) AS SO_GV_TGDT_HHX
FROM THAMGIADT TG JOIN DETAI DT ON DT.MADT=TG.MADT
WHERE DT.TENDT = N'Ứng dụng hoá học xanh'
GROUP BY TG.MADT
