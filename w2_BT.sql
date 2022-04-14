--1. Hoàn chỉnh script tạo cấu trúc và nhập dữ liệu cho cơ sở dữ liệu Quản lý Giáo viên tham gia đề tài

create database QLDETAI
go
use QLDETAI
go

create table GIAOVIEN
(
	MAGV varchar(5),
	HOTEN nvarchar(50) not null,
	LUONG int default(0),
	PHAI nvarchar(3),
	NGSINH date,
	DIACHI nvarchar(100),
	GVQLCM varchar(5),
	MABM nvarchar(5), 
	Constraint PK_GIAOVIEN Primary key(MAGV)
)

create table BOMON
(
	MABM nvarchar(5), 
	TENBM nvarchar(50) not null,
	PHONG char(3),
	DIENTHOAI varchar(20),
	TRUONGBM varchar(5),
	MAKHOA varchar(5) not null,
	NGAYNHANCHUC date,
	Constraint PK_BOMON Primary key(MABM)
)

create table KHOA
(
	MAKHOA varchar(5),
	TENKHOA  nvarchar(50) not null,
	NAMTL int,
	PHONG char(3),
	DIENTHOAI varchar(20),
	TRUONGKHOA varchar(5),
	NGAYNHANCHUC date,
	Constraint PK_KHOA Primary key(MAKHOA)
)

create table CHUDE
(
	MACD nvarchar(5),
	TENCD nvarchar(50) not null
	Constraint PK_CHUDE Primary key(MACD)
)

create table DETAI
(
	MADT varchar(5),
	TENDT nvarchar(50) not null,
	CAPQL nvarchar(10) not null,
	KINHPHI int not null default(0),
	NGAYBD date,
	NGAYKT date,
	MACD nvarchar(5) not null,
	GVCNDT varchar(5) not null,
	Constraint PK_DETAI Primary key(MADT)
)

create table CONGVIEC
(
	MADT varchar(5),
	SOTT char(1),
	TENCV nvarchar(100) not null,
	NGAYBD datetime,
	NGAYKT datetime,
	Constraint PK_CONGVIEC Primary key(MADT,SOTT)
)

create table THAMGIADT
(
	MAGV varchar(5),
	MADT varchar(5),
	STT char(1),
	PHUCAP float not null default(0),
	KETQUA nvarchar(3),
	Constraint PK_THAMGIADT Primary key(MAGV,MADT,STT)
)

create table GV_DT
(
	MAGV varchar(5),
	DIENTHOAI varchar(20),
	Constraint PK_GV_DT Primary key(MAGV,DIENTHOAI)
)

create table NGUOITHAN
(
	MAGV varchar(5),
	TEN nvarchar(50),
	NGSINH date,
	PHAI nvarchar(3),
	Constraint PK_NGUOITHAN Primary key(MAGV,TEN)
)

alter table GIAOVIEN 
add constraint C_GIAOVIEN_PHAI check (PHAI in ('Nam', N'Nữ'))
alter table GIAOVIEN 
add constraint C_GIAOVIEN_LUONG check (LUONG>=0)
alter table BOMON  
add constraint U_BOMON_TENBM unique (TENBM)
alter table KHOA 
add constraint C_KHOA_NAMTL check (NAMTL>=1900)
alter table KHOA  
add constraint U_KHOA_TENKHOA unique (TENKHOA)
alter table CHUDE 
add constraint U_CHUDE_TENCD unique (TENCD)
alter table DETAI
add constraint U_DETAI_TENDT unique (TENDT)
alter table DETAI 
add constraint C_DETAI_KINHPHI check (KINHPHI>=0)
alter table THAMGIADT  
add constraint C_THAMGIADT_PHUCAP check (PHUCAP>=0)
alter table NGUOITHAN 
add constraint C_NGUOITHAN_PHAI check (PHAI in ('Nam', N'Nữ'))

