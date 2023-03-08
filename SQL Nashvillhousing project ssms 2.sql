/*
Cleaning Data in SQL Queries
*/

select * 
from bootcamp..[nashvillhousing]

----------------------------------
-- Standardize Date Format

select SaleDate
from bootcamp..[nashvillhousing]

update [nashvillhousing]
set SaleDate = CONVERT(Date,SaleDate)

Alter table nashvillhousing
add saledateconverted Date;


update [nashvillhousing]
set saledateconverted = CONVERT(Date,SaleDate)

-- Populate Property Address data

select PropertyAddress 
from bootcamp..[nashvillhousing]
where PropertyAddress Is null


select *
from bootcamp..[nashvillhousing]
--where PropertyAddress Is null
order by parcelID


select a.ParcelID,a.PropertyAddress,b.ParcelId,b.PropertyAddress
from bootcamp..[nashvillhousing] a
join bootcamp..[nashvillhousing] b
on a.ParcelID=b.ParcelID and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null
order by a.ParcelID

update a
set PropertyAddress = Isnull(a.propertyAddress,b.PropertyAddress)
from bootcamp..[nashvillhousing] a
join bootcamp..[nashvillhousing] b
on a.ParcelID=b.ParcelID and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress 
from [nashvillhousing]

select
substring(PropertyAddress , 1 ,charindex(',',PropertyAddress) -1) as Address,
substring(PropertyAddress ,charindex(',',PropertyAddress) +1,len(propertyaddress))as Address
from nashvillhousing


Alter table nashvillhousing
add splitpropertaddressbyaddress nvarchar(255);


update [nashvillhousing]
set splitpropertaddressbyaddress =substring(PropertyAddress , 1 ,charindex(',',PropertyAddress) -1) 


Alter table nashvillhousing
add splitpropertaddressbycity nvarchar(255);


update [nashvillhousing]
set splitpropertaddressbycity = substring(PropertyAddress ,charindex(',',PropertyAddress) +1,len(propertyaddress))

--Breaking the owner ddress col into address ,city ,state columns in otherway using parsename,replace



select owneraddress
from [nashvillhousing]

select 
parsename (replace(owneraddress , ', ' , '.') ,3),
parsename (replace(owneraddress , ', ' , '.') ,2),
parsename (replace(owneraddress , ', ' , '.') ,1)
from [nashvillhousing]
--------------


Alter table nashvillhousing
add splitowneraddressbyaddress nvarchar(255);

update [nashvillhousing]
set splitowneraddressbyaddress =parsename (replace(owneraddress , ', ' , '.') ,3)

Alter table nashvillhousing
add splitowneraddressbycity nvarchar(255);

update [nashvillhousing]
set splitowneraddressbycity =parsename (replace(owneraddress , ', ' , '.') ,2)


Alter table nashvillhousing
add splitowneraddressbystate nvarchar(255);

update [nashvillhousing]
set splitowneraddressbystate =parsename (replace(owneraddress , ', ' , '.') ,1)



select *
from [nashvillhousing]



/*
Cleaning Data in SQL Queries
*/


Select *
From  bootcamp..NashvillHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From  bootcamp..NashvillHousing

Update NashvillHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvillHousing
Add SaleDateConverted Date;

Update NashvillHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From bootcamp.NashvillHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From  bootcamp.NashvillHousing


ALTER TABLE NashvillHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvillHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvillHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From bootcamp..nashvillhousing




Select OwnerAddress
From bootcamp..NashvillHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From bootcamp..NashvillHousing


ALTER TABLE NashvillHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvillHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvillHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvillHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvillHousing
Add OwnerSplitState Nvarchar(255);

Update NashvillHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)






--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field
select distinct(soldasvacant),count(soldasvacant)
from bootcamp..NashvillHousing
group by soldasvacant

select   soldasvacant,
  case when soldasvacant = 'y' then  'yes'
       when soldasvacant = 'N' then  'No'
	   else soldasvacant
	   end
from bootcamp..NashvillHousing

update bootcamp..NashvillHousing
set soldasvacant=  case when soldasvacant = 'y' then  'yes'
       when soldasvacant = 'N' then  'No'
	   else soldasvacant
	   end



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from  bootcamp..nashvillhousing

)


select *  from
RowNumCTE where row_num>1

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns
alter table bootcamp..nashvillhousing
drop column owneraddress , propertyaddress , saledate , TaxDistrict


select * 
from bootcamp..[nashvillhousing]
