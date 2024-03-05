/*


Cleaning Data in SQL Queries 

*/
Select *
From Housing.dbo.Sheet1$


----------------------------------------------------------------
--Standardize Date Format
Alter table Housing.dbo.Sheet1$
Add SaleDateconv Date;

Update Housing.dbo.Sheet1$
SET SaleDateconv = Convert(Date, SaleDate)

Select SaleDateconv , Convert(Date,SaleDate) as Date
From Housing.dbo.Sheet1$

-----------------------------------------------------------------

-- Populate Property Address data

Select *
From Housing.dbo.Sheet1$
Where PropertyAddress is null

-- Self joining it, using parcelid 

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) as Populated
From Housing.dbo.Sheet1$ a
Join Housing.dbo.Sheet1$ b
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

-- Now popuulating the column of Null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
From Housing.dbo.Sheet1$ a
Join Housing.dbo.Sheet1$ b
on a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]

-- Selecting PropertyAddress Where Value is NULL
Select *
From Housing.dbo.Sheet1$
Where PropertyAddress = NULL
-- We get Empty columns Since the Null Values Have been fixed

-------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)
Select 
Substring(PropertyAddress, 1, Charindex(',', PropertyAddress)-1) as Address,
Substring(PropertyAddress, Charindex(',', PropertyAddress)+1, len(PropertyAddress)) as City
From Housing.dbo.Sheet1$


Alter Table Housing.dbo.Sheet1$
Add PropertyAdd Nvarchar(255)

Update Housing.dbo.Sheet1$
Set PropertyAdd = Substring(PropertyAddress, 1, Charindex(',', PropertyAddress)-1) 

Alter table Housing.dbo.Sheet1$
Add City Nvarchar(255)

Update Housing.dbo.Sheet1$
Set City = Substring(PropertyAddress, Charindex(',', PropertyAddress)+1, len(PropertyAddress))

Select *
From Housing.dbo.Sheet1$

-- Breaking down owner address into Address city State

Alter table Housing.dbo.Sheet1$
Add OwnerState Nvarchar(255)
Update Housing.dbo.Sheet1$
Set OwnerState = ParseName(Replace(OwnerAddress, ',' , '.'),1)

Alter table Housing.dbo.Sheet1$
Add OwnerCity Nvarchar(255)
Update Housing.dbo.Sheet1$
Set OwnerCity = ParseName(Replace(OwnerAddress, ',' , '.'),2)


Alter table Housing.dbo.Sheet1$
Add Ownaddress Nvarchar(255)
Update Housing.dbo.Sheet1$
Set Ownaddress = ParseName(Replace(OwnerAddress, ',' , '.'),3)


Select *
From Housing.dbo.Sheet1$

---------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold asVacant" Field

Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End
From Housing.dbo.Sheet1$

Update Housing.dbo.Sheet1$
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End
---------------------------------------------------------------------------

-- Remove duplicate

With RowNumCTE AS(
Select*,
ROW_NUMBER() Over(
Partition by ParcelID, 
PropertyAddress, 
SalePrice, 
SaleDate,
LegalReference
Order By UniqueID
)row_num
From Housing.dbo.Sheet1$
)

Delete
From RowNumCTE
Where row_num > 1


-- To confirm


With RowNumCTE AS(
Select*,
ROW_NUMBER() Over(
Partition by ParcelID, 
PropertyAddress, 
SalePrice, 
SaleDate,
LegalReference
Order By UniqueID
)row_num
From Housing.dbo.Sheet1$
)

Select*
From RowNumCTE
Where row_num > 1
Order by PropertyAddress
------------------------------------------------------------------------------------------------------
-- Delete Unused Columns
Select *
From Housing.dbo.Sheet1$

Alter Table Housing.dbo.Sheet1$
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table Housing.dbo.Sheet1$
Drop Column SaleDate



 
