alter table GIAOVIEN
add constraint FK_GIAOVIEN_GIAOVIEN foreign key (GVQLCM) references GIAOVIEN(MAGV)
alter table GIAOVIEN
add constraint FK_GIAOVIEN_BOMON foreign key (MABM) references BOMON(MABM)
alter table BOMON
add constraint FK_BOMON_GIAOVIEN foreign key (TRUONGBM) references GIAOVIEN(MAGV)
alter table BOMON
add constraint FK_BOMON_KHOA foreign key (MAKHOA) references KHOA(MAKHOA)
alter table KHOA
add constraint FK_KHOA_GIAOVIEN foreign key (TRUONGKHOA) references GIAOVIEN(MAGV)
alter table DETAI
add constraint FK_DETAI_CHUDE foreign key (MACD) references CHUDE(MACD)
alter table DETAI
add constraint FK_DETAI_GIAOVIEN foreign key (GVCNDT) references GIAOVIEN(MAGV)
alter table CONGVIEC  
add constraint FK_CONGVIEC_DETAI foreign key (MADT) references DETAI(MADT)
alter table THAMGIADT
add constraint FK_THAMGIADT_CONGVIEC foreign key (MADT,STT) references CONGVIEC(MADT,SOTT)
alter table THAMGIADT  
add constraint FK_THAMGIADT_GIAOVIEN foreign key (MAGV) references GIAOVIEN(MAGV)
alter table GV_DT  
add constraint FK_GV_DT_GIAOVIEN foreign key (MAGV) references GIAOVIEN(MAGV)
alter table NGUOITHAN
add constraint FK_NGUOITHAN_GIAOVIEN foreign key (MAGV) references GIAOVIEN(MAGV)

insert GIAOVIEN(MAGV,HOTEN,LUONG,PHAI,NGSINH,DIACHI,GVQLCM)
values('001',N'Nguyễn Hoài An',2000.0,'Nam','1973-02-15',N'25/3 Lạc Long Quân, Q.10, TP HCM',NULL),
('002',N'Trần Trà Hương',2500.0,N'Nữ','1960-06-20',N'125 Trần Hưng Đạo, Q.1,TP HCM',NULL),
('003',N'Nguyễn Ngọc Ánh',2200.0,N'Nữ','1975-05-11',N'12/21 Võ Văn Ngân Thủ Đức, TP HCM','002'),
('004',N'Trương Nam Sơn',2300.0,'Nam','1959-06-20',N'215 Lý Thường Kiệt,TP Biên Hòa',NULL),
('005',N'Lý Hoàng Hà',2500.0,'Nam','1954-10-23',N'22/5 Nguyễn Xí, Q.Bình Thạnh, TP HCM',NULL),
('006',N'Trần Bạch Tuyết',1500.0,N'Nữ','1980-05-20',N'127 Hùng Vương, TP Mỹ Tho','004'),
('007',N'Nguyễn An Trung',2100.0,'Nam','1976-06-05',N'234 3/2, TP Biên Hòa',NULL),
('008',N'Trần Trung Hiếu',1800.0,'Nam','1977-08-06',N'22/11 Lý Thường Kiệt, TP Mỹ Tho','007'),
('009',N'Trần Hoàng Nam',2000.0,'Nam','1975-11-22',N'234 Trấn Não, An Phú, TP HCM','001'),
('010',N'Phạm Nam Thanh',1500.0,'Nam','1980-12-12',N'221 Hùng Vương, Q.5, TP HCM','007')

insert KHOA
values('CNTT',N'Công nghệ thông tin','1995','B11','0838123456','002','2005-02-20'),
('HH',N'Hóa học','1980','B41','0838456456','007','2001-10-15'),
('SH',N'Sinh học','1980','B31','0838454545','004','2000-10-11'),
('VL',N'Vật lý','1976','B21','0838223223','005','2003-09-18')

