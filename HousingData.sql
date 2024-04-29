--Data Cleaning project in SQL

Select *
From MyPortfolio..HousingData


--Standardizing Date format
Select SaleDateConverted, convert(Date, SaleDate)
From MyPortfolio..HousingData

update HousingData
set SaleDate = convert(Date, SaleDate)


ALTER TABLE HousingData
Add SaleDateConverted Date


update HousingData
set SaleDateConverted = convert(Date, SaleDate)


--Populate property address

Select *
From MyPortfolio..HousingData
--Where PropertyAddress is null
Order by ParcelID

Select x.ParcelID, x.PropertyAddress, y.ParcelID, y.PropertyAddress, ISNULL(x.PropertyAddress, y.PropertyAddress)
From MyPortfolio..HousingData x
Join MyPortfolio..HousingData y
  On x.ParcelID  = y.ParcelID
  And x.[UniqueID ] <> y.[UniqueID ]
where x.PropertyAddress is null

Update x
Set PropertyAddress = ISNULL(x.PropertyAddress, y.PropertyAddress)
From MyPortfolio..HousingData x
Join MyPortfolio..HousingData y
  On x.ParcelID  = y.ParcelID
  And x.[UniqueID ] <> y.[UniqueID ]

--Breaking out address into individual columns (Address, City, State)

Select PropertyAddress
From MyPortfolio..HousingData
--Where PropertyAddress is null
--Order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address,
CHARINDEX('.', PropertyAddress)
From MyPortfolio..HousingData



Select OwnerAddress
From MyPortfolio..HousingData
--Where OwnerAddress is not null

select
PARSENAME(OwnerAddress, 1)
From MyPortfolio..HousingData


select distinct(SoldAsVacant), Count(SoldAsVacant)
From MyPortfolio..HousingData
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End
From MyPortfolio..HousingData

Update  HousingData
SET SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	 End
From MyPortfolio..HousingData


--Removing Duplicates

WITH CTE_RowNum As(
Select *, 
   ROW_NUMBER() over (
   Partition by ParcelID,
                PropertyAddress,
				SalePrice,
				saleDate,
				LegalReference
				ORDER BY 
				  UniqueID
				  )row_num

From MyPortfolio..HousingData
--Order by ParcelID
)
select *
From CTE_RowNum
Where row_num > 1
order by PropertyAddress



--Delete Unused Columns

select*
From MyPortfolio..HousingData

-- Removing column "TaxDistrict"

ALTER TABLE MyPortfolio..HousingData
DROP COLUMN TaxDistrict