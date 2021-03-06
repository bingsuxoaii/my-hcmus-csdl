USE [master]
GO
/****** Object:  Database [QLBHSieuThi]    Script Date: 17/5/2016 4:06:53 PM ******/
CREATE DATABASE [QLBHSieuThi]
go
USE [QLBHSieuThi]
GO

CREATE TABLE [dbo].[CTHoaDon](
	[MaHD] [varchar](5) NOT NULL,
	[MASP] [varchar](5) NOT NULL,
	[SoLuong] [int] NULL,
	[DonGia] [varchar](5) NULL,
	Primary key (mahd, masp)
 )

GO

CREATE TABLE [dbo].[HoaDon](
	[MaHD] [varchar](5) NOT NULL,
	[NgayLap] [datetime] NULL,
	[MaKH] [varchar](5) NULL,
	--[MaNV] [varchar](5)
	Primary key(mahd)
)

GO
CREATE TABLE [dbo].[KhachHang](
	[MaKH] [varchar](5) NOT NULL,
	[HoTen] [nvarchar](20) NULL,
	[DiaChi] [nvarchar](15) NULL,
	[DienThoai] [varchar](11) NULL,
	[NamSinh] [varchar](4) NULL,
	[GioiTinh] [nvarchar](3) NULL,
 Primary key(maKH)
 )
GO
CREATE TABLE [dbo].[NhanVien](
	[MaNV] [varchar](5) NOT NULL,
	[HoTen] [nvarchar](20) NULL,		
	[NamSinh] [varchar](4) NULL,
	[GioiTinh] [nvarchar](3) NULL,
	[CMND] varchar (13) NULL,
	[NVQL] [varchar](5) 
	Primary key(manv)
 )
GO
CREATE TABLE [dbo].[LoaiSanPham](
	[MaLoai] [varchar](3) NOT NULL,
	[TenLoai] [nvarchar](15) NULL,
 Primary key(maloai)
 )
GO
CREATE TABLE [dbo].[SanPham](
	[MASP] [varchar](5) NOT NULL,
	[Ten] [nvarchar](30) NULL,
	[GiaTien] [int] NULL,
	[SLTon] [int] NULL,
	[DonViTinh] [nvarchar](5) NULL,
	[MaLoai] [varchar](3) NULL,
	Primary key(masp)
)
GO


ALTER TABLE [dbo].[CTHoaDon]  WITH CHECK ADD  CONSTRAINT [Fk_CTHD] FOREIGN KEY([MaHD])
REFERENCES [dbo].[HoaDon] ([MaHD])
GO
ALTER TABLE [dbo].[CTHoaDon] CHECK CONSTRAINT [Fk_CTHD]
GO
ALTER TABLE [dbo].[CTHoaDon]  WITH CHECK ADD  CONSTRAINT [Fk_CTSP] FOREIGN KEY([MASP])
REFERENCES [dbo].[SanPham] ([MASP])
GO
ALTER TABLE [dbo].[CTHoaDon] CHECK CONSTRAINT [Fk_CTSP]
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD  CONSTRAINT [Fk_HDKH] FOREIGN KEY([MaKH])
REFERENCES [dbo].[KhachHang] ([MaKH])
GO
ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [Fk_HDKH]
GO


ALTER TABLE [dbo].[SanPham]  WITH CHECK ADD  CONSTRAINT [Fk_SPLSP] FOREIGN KEY([MaLoai])
REFERENCES [dbo].[LoaiSanPham] ([MaLoai])
GO