insert BOMON
values('CNTT',N'Công nghệ tri thức','B15','0838126126',NULL,'CNTT',NULL),
('HHC',N'Hóa hữu cơ','B44','838222222',NULL,'HH',NULL),
('HL',N'Hóa lý','B42','0838878787',NULL,'HH',NULL),
('HPT',N'Hóa phân tích','B43','0838777777','007','HH','2007-10-15'),
('HTTT',N'Hệ thống thông tin','B13','0838125125','002','CNTT','2004-09-20'),
('MMT',N'Mạng máy tính','B16','0838676767','001','CNTT','2005-05-15'),
('SH',N'Sinh hóa','B33','0838898989',NULL,'SH',NULL),
(N'VLĐT',N'Vật lý điện tử','B23','0838234234',NULL,'VL',NULL),
(N'VLƯD',N'Vật lý ứng dụng','B24','0838454545','005','VL','2006-02-18'),
('VS',N'Vi sinh','B32','0838909090','004','SH','2007-01-01')

update GIAOVIEN
set MABM = 'MMT'
where MAGV = '001' or MAGV = '009'
update GIAOVIEN
set MABM = 'HTTT'
where MAGV = '002' or MAGV = '003'
update GIAOVIEN
set MABM = 'VS'
where MAGV = '004' or MAGV = '006'
update GIAOVIEN
set MABM = N'VLĐT'
where MAGV = '005'
update GIAOVIEN
set MABM = 'HPT'
where MAGV = '007' or MAGV = '008' or MAGV = '010' 

insert GV_DT
values ('001', '0838912112'),
('001', '0903123123'),
('002', '0913454545'),
('003', '0838121212'),
('003', '0903656565'),
('003', '0937125125'),
('006', '0937888888'),
('008', '0653717171'),
('008', '0913232323')

insert NGUOITHAN
values ('001', N'Hùng', '01/14/1990', 'Nam'),
('001', N'Thủy', '12/08/1994', N'Nữ'),
('003', N'Hà', '09/03/1998', N'Nữ'),
('003', N'Thu', '09/03/1998', N'Nữ'),
('007', N'Mai', '03/26/2003', N'Nữ'),
('007', N'Vy', '02/14/2000', N'Nữ'),
('008', N'Nam', '05/06/1991' ,'Nam'),
('009', N'An', '08/19/1996', 'Nam'),
('010', N'Nguyệt', '01/14/2006', N'Nữ')

insert CHUDE
values (N'NCPT', N'Nghiên cứu phát triển'),
(N'QLGD', N'Quản lý giáo dục'),
(N'ƯDCN', N'Ứng dụng công nghệ')

insert DETAI
values ('001', N'HTTT quản lý các trường ĐH', N'ĐHQG', 20.0, '10/20/2007', '10/20/2008', N'QLGD', '002'),
('002', N'HTTT quản lý giáo vụ cho một Khoa', N'Trường', 20.0, '10/12/2000', '10/12/2001', N'QLGD', '002'),
('003', N'Nghiên cứu chế tạo sợi Nanô Platin', N'ĐHQG', 300.0, '05/15/2008', '05/15/2010', N'NCPT', '005'),
('004', N'Tạo vật liệu sinh học bằng màng ối người', N'Nhà nước', 100.0, '01/01/2007', '12/31/2009', N'NCPT', '004'),
('005', N'Ứng dụng hóa học xanh', N'Trường', 200.0, '10/10/2003', '12/10/2004', N'ƯDCN', '007'),
('006', N'Nghiên cứu tế bào gốc', N'Nhà nước', 4000.0, '10/20/2006', '10/20/2009', N'NCPT', '004'),
('007', N'HTTT quản lý thư viện ở các trường ĐH', N'Trường', 20.0, '05/10/2009', '05/10/2010',N'QLGD', '001')

