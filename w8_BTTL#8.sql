
use QLDT

--a
go
create proc a_InHelloWorld
as
	print 'Hello World !!!'

go
exec a_InHelloWorld

--b
go
create proc b_InTong2So
	@a int,
	@b int
as
begin 
	declare @tong int
	set @tong = @a + @b
	print N'Tổng 2 số là: ' + cast(@tong as varchar(10))
end

go
exec b_InTong2So 3,7

--c
go
create proc c_TinhTong2So
	@a int,
	@b int, 
	@tong int out
as
	set @tong = @a + @b

go
declare @Sum int
exec c_TinhTong2So 5, -16, @Sum out
print N'Tổng 2 số là: ' + cast(@Sum as varchar(10))

--d
go
create proc d_InTong3So
	@a int, 
	@b int,
	@c int
as
begin
	declare @tong int
	exec c_TinhTong2So @a, @b, @tong out
	set @tong = @tong + @c
	print N'Tổng 3 số là: ' + cast(@tong as varchar(10))
end

go
exec d_InTong3So 5, 6, -3

--e
go
create proc e_TongSoNguyenMN
	@m int,
	@n int
as
begin
	declare @tong int
	declare @i int
	set @tong = 0
	set @i = @m
	while (@i < @n)
	begin
		set @tong = @tong + @i
		set @i = @i + 1
	end
	print N'Tổng các số nguyên từ m->n là: ' + cast(@tong as varchar(10))
end

go
exec e_TongSoNguyenMN 1,7

--f
go
create proc f_CheckSoNguyenTo
	@n int,
	@check bit out
as
begin
	declare @i int
	declare @sqrt float
	set @i = 2
	set @sqrt = SQRT(@n)
	set @check = 1

	if (@n <= 1)
		set @check = 0
	else 
	begin
		while (@i < = @sqrt)
		begin
			if (@n % @i = 0)
			begin
				set @check = 0
				break
			end

			set @i = @i + 1 
		end
	end

	if (@check = 0)
		print cast(@n as varchar(10))+ N' không là số nguyên tố'
	else 	
		print cast(@n as varchar(10))+ N' là số nguyên tố'

end

go 
declare @res bit 
exec f_CheckSoNguyenTo 14, @res out
exec f_CheckSoNguyenTo 61, @res out

--g
go
create proc g_TongSoNguyenToMN
	@m int,
	@n int
as
begin
	declare @tong int
	declare @i int
	set @tong = 0
	set @i = @m
	while (@i < @n)
	begin
		declare @check bit
		exec f_CheckSoNguyenTo @i, @check out
		if (@check = 1)
			set @tong = @tong + @i
		set @i = @i + 1
	end
	print N'Tổng các số nguyên tố từ m->n là: '+ cast(@tong as varchar(10))
end

go
exec g_TongSoNguyenToMN 1, 6

--h
go
create proc h_TinhUCLN 
	@a int,
	@b int,
	@ucln int out
as
begin
	set @a = ABS(@a)
	set @b = ABS(@b)
	while (@b != 0)
		begin
			declare @temp int
			set @temp = @a % @b
			set @a = @b
			set @b = @temp
		end
	set @ucln = @a
	return @a
end

go
declare @res int
exec h_TinhUCLN 6, -18, @res out
print N'Ước chung lớn nhất là: '+ cast(@res as varchar(10))
 
--i
go
create proc i_TinhBCNN
	@a int,
	@b int,
	@bcnn int out
as
begin
	declare @temp int	
	exec h_TinhUCLN @a, @b, @temp out
	set @bcnn = ABS(@a * @b) / @temp
end

go
declare @res int
exec i_TinhBCNN 100, 2, @res out
print N'Bội chung nhỏ nhất là: '+ cast(@res as varchar(10))

--j
go
create proc j_XuatDanhSachGV
as
begin
	select * from GIAOVIEN
end

go
exec j_XuatDanhSachGV

--k
go
create proc k_TinhSLDeTaiThamGia
	@magv varchar(5),
	@sldt int out
as
begin
	set @sldt = (select count(distinct MADT)
	from THAMGIADT where MAGV = @magv
	group by MAGV)
end

go
declare @res int
exec k_TinhSLDeTaiThamGia '001', @res out
print N'Số lượng đề tài tham gia: '+ cast(@res as varchar(10))

--l
go
create proc l_InThongTinChiTiet1GV
	@magv varchar(5)
