# Analysis Portfolio

These four projects show different aspects of my 
ability to clean, explore, manipulate, and visualize
data with SQL, Python, and Python libraries.

## Covid Data Exploration

This project explores and queries global Covid-19
death and vaccination data in SQL.

The project makes use of joins, CTE's, 
window functions, aggregate functions, 
view creation, and data type conversions in PostgreSQL.

Due to the large file size of the csv files
used in the project exceeding github's 
25MB file upload size, a link to the website 
where the data was downloaded from is in the
project subfolder's README file.

## Data Cleaning in SQL

This project showcases data cleaning in SQL.

The data file is a csv of housing data from Nashville,TN 
in which PostgreSQL is used to identify and remove 
duplicates of data, various columns containing data to 
be broken down and separated, creation of new columns with 
sliced data, standardizing columns values, and
deleting unused columns.

## Pandas Python Data Exploration

This project primarily utilizes the pandas python library to explore and 
manipulate public bike usage data in London over a period from January 4, 2015
to January 3, 2017.

Pandas is used to read in a csv file, create a dataframe with the data from the file,
explore the data, creates dictionaries and renames columns with the dictionaries' values,
changing data types, mapping dictionary values to replace data in specific columns,
and writing the final dataframe to a new csv file to be used for later visualizations.

## Python Movie Data Exploration and Visualization

This project utilizes the pandas, seaborn, numpy, and matplotlib python libraries
to explore and visualize movie data.

The project reads in a csv file with movie information such as title, year released,
director, film budget, and gross revenue on 7668 movies. 
After some data cleaning, the data is visualized in scatter plots,
heatmaps, and a correlation matrix to analyze whether there are any
meaningful correlations between the columns of data. 
