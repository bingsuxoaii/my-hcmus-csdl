--gv ko tgia quá 2 cv trong 1 đề tài
--				Thêm	Xóa		Sửa ===> gây ảnh hưởng đến dữ liệu
--Thamgiadt		  +		 -		+
--//dấu + là có thể gây vi phạm ràng buộc
--khi thêm 1 dòng vào bảng Thamgiadt
-- thực hiện phân công 1 gv vào 1 cv trong detai
--> So cv trong detai của gv tang len => co kha nang lon hon >2 cv
--co kha nang vi pham rb

--xoa 1 dong trong thamgiadt => giảm bớt 1 phân công cv cho gv
--> ko co kha nang vi pham rb
--khi update 1 dòng trong thamgiadt
--gv01 dt01 1
--gv02 dt03 2
--gv02 dt03 1
--gv02 dt03 3


alter trigger tgPhanCong
on ThamGiaDT
for insert
as
begin
	--trong so nhung phan cong vua dc them vao
	--check so luong cv trong detai dc phancong cua cac gv do
	--khi tao trigger xuat hien 2 bang: inserted (mới dc thêm vô) va deleted(xóa)
	select * from inserted
	select * from deleted
	select * from THAMGIADT

	if exists(select count(*) from THAMGIADT tg join inserted i
	on tg.MAGV= tg.MAGV and tg.MADT=i.MADT 
	group by tg.MADT,tg.MAGV
	having count(*)>2)
	begin
		raiserror('GV ko tham gia qua 2 cv trong 1 detai',1,1)
		rollback--dua csdl ve trang tham thai truoc khi xay ra hanh dong insert
	end
end

go 
insert into THAMGIADT(MAGV,MADT,STT) values ('007','001',1),('007','001',2)
--1 cai sai thi ko thuc hien may cai con lai