as
begin
	declare @tengv nvarchar(40)
	select @tengv = HOTEN from GIAOVIEN where MAGV = @magv
	print N'Tên giáo viên: ' + @tengv

	declare @phai nvarchar(3)
	select @phai = PHAI from GIAOVIEN where MAGV = @magv
	print N'Phái: ' + @phai

	declare @luong float
	select @luong = LUONG from GIAOVIEN where MAGV = @magv
	print N'Lương: ' + cast(@luong as varchar(10))

	declare @ngaysinh date
	select @ngaysinh = NGSINH from GIAOVIEN where MAGV = @magv
	print N'Ngày sinh: ' + cast(@ngaysinh as varchar(12))

	declare @diachi nvarchar(100)
	select @diachi = DIACHI from GIAOVIEN where MAGV = @magv
	print N'Địa chỉ: ' + @diachi

	declare @sldt int
	exec k_TinhSLDeTaiThamGia @magv, @sldt out
	print N'Số lượng đề tài tham gia: ' + cast(@sldt as varchar(10))
	
	declare @sltn int
	select @sltn = count (*) 
	from NGUOITHAN
	where MAGV = @magv
	print N'Số lượng thân nhân: ' + cast(@sltn as varchar(10))

end

go
exec l_InThongTinChiTiet1GV '001'

--m
go
create proc m_KiemTraGVTonTai
	@magv varchar(5)
as
begin
	if exists(select * from GIAOVIEN where MAGV = @magv)
		print N'Giáo viên ' + @magv + N' có tồn tại'
	else
		print N'Không tồn tại giáo viên '+ @magv
end

go
exec m_KiemTraGVTonTai '001'
exec m_KiemTraGVTonTai '013'

--n
go
create proc n_KiemTraQuyDinh
	@magv varchar(5),
	@madt varchar(5),
	@check bit out
as
begin
	declare @bm_gvcn nvarchar(5)
	set @bm_gvcn = (select MABM 
	from GIAOVIEN GV join DETAI DT on GV.MAGV = DT.GVCNDT
	where DT.MADT = @madt)

	declare @bm_gv nvarchar(5)
	set @bm_gv = (select MABM 
	from GIAOVIEN 
	where MAGV = @magv)

	if (@bm_gv = @bm_gvcn)
	begin
		print N'Thoả quy định'
		set @check = 1
	end
	else
	begin
		print N'Không thoả quy định'
		set @check = 0
	end
end

go
declare @res bit
exec n_KiemTraQuyDinh '001', '003', @res out
exec n_KiemTraQuyDinh '002', '002', @res out

--o
go
create proc o_PhanCong1CV
	@magv varchar(5),
	@madt varchar(5),
	@stt int,
	@thoigiantg int
as
begin
	declare @check bit
	set @check = 1

	if not exists (select * from GIAOVIEN where MAGV = @magv)
	begin
		raiserror (N'Lỗi! Mã giáo viên không tồn tại', 15, 1)
		return 
	end

	if not exists (select * from CONGVIEC where MADT = @madt and SOTT = @stt)
	begin
		raiserror (N'Lỗi! Công việc không tồn tại', 15, 1)
		return 
	end

	if @thoigiantg <= 0 
	begin
		raiserror (N'Lỗi! Thời gian tham gia phải > 0', 15, 1)
		return
	end

	declare @res_n bit
	exec n_KiemTraQuyDinh @magv, @madt, @res_n
	if (@res_n = 1)
		set @check = 0

	if (@check = 1) 
		begin
			insert into THAMGIADT(MAGV,MADT,STT) values (@magv,@madt,@stt)
			print N'Phân công thành công!'
		end
end

go 
exec o_PhanCong1CV '001', '002', 3, -5
exec o_PhanCong1CV '002', '002', 3, 2

--p
go
create proc p_XoaGVTheoMaGV
	@magv varchar(5)
as
	
begin
	if exists (select * from GIAOVIEN where MAGV = @magv)
	begin
		if exists (select * from NGUOITHAN where MAGV = @magv)
		begin
			raiserror (N'Lỗi! Giáo viên có thân nhân', 15, 1)
			return 
		end
		
		if exists (select * from THAMGIADT where MAGV = @magv)
		begin
			raiserror (N'Lỗi! Giáo viên có tham gia đề tài', 15, 1)
			return 
		end
		
		if exists (select * from DETAI where GVCNDT = @magv)
		begin
			raiserror (N'Lỗi! Giáo viên có chủ nhiệm đề tài', 15, 1)
			return 
		end

		if exists (select * from GIAOVIEN where GVQLCM = @magv)
		begin
			raiserror (N'Lỗi! Giáo viên này đang là quản lí chuyên môn cho 1 GV khác', 15, 1)
			return 
		end

		if exists (select * from GV_DT where MAGV = @magv)
		begin
			raiserror (N'Lỗi! Giáo viên có tồn tại số điện thoại', 15, 1)
			return 
		end

		if exists (select * from KHOA where TRUONGKHOA = @magv)
		begin
			raiserror (N'Lỗi! Giáo viên là trưởng khoa', 15, 1)
			return 
		end

		if exists (select * from BOMON where TRUONGBM = @magv)
		begin
			raiserror (N'Lỗi! Giáo viên là trưởng bộ môn', 15, 1)
			return 
		end

		delete from GIAOVIEN where MAGV = @magv
		print N'Xoá thành công !'

	end

	else 
		begin
			raiserror (N'Lỗi! Mã giáo viên không tồn tại', 15, 1)
			return 
		end
