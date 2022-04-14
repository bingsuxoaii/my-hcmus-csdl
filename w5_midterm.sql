create database QLND
go
use QLND
go
create table LOAINHA
(
	MaLoaiNha varchar(4),
	TenLoaiNha nvarchar(20),
	ChiNhanh varchar(4),
	NhaDD varchar(5),
	constraint PK_LOAINHA primary key (MaLoaiNha)
)

create table NHA
(
	ChiNhanh varchar(4),
	MaNha varchar(5),
	LoaiNha varchar(4),
	DiaChi nvarchar(150),
	TienThue money,
	constraint PK_NHA primary key (ChiNhanh,MaNha)
)

create table NGUOITHUE
(
	MaNguoiThue varchar(6),
	HoTen nvarchar(50),
	SDT varchar(11),
	LoaiNha varchar(4),
	constraint PK_NGUOITHUE primary key (MaNguoiThue)
)

create table XEMNHA
(
	NguoiThue varchar(6),
	ChiNhanh varchar(4),
	Nha varchar(5),
	NgayXem datetime,
	NhanXet nvarchar(100),
	constraint PK_XEMNHA primary key (NguoiThue,NgayXem)
)


--LOAINHA(ChiNhanh,NhaDD)-->NHA(ChiNhanh,MaNha)
--NHA(LoaiNha)-->LOAINHA(MaLoaiNha) ko chắc
--NHA(ChiNhanh,LoaiNha)-->LOAINHA(ChiNhanh,MaLoaiNha)
--NGUOITHUE(LoaiNha)-->LOAINHA(MaLoaiNha)
--XEMNHA(NguoiThue)-->NGUOITHUE(MaNguoiThue)
--XEMNHA(ChiNhanh,Nha)-->NHA(ChiNhanh,MaNha)

alter table LOAINHA
add constraint FK_LOAINHA_NHA foreign key (ChiNhanh,NhaDD) references NHA(ChiNhanh,MaNha)
alter table NHA
add constraint FK_NHA_LOAINHA foreign key (LoaiNha) references LOAINHA(MaLoaiNha)
alter table  NGUOITHUE
add constraint FK_NGUOITHUE_LOAINHA foreign key (LoaiNha) references LOAINHA(MaLoaiNha)
alter table XEMNHA
add constraint FK_XEMNHA_NGUOITHUE foreign key (NguoiThue) references NGUOITHUE(MaNguoiThue)
alter table XEMNHA
add constraint FK_XEMNHA_NHA foreign key (ChiNhanh,Nha) references NHA(ChiNhanh,MaNha)


insert into NGUOITHUE(MaNguoiThue,HoTen,SDT)
values ('NT0001',N'Trần Hữu Tiến','0935936521'),
('NT0002',N'Đỗ Văn Nhuận',NULL),
('NT0003',N'Phan Huỳnh Mạnh','0945563293'),
('NT0004',N'Vi Nhật Linh','0386547746')

insert into NHA(ChiNhanh,MaNha,DiaChi,TienThue)
values ('CN01','N0001',N'245/3 Nguyễn Tri Phương, P4, Q5, TP HCM','8000000'),
('CN01','N0002',N'66a Võ Văn Tần, P3, Q3, TP HCM ','5000000'),
('CN02','N0001',N'31 Hàm Nghi, P Bến Thành, Q1, TP HCM','20000000'),
('CN02','N0002',N'A10/51 Rạch ông Đồ, ấp 1, Xã Bình Chánh,Huyện Bình Chánh, TP HCM','500000')

insert into LOAINHA
values ('LN01',N'Nhà phố','CN01','N0002'),
('LN02',N'Biệt thự','CN02','N0001'),
('LN03',N'Nhà cấp 4','CN02','N0002')


insert into XEMNHA
values ('NT0001','CN01','N0002','3/22/2022',N'Bồn rửa bị hư chưa sửa, nhà thoáng'),
('NT0002','CN02','N0001','02/04/2022',N'Nhà thiết kế chật, ít ánh sáng'),
('NT0001','CN01','N0002','03/27/2022',N'Bồn rửa sửa sạch đẹp'),
('NT0001','CN02','N0002','11/24/2022',N'Nhà nhỏ'),
('NT0004','CN01','N0001','12/10/2022 ',N'Nhà đẹp, rộng rãi')


update NGUOITHUE
set LoaiNha='LN01'
where MaNguoiThue='NT0001' or MaNguoiThue='NT0004'

update NGUOITHUE
set LoaiNha='LN03'
where MaNguoiThue='NT0002'

update NGUOITHUE
set LoaiNha='LN02'
where MaNguoiThue='NT0003'
  
update NHA
set LoaiNha='LN02'
where ChiNhanh='CN01' and MaNha='N0001'
update NHA
set LoaiNha='LN01'
where ChiNhanh='CN01' and MaNha='N0002'
update NHA
set LoaiNha='LN02'
where ChiNhanh='CN02' and MaNha='N0001'
update NHA
set LoaiNha='LN03'
where ChiNhanh='CN02' and MaNha='N0002'


--1
select NgayXem,n.ChiNhanh,TenLoaiNha,MaNha,MaNguoiThue,HoTen,SDT,NhanXet
from NHA n join XEMNHA xn on n.ChiNhanh=xn.ChiNhanh and xn.Nha=n.MaNha
join LOAINHA ln on n.LoaiNha=ln.MaLoaiNha
join NGUOITHUE nt on xn.NguoiThue =nt.MaNguoiThue
where DiaChi like '%Q3, TP HCM'
--2
SELECT nt.MaNguoiThue,nt.HoTen
FROM NGUOITHUE nt JOIN XEMNHA xn ON nt.MaNguoiThue=xn.NguoiThue
GROUP BY nt.MaNguoiThue,nt.HoTen
HAVING COUNT(xn.NHA)>2