insert CONGVIEC
values ('001', 1, N'Khởi tạo và Lập kế hoạch', '10/20/2007', '12/20/2008'),
('001', 2, N'Xác định yêu cầu', '12/21/2008', '03/21/2008'),
('001', 3, N'Phân tích hệ thống', '03/22/2008', '05/22/2008'),
('001', 4, N'Thiết kế hệ thống', '05/23/2008', '06/23/2008'),
('001', 5, N'Cài đặt thử nghiệm', '06/24/2008', '10/20/2008'),
('002', 1, N'Khởi tạo và Lập kế hoạch', '05/10/2009', '07/10/2009'),
('002', 2, N'Xác định yêu cầu', '07/11/2009', '10/11/2009'),
('002', 3, N'Phân tích hệ thống', '10/12/2009', '12/20/2009'),
('002', 4, N'Thiết kế hệ thống', '12/21/2009', '03/22/2010'),
('002', 5, N'Cài đặt thử nghiệm', '03/23/2010', '05/10/2010'),
('006', 1, N'Lấy mẫu', '10/20/2006', '02/20/2007'),
('006', 2, N'Nuôi cấy', '02/21/2007', '08/21/2008')

insert THAMGIADT
values ('001', '002', 1, 0.0, NULL),
('001', '002', 2, 2.0, NULL),
('002', '001', 4, 2.0, N'Đạt'),
('003', '001', 1, 1.0, N'Đạt'),
('003', '001', 2, 0.0, N'Đạt'),
('003', '001', 4, 1.0, N'Đạt'),
('003', '002', 2, 0.0, NULL),
('004', '006', 1, 0.0, N'Đạt'),
('004', '006', 2, 1.0, N'Đạt'),
('006', '006', 2, 1.5, N'Đạt'),
('009', '002', 3, 0.5, NULL),
('009', '002', 4, 1.5, NULL)


--2 Viết script tạo cấu trúc và nhập dữ liệu cho cơ sở dữ liệu Quản lý Chuyến bay

create database QLCHUYENBAY
go
use QLCHUYENBAY
go 
create table KHACHHANG
(
	MAKH varchar(15),
	TEN varchar(15) not null,
	DCHI varchar(50),
	DTHOAI varchar(12),
	Constraint PK_KHACHHANG primary key(MAKH)
)

create table DATCHO
(
	MAKH varchar(15),
	NGAYDI date,
	MACB varchar(4),
	Constraint PK_DATCHO primary key(MAKH,NGAYDI,MACB)
)

create table LICHBAY 
(
	NGAYDI date,
	MACB varchar(4),
	SOHIEU int,
	MALOAI varchar(15),
	Constraint PK_LICHBAY primary key(NGAYDI,MACB)
)

create table CHUYENBAY
(
	MACB varchar(4),
	SBDI varchar(3),
	SBDEN varchar(3),
	GIODI time,
	GIODEN time,
	Constraint PK_CHUYENBAY primary key(MACB)
)

create table MAYBAY
(
	SOHIEU int,
	MALOAI varchar(15),
	Constraint PK_MAYBAY primary key(SOHIEU,MALOAI)
)

create table LOAIMB
(
	HANGSX varchar(15),
	MALOAI varchar(15),
	Constraint PK_LOAIMB primary key(MALOAI)
)

create table KHANANG
(
	MANV varchar(15),
	MALOAI varchar(15),
	Constraint PK_KHANANG primary key(MANV,MALOAI)
)

create table NHANVIEN
(
	MANV varchar(15),
	TEN varchar(15) not null,
	DCHI varchar(50),
	DTHOAI varchar(12) not null,
	LUONG decimal(10,2),
	LOAINV bit,
	Constraint PK_NHANVIEN primary key(MANV)
)

create table PHANCONG
(
	MANV varchar(15),
	NGAYDI date,
	MACB varchar(4),
	Constraint PK_PHANCONG primary key (MANV, NGAYDI, MACB)
)

