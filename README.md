# Data Cleaning in SQL

Overview

This project demonstrates data cleaning techniques using SQL queries. The dataset used is related to housing records, and various transformations are applied to improve data quality and consistency.

Features

Standardizing Date Format: Converts date fields into a standard format.

Handling Missing Data: Populates missing PropertyAddress values using self-joins.

Splitting Address Fields: Separates PropertyAddress and OwnerAddress into individual components (Address, City, and State).

Standardizing Boolean Fields: Converts Y and N values in the SoldAsVacant column to Yes and No.

Removing Duplicates: Uses ROW_NUMBER() to identify and delete duplicate records.

Dropping Unnecessary Columns: Eliminates unused columns to optimize data storage.

