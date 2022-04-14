
USE QLBHSieuThi
GO

--1
--Viết stored procedure xuất danh sách các đơn hàng gồm mã hoá đơn, ngày lập, trị giá hoá đơn,
--chỉ xuất các đơn hàng của 2 tháng gần đây (tính từ ngày hiện tại).

GO
CREATE FUNCTION TINHTRIGIAHD (@MAHD VARCHAR(5))
RETURNS INT
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM CTHoaDon WHERE MaHD = @MAHD)
		RETURN 0
	RETURN (SELECT SUM(SoLuong*DonGia) FROM CTHoaDon WHERE MaHD = @MAHD)
	
END

GO
IF OBJECT_ID('XUATDSDONHANG','P') IS NOT NULL
	DROP PROC XUATDSDONHANG
GO
CREATE PROC XUATDSDONHANG
AS
BEGIN
	SELECT HD.MaHD,NgayLap,DBO.TINHTRIGIAHD(HD.MaHD) AS N'Trị giá hoá đơn'
	FROM CTHoaDon CT JOIN HoaDon HD ON CT.MaHD=HD.MaHD
	WHERE DATEDIFF(M,NgayLap,GETDATE())<=2
	GROUP BY HD.MaHD,NgayLap
END

GO
EXEC XUATDSDONHANG

--2
--Viết truy vấn cho biết mặt hàng nào được tất cả khách hàng ở thành phố “Hồ Chí Minh” mua.

SELECT SP.MASP, SP.Ten
FROM SanPham SP 
WHERE NOT EXISTS(SELECT KH.MaKH
FROM KhachHang KH 
WHERE DiaChi=N'Hồ Chí Minh'
EXCEPT
SELECT HD.MaKH
FROM CTHoaDon CT JOIN HoaDon HD ON CT.MaHD=HD.MaHD
WHERE CT.MASP=SP.MASP)

--3
--Viết truy vấn cho biết loại sản phẩm nào bán chạy nhất

SELECT LSP.TenLoai as N'Sản phẩm bán chạy nhất'
FROM CTHoaDon CT JOIN SanPham SP ON CT.MASP=SP.MASP
JOIN LoaiSanPham LSP ON SP.MaLoai=LSP.MaLoai
GROUP BY LSP.TenLoai
HAVING sum(CT.SoLuong)>=ALL(SELECT sum(SoLuong) 
FROM CTHoaDon CT JOIN SanPham SP ON CT.MASP=SP.MASP
JOIN LoaiSanPham LSP ON SP.MaLoai=LSP.MaLoai
GROUP BY LSP.TenLoai)