--Convert datetime to date

ALTER TABLE PortfolioProject..NashvilleHousing
ADD SaleDateConverted Date;

UPDATE PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

--Where PropertyAddress is null

--SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
--FROM PortfolioProject..NashvilleHousing a
--JOIN PortfolioProject..NashvilleHousing b
--	ON a.ParcelID = b.ParcelID
--	AND a.[UniqueID ] <> b.[UniqueID ]
--WHERE a.PropertyAddress IS NULL

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL 

--Break Address, City, and State

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfolioProject..NashvilleHousing
WHERE OwnerAddress IS NOT NULL


ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitState Nvarchar(255);


UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


SELECT *
FROM PortfolioProject..NashvilleHousing

SELECT 
PARSENAME(REPLACE(PropertyAddress,',','.'),2)
,PARSENAME(REPLACE(PropertyAddress,',','.'),1)
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertyStreetAddress Nvarchar(255); 

UPDATE PortfolioProject..NashvilleHousing
SET PropertyStreetAddress = PARSENAME(REPLACE(PropertyAddress,',','.'),2)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertyCityAddress Nvarchar(255);

UPDATE PortfolioProject..NashvilleHousing
SET PropertyCityAddress = PARSENAME(REPLACE(PropertyAddress,',','.'),1)

SELECT * 
FROM PortfolioProject..NashvilleHousing


--Change string 'Y' to 'Yes' and 'N' to 'No'

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
--ORDER BY 2

SELECT SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 WHen SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProject..NashvilleHousing

UPDATE PortfolioProject..NashvilleHousing
SET SoldAsVacant = 
	CASE 
	 When SoldAsVacant = 'Y' THEN 'Yes'
	 WHen SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

--Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num
					
FROM PortfolioProject..NashvilleHousing
)

SELECT * 
FROM RowNumCTE
WHERE row_num > 1 
				 
SELECT *
FROM PortfolioProject..NashvilleHousing



