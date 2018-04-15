---
title: "Tutorial: Global Options"
author: "André Vidas Olsen"
date: "2018-04-15"
output: html_document
vignette: >
  %\VignetteIndexEntry{Vignette Title}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---




#Introduction
This tutorial will cover how to use the Global Options in order to create new
user specified column names template files as well as new endogene and ISTD
database templates. Once these templates are created, they can be used to make
the required databases and user specified column names for a given
quantification procedure in the LipidQ GUI. The tutorial is divided into two
parts:

1. Creating a user specified column names file

2. Creating an endogen & ISTD database file


#Data
The data for this tutorial will consist of the following file:

userSpecifiedColnames.csv

, which is located in the following folder:


```
#> [1] "/Library/Frameworks/R.framework/Versions/3.4/Resources/library/lipidQ/extdata/LipidQ_DataBase"
```

#Creating a user specified column names file

###Step 1: open LipidQ
Start by open up LipidQ. This can be done by doing these 3 steps:

1. Open Rstudio

2. Write "library(lipidQ)"

3. Write "runLipidQ()"

If the web browser encounters problems doing any of the steps in the tutorial,
LipidQ can also be open by going to:

```
#> [1] "/Library/Frameworks/R.framework/Versions/3.4/Resources/library/lipidQ/app/"
```
, open either ui.R or server.R and hit the Run button at the right top corner of
Rstudio. 

After this go to the Global Options procedure tab and look at the "Create new
user specified column names template" at the top of the field.


###Step 2: set number of MS2 columns in the data
In this field we have to specify how many MS2 columns our input data sets
contain (see Global Options vignette for more info about how to properly set the
number MS2 columns). Since we have six disctint MS2 columns for our data
example, we'll set the number to 6.



###Step 3: paste the filepath for the column template file to be saved
Lastly, the folder where the user specified columns template file should be
saved to has to be defined. Write here the filepath to where you wish to save
the files. The following describes how to obtain the full path:

From Mac OS X El Capitan 2015 onwards (As of February 2018): Go to the folder of
interest, right click on the folder, press the alt button + click on 'Copy
"folder-name" as Pathname'. Go back to LipidQ and paste the folder path
(&#8984; Command button + V) into the output folder field.

Windows: Go to the folder of interest, right click on the folder, go to
properties, find Location and copy the path there (Ctrl + C). Go back to
LipidQ and paste the full path (Ctrl + V) into the output folder field.
Remember to change every "\\" in the path to "/". 

After defining the output folder, click on the "Create column template file" to
create the user specified columns template file. The file will by default be
called userSpecifiedColnames.csv. Open this file to edit it. The file will
consist of the following:


|PPM            |CLASS          |C_CHAIN        |DOUBLE_BOND    |SUM_COMPOSITION |SPECIE_COMPOSITION |MASS_TO_CHARGE |
|:--------------|:--------------|:--------------|:--------------|:---------------|:------------------|:--------------|
|TYPE_NAME_HERE |TYPE_NAME_HERE |TYPE_NAME_HERE |TYPE_NAME_HERE |TYPE_NAME_HERE  |TYPE_NAME_HERE     |TYPE_NAME_HERE |



|OH_GROUP       |MS1x           |MS2ax          |MS2bx          |MS2cx          |MS2dx          |MS2ex          |MS2fx          |
|:--------------|:--------------|:--------------|:--------------|:--------------|:--------------|:--------------|:--------------|
|TYPE_NAME_HERE |TYPE_NAME_HERE |TYPE_NAME_HERE |TYPE_NAME_HERE |TYPE_NAME_HERE |TYPE_NAME_HERE |TYPE_NAME_HERE |TYPE_NAME_HERE |

###Step 4: edit the template file to make it usable within a project  
After creating the user specifed column names template file, we now specify our
own column names that macthes the default column names in order to make it
usable within our project (see the Global Options vignette for a complete
explanation of each of the default column names). After doing this, we'll end up
with the following table:




|PPM   |CLASS |C_CHAIN |DOUBLE_BOND |SUM_COMPOSITION |SPECIE_COMPOSITION |MASS_TO_CHARGE |
|:-----|:-----|:-------|:-----------|:---------------|:------------------|:--------------|
|ERROR |CLASS |LENGTH  |DB          |NAME            |SPECIE             |MASS           |



|OH_GROUP |MS1x |MS2ax |MS2bx |MS2cx     |MS2dx     |MS2ex |MS2fx     |
|:--------|:----|:-----|:-----|:---------|:---------|:-----|:---------|
|OH       |PREC |FRAG1 |FRAG2 |FA1INTENS |FA2INTENS |NLS   |FAOINTENS |

This file can now be used within our project by loading it into LipidQ GUI in
the quantification procedure (see the quantification vignette and tutorial for
detailed info of how to process quantification of lipidomics data) 


#Creating an endogene & ISTD database template file
Now that we have a user specified column names file, we can use this file to
create our two databases needed for the quantification procedure. This is done
in the field called "Create new database file" in the lowest part of the Global
Options field.

###Step 1: choose database type
In this step we choose the datatype we wish to create. Since we want both, we
will mark both the endogene and the ISTD database checkbox. 

###Step 2: choose user specified column
Next, we need to load the user specified column names file we just created in
part 1 of this tutorial. This is done by clicking on the "Browse..." button
below the "Choose list of colnames (.csv-file)" text and choosing the user
specified column names file.

###Step 3: output folder
Lastly, the folder where the databases should be saved to has to be defined.
For convenience, we will save this file in the same folder as the userSpecified
column names file. The following describes how to obtain the full path:

From Mac OS X El Capitan 2015 onwards (As of February 2018): Go to the folder of
interest, right click on the folder, press the alt button + click on 'Copy
"folder-name" as Pathname'. Go back to LipidQ and paste the folder path
(&#8984; Command button + V) into the output folder field.

Windows: Go to the folder of interest, right click on the folder, go to
properties, find Location and copy the path there (Ctrl + C). Go back to
LipidQ and paste the full path (Ctrl + V) into the output folder field.
Remember to change every "\\" in the path to "/". 

After inserting the full path, click on the "Create Database" button.

###Step 4: edit the database template files to make it usable within a project 
Now that we have the two datbase templates, they need to be edited so that they
fit the project (see the Input Data vignette for a complete explanation of each
of the column names in each of the databases). (MESUT)
