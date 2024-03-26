/*

Cleaning Data in SQL Queries

*/


Select *
From 

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From [dbo].[NashvilleHousing]


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From [dbo].[NashvilleHousing]
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [dbo].[NashvilleHousing] a
JOIN [dbo].[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [dbo].[NashvilleHousing] a
JOIN [dbo].[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [dbo].[NashvilleHousing]
--Where PropertyAddress is null
--order by ParcelID


Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) As Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) As Address

From [dbo].[NashvilleHousing]


ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

Select *
From [dbo].[NashvilleHousing]

Select OwnerAddress
From [dbo].[NashvilleHousing]



Select Parsename(replace(OwnerAddress,',','.'),3),
Parsename(replace(OwnerAddress,',','.'),2),
Parsename(replace(OwnerAddress,',','.'),1)

From [dbo].[NashvilleHousing]



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255)

Update NashvilleHousing
SET OwnerSplitAddress = Parsename(replace(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerCityAddress nvarchar(255)

Update NashvilleHousing
SET OwnerCityAddress = Parsename(replace(OwnerAddress,',','.'),2)


ALTER TABLE NashvilleHousing
Add OwnerstateAddress nvarchar(255)

Update NashvilleHousing
SET OwnerstateAddress = Parsename(replace(OwnerAddress,',','.'),1)


select*
From [dbo].[NashvilleHousing]

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM [dbo].[NashvilleHousing]
GROUP BY SoldAsVacant
order by 2

select SoldAsVacant,
case
When SoldAsVacant = 'Y' then 'Yes'
When SoldAsVacant = 'N' then 'NO'
Else SoldAsVacant
  End
From [dbo].[NashvilleHousing]


update NashvilleHousing
set SoldAsVacant = case
When SoldAsVacant = 'Y' then 'Yes'
When SoldAsVacant = 'N' then 'NO'
Else SoldAsVacant
  End


  select*
From [dbo].[NashvilleHousing]


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

From [dbo].[NashvilleHousing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [dbo].[NashvilleHousing]




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From [dbo].[NashvilleHousing]

alter table [dbo].[NashvilleHousing]
drop column PropertyAddress, Owneraddress, TaxDistrict, SaleDate

alter table [dbo].[NashvilleHousing]
drop column  SaleDate