/*
	SQL Server Dumper - version 2.0.0
	Ruizata Project

	Creation Date: 17/5/2016 4:04:35 PM
	Database : `QLBHSieuThi` 
*/
use [QLBHSieuThi]
GO
-- `dbo.KhachHang`
INSERT dbo.KhachHang VALUES ('11', '2rr', '3', '4', '4', 'N?')
INSERT dbo.KhachHang VALUES ('KH01', N'Nguyễn Thanh Tùng', N'Hồ Chí Minh', '9-1234-5678', '1984', N'Nam')
INSERT dbo.KhachHang VALUES ('KH02', N'Lê Nhật Nam', N'Hồ Chí Minh', '9-1234-2134', '1972', N'Nữ')
INSERT dbo.KhachHang VALUES ('KH03', N'Nguyễn Thị Thanh', N'Cà Mau', '9-2222-3333', '1981', N'Nữ')
INSERT dbo.KhachHang VALUES ('KH04', N'Lê Thị Lan', N'Bình Dương', '9-1111-1111', '1984', N'Nữ')
INSERT dbo.KhachHang VALUES ('KH05', N'Trần Minh Quang', N'Đồng Nai', '9-2222-5555', '1984', N'Nam')
INSERT dbo.KhachHang VALUES ('KH06', N'Lê Văn Hải', N'Hồ Chí Minh', '9-1234-4321', '1970', N'Nam')
INSERT dbo.KhachHang VALUES ('KH07', N'Dương Văn Hai', N'Đồng Nai', '9-1111-0000', '1988', N'Nam')
INSERT dbo.KhachHang VALUES ('KH11', 'ABC', 'HCM', '1234', '1998', N'Nam')
INSERT dbo.KhachHang VALUES ('KH12', 'ABC', 'HCM', '1234', '1998', N'Nam')
INSERT dbo.KhachHang VALUES ('KH13', 'new', 'new', '12345', '100', N'Nam')
INSERT dbo.KhachHang VALUES ('KH14', 'aa', 'aa', '1234', '100', 'N?')
GO

-- `dbo.LoaiSanPham`
INSERT dbo.LoaiSanPham VALUES ('A', N'Đồ Dùng')
INSERT dbo.LoaiSanPham VALUES ('B', N'Nồi Cơm Điện')
INSERT dbo.LoaiSanPham VALUES ('C', N'Đèn Điện')
GO

-- `dbo.SanPham`
INSERT dbo.SanPham VALUES ('SP01', N'Bột Giặt Omo', 30, 70, N'Túi', 'A')
INSERT dbo.SanPham VALUES ('SP02', N'Bột Giặt Tide', 25, 200, N'Túi', 'A')
INSERT dbo.SanPham VALUES ('SP03', N'Đèn Bàn Rạng Đông', 100, 90, N'Cái', 'C')
INSERT dbo.SanPham VALUES ('SP04', N'Nồi cơm điện SHARP 3041', 2500, 10, N'Cái', 'B')
INSERT dbo.SanPham VALUES ('SP05', N'Bàn chải đánh răng PS', 12, 12, N'Cái', 'A')
INSERT dbo.SanPham VALUES ('SP06', N'Nồi cơm điện PANASONIC 2097', 2000, 8, N'Cái', 'B')
INSERT dbo.SanPham VALUES ('SP07', N'Bàn chải đánh răng Colgate', 16, 100, N'Cái', 'A')
GO


-- `dbo.HoaDon`
INSERT dbo.HoaDon VALUES ('HD01', '1900-01-01 00:00:00.000', 'KH01')
INSERT dbo.HoaDon VALUES ('HD02', '1900-01-01 00:00:00.000', 'KH02')
INSERT dbo.HoaDon VALUES ('HD03', '1900-01-01 00:00:00.000', 'KH05')
INSERT dbo.HoaDon VALUES ('HD04', '1900-01-01 00:00:00.000', 'KH01')
INSERT dbo.HoaDon VALUES ('HD05', '1900-01-01 00:00:00.000', 'KH02')
GO
-- `dbo.CTHoaDon`
INSERT dbo.CTHoaDon VALUES ('HD01', 'SP01', 2, '30')
INSERT dbo.CTHoaDon VALUES ('HD01', 'SP02', 2, '25')
INSERT dbo.CTHoaDon VALUES ('HD02', 'SP01', 3, '30')
INSERT dbo.CTHoaDon VALUES ('HD03', 'SP01', 3, '30')
INSERT dbo.CTHoaDon VALUES ('HD03', 'SP02', 3, '25')
INSERT dbo.CTHoaDon VALUES ('HD03', 'SP03', 1, '90')
INSERT dbo.CTHoaDon VALUES ('HD04', 'SP04', 1, '2400')
INSERT dbo.CTHoaDon VALUES ('HD05', 'SP01', 5, '30')
INSERT dbo.CTHoaDon VALUES ('HD05', 'SP06', 1, '2000')
GO


