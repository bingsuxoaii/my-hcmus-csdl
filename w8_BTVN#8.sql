--SCRIPT TẠO DATABASE ĐỂ TEST
create database W8
go 
use W8
go

create table KHACH 
(
	MAKH varchar(3),
	HOTEN nvarchar(50),
	DIACHI nvarchar(150),
	DIEN varchar(20)
	Primary key (MAKH)
)

create table PHONG 
(
	MAPHONG varchar(3),
	TINH nvarchar(4),
	LOAIPHONG varchar(20),
	DONGIA float,
	Primary key (MAPHONG)
)

create table DATPHONG 
(
	MA int,
	MAKH varchar(3),
	MAPHONG varchar(3),
	NGAYDATPHONG datetime,
	NGAYTRAPHONG datetime,
	THANHTIEN float,
	Primary key (MA)
)

alter table DATPHONG
add constraint FK_DATPHONG_PHONG foreign key (MAPHONG) references PHONG(MAPHONG)
alter table DATPHONG
add constraint FK_DATPHONG_KHACH foreign key (MAKH) references KHACH(MAKH)

insert into PHONG (MAPHONG, TINH, DONGIA)
values ('001', N'Rảnh', 300),
('002', N'Bận', 500),
('003', N'Rảnh', 240)

insert into KHACH (MAKH)
values ('001'),
('002')



--BÀI 1

go
create proc spDatPhong
	@makh varchar(5),
	@maphong varchar(5),
	@ngaydat datetime
as
begin

	--Kiểm tra mã khách hàng phải hợp lệ (phải xuất hiện trong bảng KHÁCH HÀNG)
	if not exists (select * from KHACH where MAKH = @makh)
	begin
		raiserror (N'Lỗi! Mã khách hàng không tồn tại', 15, 1)
		return 
	end

	--Kiểm tra mã phòng hợp lệ (phải xuất hiện trong bảng PHÒNG)
	if not exists (select * from PHONG where MAPHONG = @maphong)
	begin
		raiserror (N'Lỗi! Mã phòng không tồn tại', 15, 1)
		return 
	end

	--Chỉ được đặt phòng khi tình trạng của phòng là “Rảnh"
	if (not ((select TINH from PHONG where MAPHONG = @maphong) = N'Rảnh'))
	begin
		raiserror (N'Lỗi! Phòng đã có người khác đặt', 15, 1)
		return 
	end

	--Nếu bảng DATPHONG chưa có dữ liệu => mã đặt phòng bắt đầu từ số 1
	declare @madp int
	if not exists (select * from DATPHONG)
		set @madp = 1
	--Nếu đã có dữ liệu, phải phát sinh tự động theo cách sau: mã đặt phòng phát sinh = mã đặt phòng lớn nhất + 1.
	else 
		set @madp = 1 + (select max(MA) from DATPHONG)

	--Nếu các kiểm tra hợp lệ thì ghi nhận thông tin đặt phòng xuống CSDL (Ngày trả và thành tiền của khi đặt phòng là NULL)
	insert into DATPHONG values
	(@madp, @makh, @maphong, @ngaydat, NULL, NULL)
	print N'Đặt phòng thành công!'

	--Sau khi đặt phòng thành công thì phải cập nhật tình trạng của phòng là “Bận”
	update PHONG
	set TINH = N'Bận' 
	where MAPHONG = @maphong

end

go
exec spDatPhong '001', '001', '3/28/2022'
--Kết quả đã test trên CSDL mẫu: Đặt phòng thành công!
exec spDatPhong '002', '003', '3/3/2022'
--Kết quả đã test trên CSDL mẫu: Đặt phòng thành công!
exec spDatPhong '001', '013', '2/22/2022'
--Kết quả đã test trên CSDL mẫu: Lỗi! Mã phòng không tồn tại


--BÀI 2

go
create proc spTraPhong
	@madp int,
	@makh varchar(5)
as
begin

	--Kiểm tra tính hợp lệ của mã đặt phòng, mã khách hàng: Hợp lệ nếu khách hàng có thực hiện việc đặt phòng.
	if @madp not in (select MA from DATPHONG)
	begin
		raiserror (N'Lỗi! Mã đặt phòng không tồn tại', 15, 1)
		return 
	end
	if @makh not in (select MAKH from DATPHONG where MA = @madp)
	begin
		raiserror (N'Lỗi! Khách hàng không đặt phòng này', 15, 1)
		return 
	end

	--Ngày trả phòng chính là ngày hiện hành.
	update DATPHONG
	set NGAYTRAPHONG = GETDATE()
	where MAKH = @makh and MA = @madp

	--Tiền thanh toán được tính theo công thức: Tien = Số ngày mượn x đơn giá của phòng.
	declare @maphong varchar(5)
	set @maphong = (select MAPHONG from DATPHONG
	where MAKH = @makh and MA = @madp)

	declare @songaydat int
	set @songaydat = (select (DATEDIFF(d, NGAYDATPHONG, NGAYTRAPHONG)) from DATPHONG
	where MAKH = @makh and MA = @madp)

	declare @dongia float
	set @dongia = (select DONGIA from PHONG 
	where MAPHONG = @maphong)

	update DATPHONG
	set THANHTIEN = @dongia * @songaydat
	where MAKH = @makh and MA = @madp

	--Phải thực hiện việc cập nhật tình trạng của phòng là “Rảnh” sau khi ghi nhận thông tin trả phòng.
	update PHONG
	set TINH = N'Rảnh' 
	where MAPHONG = @maphong
		
	print N'Trả phòng thành công!'

end

go 
exec spTraPhong 1,'001'
--Kết quả đã test trên CSDL mẫu: Trả phòng thành công
exec spTraPhong 1,'002'
--Kết quả đã test trên CSDL mẫu: Lỗi! Khách hàng không đặt phòng này