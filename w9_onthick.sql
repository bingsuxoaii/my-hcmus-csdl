--1.Viết stored thực hiện phân công 1 giảng viên tham gia 1 công việc của 1 đề tài cụ thể. 
--Lưu ý: mỗi giảng viên chỉ được tham gia tối đa 3 công việc của 1 đề tài. Nếu vi phạm thì báo lỗi không thực hiện phân công

go
create proc q1_PhanCong
	@magv varchar(5),
	@madt varchar(5),
	@stt int
as
begin
	if not exists (select * from GIAOVIEN where MAGV = @magv)
	begin
		raiserror (N'Lỗi! Mã giáo viên không tồn tại', 1, 1)
		return 
	end

	if not exists (select * from CONGVIEC where MADT = @madt and SOTT = @stt)
	begin
		raiserror (N'Lỗi! Công việc không tồn tại', 1, 1)
		return 
	end

	if exists(select count(*) from THAMGIADT 
	where MADT = @madt 
	group by MADT,MAGV
	having count(*)>3)

	begin
		raiserror('Lỗi! GV ko tham gia quá 3 cv trong 1 đề tài',1,1)
		return
	end

	insert into THAMGIADT(MAGV,MADT,STT) values (@magv,@madt,@stt)
	print N'Phân công thành công!'

end

go 
exec q1_PhanCong '007','001',3
exec q1_PhanCong '003','001',3

--2.Viết store thực hiện cập nhật ngày kết thúc của dự án. Lưu ý, ngày kết thúc phải sau ngày bắt đầu theo quy định:
--Đề tài cấp trường: thời gian thực hiện tối thiểu là 3 tháng, tối đa là 6 tháng
--Đề tài cấp ĐHQG thời gian thực hiện tối thiểu là 6 tháng, tối đa là 9 tháng
--Đề tài cấp nhà nước thời gian thực hiện tối thiểu là 12 tháng, tối đa là 24 tháng

go
create proc q2_CapNhatNgayKT
	@madt varchar(5),
	@ngaykt datetime
as
begin
	if not exists (select * from DETAI where MADT = @madt)
	begin
		raiserror (N'Lỗi! Đề tài không tồn tại', 1, 1)
		return 
	end

	declare @capql nvarchar(40)
	set @capql = (select CAPQL from DETAI where MADT = @madt)
	declare @tgianth int
	set @tgianth = datediff(m, (select NGAYBD from DETAI where MADT = @madt),@ngaykt)

	if (@capql = N'Trường') and (@tgianth < 3 or @tgianth > 6)
	begin
		raiserror (N'Lỗi! Thời gian thực hiện tối thiểu là 3 tháng, tối đa là 6 tháng', 1, 1)
		return
	end

	if (@capql = N'ĐHQG') and (@tgianth < 6 or @tgianth > 9)
	begin
		raiserror (N'Lỗi! Thời gian thực hiện tối thiểu là 6 tháng, tối đa là 9 tháng', 1, 1)
		return
	end

	if (@capql = N'Nhà nước') and (@tgianth < 12 or @tgianth > 24)
	begin
		raiserror (N'Lỗi! Thời gian thực hiện tối thiểu là 12 tháng, tối đa là 24 tháng', 1, 1)
		return
	end
	
	update DETAI
	set NGAYKT = @ngaykt
	where MADT = @madt
	print N'Cập nhật thành công!'

end
go 
exec q2_CapNhatNgayKT '001', '2008-5-5'
exec q2_CapNhatNgayKT '004', '2007-11-12'
exec q2_CapNhatNgayKT '002', '2000-11-12'
exec q2_CapNhatNgayKT '003', '2009-11-12'


--3. Viết store thực hiện cập nhật giáo viên quản lý chuyên môn cho 1 giảng viên cụ thể. 
--Lưu ý, GVQLCM phải cùng bộ môn với giảng viên cần cập nhật
go
create proc q3_CapNhatQLCM
	@magv varchar(5),
	@qlcm varchar(5)
as
begin
	if not exists (select * from GIAOVIEN where MAGV = @magv)
	begin
		raiserror (N'Lỗi! Giảng viên cần cập nhật không tồn tại', 1, 1)
		return 
	end

	if not exists (select * from GIAOVIEN where MAGV = @qlcm)
	begin
		raiserror (N'Lỗi! Mã của giáo viên quản lý chuyên môn không tồn tại', 1, 1)
		return 
	end

	if not ((select MABM from GIAOVIEN where MAGV = @qlcm) = (select MABM from GIAOVIEN where MAGV = @magv))
	begin
		raiserror (N'Lỗi! Bộ môn của GVQLCM đang khác với bộ môn với giảng viên cần cập nhật', 1, 1)
		return 
	end

	if (@magv <> @qlcm)
	begin
		update GIAOVIEN
		set GVQLCM = @qlcm
		where MAGV = @magv
		print N'Cập nhật giáo viên ' + @qlcm + N' quản lý chuyên môn cho giảng viên ' + @magv + N' thành công!'
	end
	else
		print N'Lỗi! Mã của giáo viên quản lý chuyên môn phải khác mã giảng viên cần cập nhật'
