select *
from [portflio project].dbo.Housingdata

--standardize the sale date

select SaleDate
from [portflio project]..Housingdata

select SaleDate,convert(date,SaleDate)
from [portflio project]..Housingdata

update [portflio project]..Housingdata
set SaleDate = CONVERT(date,SaleDate)
--both are not working

alter table [portflio project]..Housingdata
add saleDate2 date

update [portflio project]..Housingdata
set SaleDate2 = CONVERT(date,SaleDate)

select SaleDate2,convert(date,SaleDate)as saledate
from [portflio project]..Housingdata

--populate property address

select PropertyAddress
from [portflio project]..Housingdata
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from [portflio project]..Housingdata a
join [portflio project]..Housingdata b
on a.ParcelID =b.ParcelID 
and a.[UniqueID ]<>b.[UniqueID ]

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [portflio project]..Housingdata a
join [portflio project]..Housingdata b
on a.ParcelID =b.ParcelID 
and a.[UniqueID ]<>b.[UniqueID ]

--breaking down address into individual columns(address ,city,state)

select PropertyAddress
from [portflio project]..Housingdata
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
from [portflio project]..Housingdata


select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,  CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) as city
from [portflio project]..Housingdata


Alter  table [portflio project]..Housingdata
add Propertysplitaddress Nvarchar(225)

update [portflio project]..Housingdata
set  Propertysplitaddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

Alter  table [portflio project]..Housingdata
add Propertysplitcity Nvarchar(225)

update [portflio project]..Housingdata
set  Propertysplitcity  = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, Len(PropertyAddress)) 


select *
from [portflio project]..Housingdata

--another way

select OwnerAddress
from [portflio project]..Housingdata

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3) 
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from [portflio project]..Housingdata


Alter  table [portflio project]..Housingdata
add ownersplitaddress Nvarchar(225)

update [portflio project]..Housingdata
set  ownersplitaddress =PARSENAME(REPLACE(OwnerAddress,',','.'),3) 

Alter  table [portflio project]..Housingdata
add ownersplitcity Nvarchar(225)

update [portflio project]..Housingdata
set  ownersplitcity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter  table [portflio project]..Housingdata
add ownersplitstate Nvarchar(225)

update [portflio project]..Housingdata
set  ownersplitstate = PARSENAME(REPLACE(OwnerAddress,',','.'),1) 


select *
from [portflio project]..Housingdata

--change Y and N to yes and no  in  solid as vacant field

select  Distinct(SoldAsVacant), count(SoldAsVacant)
from [portflio project]..Housingdata
group by SoldAsVacant
order by 2

select SoldAsVacant
,case when SoldAsVacant = 'Y' then 'yes'
      when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  end
from [portflio project]..Housingdata


update [portflio project]..Housingdata
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'yes'
      when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  end


--remove duplicates**

with rownumCTE AS(
select *,
ROW_NUMBER() over (
partition by parcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 legalReference
			 Order by 
			 UniqueID)
			 row_num

from [portflio project]..Housingdata
--order by ParcelID
)
----select * 
--delete
--from rownumCTE
--where row_num >1
----order by PropertyAddress

select * 
from rownumCTE
where row_num >1
order by PropertyAddress

select *
from [portflio project]..Housingdata

alter table[portflio project]..Housingdata
drop column TaxDistrict,OwnerAddress,PropertyAddress, Saledate