alter table NHANVIEN
add constraint C_NHANVIEN_LUONG check (LUONG>=0)
alter table NHANVIEN
add constraint C_NHANVIEN_LOAINV check (LOAINV IN(0,1))
alter table NHANVIEN  
add constraint U_NHANVIEN_DTHOAI unique (DTHOAI)

alter table DATCHO
add constraint FK_DATCHO_KHACHHANG foreign key (MAKH) references KHACHHANG(MAKH)
alter table DATCHO
add constraint FK_DATCHO_LICHBAY foreign key (NGAYDI,MACB) references LICHBAY(NGAYDI,MACB)
alter table LICHBAY
add constraint FK_LICHBAY_CHUYENBAY foreign key (MACB) references CHUYENBAY(MACB)
alter table LICHBAY
add constraint FK_LICHBAY_MAYBAY foreign key (SOHIEU,MALOAI) references MAYBAY(SOHIEU,MALOAI)
alter table MAYBAY
add constraint FK_MAYBAY_LOAIMB foreign key (MALOAI) references LOAIMB(MALOAI)
alter table KHANANG
add constraint FK_KHANANG_LOAIMB foreign key (MALOAI) references LOAIMB(MALOAI)
alter table KHANANG
add constraint FK_KHANANG_NHANVIEN foreign key (MANV) references NHANVIEN(MANV)
alter table PHANCONG
add constraint FK_PHANCONG_NHANVIEN foreign key (MANV) references NHANVIEN(MANV)
alter table PHANCONG
add constraint FK_PHANCONG_LICHBAY foreign key (NGAYDI,MACB) references LICHBAY(NGAYDI,MACB)

insert KHACHHANG
values ('0009', 'Nga', '223 Nguyen Trai', '8932320'),
('0101', 'Anh', '567 Tran Phu', '8826729'),
('0045', 'Thu', '285 Le Loi', '8932203'),
('0012', 'Ha', '435 Quang Trung', '8933232'),
('0238', 'Hung', '456 Pasteur', '9812101'),
('0397', 'Thanh', '234 Le Van Si', '8952943'),
('0582', 'Mai', '789 Nguyen Du', NULL),
('0934', 'Minh', '678 Le Lai', NULL),
('0091', 'Hai', '345 Hung Vuong', '8893223'),
('0314', 'Phuong', '395 Vo Van Tan', '8232320'),
('0613', 'Vu', '348 CMT8', '8343232'),
('0586', 'Son', '123 Bach Dang', '8556223'),
('0442', 'Tien', '75 Nguyen Thong', '8332222')

insert CHUYENBAY
values 
('100', 'SLC', 'BOS', '08:00', '17:50'),
('112', 'DCA', 'DEN', '14:00', '18:07'),
('121', 'STL', 'SLC', '07:00', '09:13'),
('122', 'STL', 'YYV', '08:30', '10:19'),
('206', 'DFW', 'STL', '09:00', '11:40'),
('330', 'JFK', 'YYV', '16:00', '18:53'),
('334', 'ORD', 'MIA', '12:00', '14:14'),
('335', 'MIA', 'ORD', '15:00', '17:14'),
('336', 'ORD', 'MIA', '18:00', '20:14'),
('337', 'MIA', 'ORD', '20:30', '23:53'),
('394', 'DFW', 'MIA', '19:00', '21:30'),
('395', 'MIA', 'DFW', '21:00', '23:43'),
('449', 'CDG', 'DEN', '10:00', '19:29'),
('930', 'YYV', 'DCA', '13:00', '16:10'),
('931', 'DCA', 'YYV', '17:00', '18:10'),
('932', 'DCA', 'YYV', '18:00', '19:10'),
('991', 'BOS', 'ORD', '17:00', '18:22')

insert LOAIMB
values ('Airbus', 'A310'),
('Airbus', 'A320'),
('Airbus', 'A330'),
('Airbus', 'A340'),
('Boeing', 'B727'),
('Boeing', 'B747'),
('Boeing', 'B757'),
('MD', 'DC10'),
('MD', 'DC9')