end

go
exec p_XoaGVTheoMaGV '002'
exec p_XoaGVTheoMaGV '013'

--q
go
create proc In_SLGV_1GV_QL
	@magv varchar(5)
as
begin
	declare @slgvql int
	select @slgvql = count (distinct MAGV) 
	from GIAOVIEN
	where GVQLCM = @magv
	print N'Số lượng giáo viên mà người đó quản lí: ' + cast(@slgvql as varchar(10))
end

go
create proc q_InDanhSachGVTheoPhongBan
	@maphongban varchar(5)
as
begin
	declare @magv varchar(5)

	declare cursor_GIAOVIEN cursor for (select MAGV from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
	where @maphongban = BM.PHONG)
	
	open cursor_GIAOVIEN

	fetch next from cursor_GIAOVIEN into @magv

	while @@FETCH_STATUS = 0
	begin 
		exec l_InThongTinChiTiet1GV @magv
		exec In_SLGV_1GV_QL @magv
		print '=================================================='
		fetch next from cursor_GIAOVIEN into @magv
	end

	close cursor_GIAOVIEN
	deallocate cursor_GIAOVIEN
end

go
exec q_InDanhSachGVTheoPhongBan 'B16'

--r
go
create proc r_KiemTraQuyDinh2GV
	@magv_a varchar(5),
	@magv_b varchar(5)
as
begin 
	declare @bm_c nvarchar(5)
	select @bm_c = MABM from GIAOVIEN where MAGV = @magv_b  

	if (@magv_a = (select TRUONGBM from BOMON where MABM = @bm_c))
		if (select LUONG from GIAOVIEN where MAGV = @magv_a) > (select LUONG from GIAOVIEN where MAGV = @magv_b)
		begin
			print N'Thoả quy định của 2 giáo viên A,B'
			return 
		end
			print N'Không thoả quy định của 2 giáo viên A,B'
end

go 
exec r_KiemTraQuyDinh2GV '002', '001'
exec r_KiemTraQuyDinh2GV '002', '003'

--s
go
create proc s_Them1GV
	@magv varchar(5),
	@hoten nvarchar(40),
	@luong float,
	@phai nchar(3),
	@ngsinh datetime,
	@diachi nvarchar(100),
	@gvqlcm varchar(5),
	@mabm varchar(5)
as
begin
	if exists (select * from GIAOVIEN where MAGV = @magv)
	begin
		raiserror (N'Lỗi! Mã giáo viên đã tồn tại', 15, 1)
		return
	end

	if exists (select * from GIAOVIEN where HOTEN = @hoten)
	begin
		raiserror (N'Lỗi! Trùng tên giáo viên', 15, 1)
		return
	end

	if (year(GETDATE()) - year(@ngsinh)) <= 18
	begin
		raiserror (N'Lỗi! Tuổi phải > 18', 15, 1)
		return
	end

	if (@luong <= 0)
	begin
		raiserror (N'Lỗi! Lương phải > 0', 15, 1)
		return
	end

	if not exists (select * from BOMON where MABM = @mabm)
	begin
		raiserror (N'Lỗi! Không tồn tại bộ môn này', 15, 1)
		return
	end

	if not exists (select * from GIAOVIEN where MAGV = @gvqlcm)
	begin
		raiserror (N'Lỗi! Không tồn tại giáo viên này để có thể thêm như QLCM cho GV mới', 15, 1)
		return
	end

	insert into GIAOVIEN
	values (@magv, @hoten, @luong, @phai, @ngsinh, @diachi, @gvqlcm, @mabm)
	print N'Thêm Thành Công!'
end

go
exec s_Them1GV '013',N'Nguyễn Văn Hải',3950,N'Nam','2001-2-3',N'Số 2-229 đường văn lang','002','VS'
exec s_Them1GV '011','Lan Hoàng Anh',900,N'nữ','2021-2-3',N'no 2 đa kao','001','HTTT'

--t
go
create proc t_TuDongXacDinhMaGV
	@magv varchar(3) out
as
begin
	declare @tong_gv int
	select @tong_gv = count(*) from GIAOVIEN 
	set @tong_gv = @tong_gv + 1
	declare @i int
	set @i = 1
	declare @tmp varchar(3)

	while (@i <= @tong_gv)
	begin
		if (@i < 10)
			set @tmp = '00' + cast(@i as varchar(1))
		else if (@i < 100)
			set @tmp = '0' + cast(@i as varchar(2))
		else 
			set @tmp = cast(@i as varchar(3))

		if not exists(select * from GIAOVIEN where MAGV = @tmp)
		begin
			set @magv = @tmp
			break
		end
		
		set @i = @i + 1
	end
end

go
declare @auto_magv varchar(3)
exec t_TuDongXacDinhMaGV @auto_magv out
print N'Mã GV tự động tạo là: ' + @auto_magv