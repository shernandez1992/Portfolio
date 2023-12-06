/* 

Cleaning Data in PostgreSQL Queries

*/


SELECT * 
FROM housing;

--Populate Property Address data

SELECT *
FROM housing
--WHERE propertyaddress IS null
ORDER BY parcelid

SELECT 
	a.parcelid,
	a.propertyaddress,
	b.parcelid,
	b.propertyaddress,
	COALESCE(a.propertyaddress, b.propertyaddress)
FROM housing AS a
JOIN housing AS b
ON a.parcelid = b.parcelid
AND a.uniqueid <> b.uniqueid
WHERE a.propertyaddress IS null

UPDATE housing
SET propertyaddress = COALESCE(a.propertyaddress, b.propertyaddress)
FROM housing AS a
JOIN housing AS b
ON a.parcelid = b.parcelid
AND a.uniqueid <> b.uniqueid
WHERE a.propertyaddress IS null

UPDATE housing a 
SET propertyaddress = b.propertyaddress
FROM housing b
WHERE a.uniqueid <> b.uniqueid
AND a.propertyaddress IS null

--Breaking out Address into Individual Columns (address, city, state)

SELECT propertyaddress
FROM housing

SELECT 
SUBSTRING(propertyaddress, 1, POSITION(',' in propertyaddress) -1) AS address 
FROM housing

SELECT 
SUBSTRING(propertyaddress, 1, POSITION(',' in propertyaddress) -1) AS address, 
SUBSTRING(propertyaddress, POSITION(',' in propertyaddress)+1, LENGTH(propertyaddress)) AS city 
FROM housing

ALTER TABLE housing
ADD PropertySplitAddress varchar;

ALTER TABLE housing
ADD PropertySplitCity varchar;

SELECT * FROM housing

UPDATE housing
SET PropertySplitAddress = SUBSTRING(propertyaddress, 1, POSITION(',' in propertyaddress) -1);

UPDATE housing
SET PropertySplitCity = SUBSTRING(propertyaddress, POSITION(',' in propertyaddress)+1, LENGTH(propertyaddress))

SELECT
	propertyaddress,
	propertysplitaddress,
	propertysplitcity
FROM housing

--Owner Address

SELECT
SPLIT_PART(owneraddress, ',', 1), 
SPLIT_PART(owneraddress, ',', 2),
SPLIT_PART(owneraddress, ',', 3)
FROM housing

ALTER TABLE housing
	ADD ownersplitaddress varchar,
	ADD ownersplitcity varchar,
	ADD ownersplitstate varchar;
	
SELECT * FROM housing;

UPDATE housing
SET ownersplitaddress = SPLIT_PART(owneraddress, ',', 1),
 	ownersplitcity = SPLIT_PART(owneraddress, ',', 2),
	ownersplitstate = SPLIT_PART(owneraddress, ',', 3);
	
SELECT
	owneraddress,
	ownersplitaddress,
	ownersplitcity,
	ownersplitstate
FROM housing

--CHANGE Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(soldasvacant)
FROM housing

SELECT 
	DISTINCT(soldasvacant),
	COUNT(soldasvacant)
FROM housing
GROUP BY DISTINCT(soldasvacant)
ORDER BY 2 DESC

SELECT
	soldasvacant,
	CASE 
		WHEN soldasvacant = 'Y' THEN 'Yes'
		WHEN soldasvacant = 'N' THEN 'No'
		ELSE soldasvacant
		END
FROM housing
ORDER BY 1

UPDATE housing
	SET soldasvacant = CASE 
		WHEN soldasvacant = 'Y' THEN 'Yes'
		WHEN soldasvacant = 'N' THEN 'No'
		ELSE soldasvacant
		END
		
SELECT soldasvacant
FROM housing
order by 1 

--Remove Duplicates

SELECT *
FROM housing

SELECT 
	*,
	ROW_NUMBER() OVER (
		PARTITION BY parcelid,
					 propertyaddress,
					 saleprice,
					 saledate,
					 legalreference
					 ORDER BY uniqueid) AS row_num
FROM housing

WITH rownumCTE AS(
SELECT 
	*,
	ROW_NUMBER() OVER (
		PARTITION BY parcelid,
					 propertyaddress,
					 saleprice,
					 saledate,
					 legalreference
					 ORDER BY uniqueid) AS row_num
FROM housing
	)

DELETE
FROM rownumCTE
WHERE row_num > 1;



--DELETE unused columns

select * from housing

ALTER TABLE housing
DROP COLUMN 
owneraddress

ALTER TABLE housing
DROP COLUMN 
taxdistrict

ALTER TABLE housing
DROP COLUMN 
propertyaddress