insert MAYBAY
values (10, 'B747'),
(11, 'B727'),
(13, 'B727'),
(13, 'B747'),
(21, 'DC10'),
(21, 'DC9'),
(22, 'B757'),
(22, 'DC9'),
(23, 'DC9'),
(24, 'DC9'),
(70, 'A310'),
(80, 'A310'),
(93, 'B757')

insert LICHBAY
values ('11/01/2000', '100', 80, 'A310'),
('11/01/2000', '112', 21, 'DC10'),
('11/01/2000', '206', 22, 'DC9'),
('11/01/2000', '334', 10, 'B747'),
('11/01/2000', '395', 23, 'DC9'),
('11/01/2000', '991', 22, 'B757'),
('11/01/2000', '337', 10, 'B747'),
('10/31/2000', '100', 11, 'B727'),
('10/31/2000', '112', 11, 'B727'),
('10/31/2000', '206', 13, 'B727'),
('10/31/2000', '334', 10, 'B747'),
('10/31/2000', '335', 10, 'B747'),
('10/31/2000', '337', 24, 'DC9'),
('10/31/2000', '449', 70, 'A310')

insert DATCHO
values ('0009', '11/01/2000', '100'),
('0009', '10/31/2000', '449'),
('0045', '11/01/2000', '991'),
('0012', '10/31/2000', '206'),
('0238', '10/31/2000', '334'),
('0582', '11/01/2000', '991'),
('0091', '11/01/2000', '100'),
('0314', '10/31/2000', '449'),
('0613', '11/01/2000', '100'),
('0586', '11/01/2000', '991'),
('0586', '10/31/2000', '100'),
('0442', '10/31/2000', '449')

insert NHANVIEN
values('1006', 'Chi', '12/6 Nguyen Kiem', '8120012', 150000.00, 0),
('1005', 'Giao', '65 Nguyen Thai Son', '8324467', 500000.00, 0),
('1001', 'Huong', '8 Dien Bien Phu', '8330733', 500000.00, 1),
('1002', 'Phong', '1 Ly Thuong Kiet', '8308117', 450000.00, 1),
('1004', 'Phuong', '351 Lac Long Quan', '8308155', 250000.00, 0),
('1003', 'Quang', '78 Truong Dinh', '8324461', 350000.00, 1),
('1007', 'Tam', '36 Nguyen Van Cu', '8458188', 500000.00, 0)

insert PHANCONG
values ('1001', '11/01/2000', '100'),
('1001', '10/31/2000', '100'),
('1002', '11/01/2000', '100'),
('1002', '10/31/2000', '100'),
('1003', '10/31/2000', '100'),
('1003', '10/31/2000', '337'),
('1004', '10/31/2000', '100'),
('1004', '10/31/2000', '337'),
('1005', '10/31/2000', '337'),
('1006', '11/01/2000', '991'),
('1006', '10/31/2000', '337'),
('1007', '11/01/2000', '112'),
('1007', '11/01/2000', '991'),
('1007', '10/31/2000', '206')

insert KHANANG
values ('1001', 'B727'),
('1001', 'B747'),
('1001', 'DC10'),
('1001', 'DC9'),
('1002', 'A320'),
('1002', 'A340'),
('1002', 'B757'),
('1002', 'DC9'),
('1003', 'A310'),
('1003', 'DC9')



--*************NOTE
--UDPATE CA BANG

--UPDATE GIAOVIEN
--WHERE MAGV LIKE '001'
--SET TRUONGBM=NULL,NGAYNHANCHUC='1/1/2200'

--UDPATE CO DIEU KIEN

--delete bảng
--DELETE BOMON
--XÓA ĐIỀU KIỆN
---==>xóa dòng bắt đầu bằng chữ bộ môn
--DELETE BOMON
--WHERE MABM LIKE 'BM%'