end

go
exec q3_CapNhatQLCM '001','002'
exec q3_CapNhatQLCM '001','001'

--4. Viết function đếm số đề tài tham gia của 1 magv
go
create function DemSoDTTG(@magv varchar(5))
returns int
as
begin
	if not exists (select * from THAMGIADT where MAGV = @magv)
		return 0

	return (select count(distinct MADT) from THAMGIADT where MAGV = @magv
	group by MAGV)
end

go
declare @res int 
set @res = dbo.DemSoDTTG('004')
print N'Số đề tài GV tham gia: ' + cast(@res as varchar(3))

--5. Viết stored xuất danh sách (magv, ho ten, ten bo mon) của các giảng viên tham gia trên 3 đề tài (gọi lại function câu 4)
go
create proc q5_XuatDSGVThamGiaTren3DT
as
begin

	declare @magv varchar(5)
	declare @tenbm nvarchar(40)
	declare cursor_GIAOVIEN cursor for (select MAGV, TENBM from GIAOVIEN GV join BOMON BM on GV.MABM=BM.MABM
	where dbo.DemSoDTTG(MAGV) > 3)
	
	open cursor_GIAOVIEN

	fetch next from cursor_GIAOVIEN into @magv, @tenbm

	while @@FETCH_STATUS = 0
	begin 

		print N'Mã giáo viên: ' + @magv

		declare @tengv nvarchar(40)
		select @tengv = HOTEN from GIAOVIEN where MAGV = @magv
		print N'Tên giáo viên: ' + @tengv

		print N'Tên bộ môn: ' + @tenbm

		print '=================================================='
		fetch next from cursor_GIAOVIEN into @magv, @tenbm
	end

	close cursor_GIAOVIEN
	deallocate cursor_GIAOVIEN
end


go
exec q5_XuatDSGVThamGiaTren3DT

IF OBJECT_ID('quiz5_c2','P') IS NOT NULL
	DROP PROC quiz5_c2
GO

create proc quiz5_c2
as
begin
	select MAGV, hoten, TENBM from GIAOVIEN GV join BOMON BM on GV.MABM=BM.MABM
	where dbo.DemSoDTTG(MAGV) > 3
end

go 
exec quiz5_c2
--6. Viết function đếm số đề tài chủ nhiệm của 1 magv

GO
IF OBJECT_ID('DemSoDTCN','P') IS NULL
	DROP FUNCTION DemSoDTCN
GO

create function DemSoDTCN(@magv varchar(5))
returns int
as
begin
	if not exists (select * from DETAI where GVCNDT = @magv)
		return 0

	return (select count(distinct MADT) from DETAI where GVCNDT = @magv
	group by GVCNDT)
	
end

go
declare @res int 
set @res = dbo.DemSoDTCN('004')
print N'Số đề tài GV chủ nhiệm: ' + cast(@res as varchar(3))

--7. Viết stored xuất danh sách (magv, họ tên, số đề tài chủ nhiệm) của mỗi giảng viên thuộc bộ môn HTTT.
go
create proc q7_XuatDSGV_HTTT
as
begin

	declare @magv varchar(5)

	declare cursor_GIAOVIEN cursor for (select MAGV from GIAOVIEN where MABM = 'HTTT')
	
	open cursor_GIAOVIEN

	fetch next from cursor_GIAOVIEN into @magv

	while @@FETCH_STATUS = 0
	begin 

		print N'Mã giáo viên: ' + @magv

		declare @tengv nvarchar(40)
		select @tengv = HOTEN from GIAOVIEN where MAGV = @magv
		print N'Tên giáo viên: ' + @tengv

		declare @sdtcn int 
		set @sdtcn = dbo.DemSoDTCN(@magv)
		print N'Số đề tài GV chủ nhiệm: ' + cast(@sdtcn as varchar(3))

		print '=================================================='
		fetch next from cursor_GIAOVIEN into @magv
	end

	close cursor_GIAOVIEN
	deallocate cursor_GIAOVIEN
end


go 
create proc q7_c2
as 
begin
	SELECT MAGV,HOTEN,DBO.DemSoDTCN(MAGV) AS N'Số đề tài GV chủ nhiệm' FROM GIAOVIEN WHERE MABM = 'HTTT'
end
go 
exec q7_c2