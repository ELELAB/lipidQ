---
title: "Global Options"
author: "André Vidas Olsen"
date: "2018-04-15"
output: html_document
vignette: >
  %\VignetteIndexEntry{Vignette Title}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



### Introduction
The global options operation tab in the LipidQ GUI makes it possile to create
both databases and user specified column names templates, when the user needs to
have a new version. There can be several reasons why the user wishes to do so.
Here are the two most common ones:

1. If the file has been corrupted, e.g. by typing in errors in the templates,
which makes them unusuable, the user can re-create a template and start over, if
the source of the corruption can not be found by manual inspection.

2. If the user has more than one project with different settings, the user can
create a template for each project. It is recommended to save the files at
different locations so that the template file is not overwritten. The best
practice is to have a folder for each project. 

### Create Database templates
In order to create/reset a user specified column names template file, the user
simply needs to do the following four steps:

1. Specify which database type to create (endogene database or ISTD database)

2. Import the user specified column names file for the project, so that the new
database will have these column names.

3. Specify the path to where the template file should be saved

4. Press 'Create column template file'


### Create column names template file
In order to create/reset a user specified column names template file, the user
simply needs to do the following three steps:

####1. Specify the number of MS2 columns
In order to specify the number of MS2 columns, the user needs to consider only
the different MS2 names and not MS2 column names that belongs to a specific MS2
name. For instance, for the following columns:

"MASSFRAG1", "FRAG1.mE504_POS_01.raw", "FRAG1.mE504_POS_02.raw"

"MASSFRAG2", "FRAG2.mE504_POS_01.raw", "FRAG2.mE504_POS_02.raw"

"MASSFA1", "FA1.mE504_POS_01.raw", "FA1.mE504_POS_02.raw"

"MASSFA2", "FA2.mE504_POS_01.raw", "FA2.mE504_POS_02.raw"

, the number of MS2 columns is 4, since columns such as MASS**FRAG1**,
**FRAG1**.mE504_POS_01.raw, and **FRAG1**.mE504_POS_02.raw all belongs to
**FRAG1**, columns such as MASS**FRAG2**, **FRAG2**.mE504_POS_01.raw, and
**FRAG2**.mE504_POS_02.raw all belongs to **FRAG2** and so on. The maximum
numbers of MS2 columns defined in this way can not exceed 20. 

####2. Specify the path to where the template file should be saved
next, the folder where the output files should be saved to has to be defined in
the "Paste the filepath for the column template file to be saved" field. Here
we'll write the filepath to where we wish to save the files. The following
describes how to obtain the full path:

From Mac OS X El Capitan 2015 onwards (As of February 2018): Go to the folder of
interest, right click on the folder, press the alt button + click on 'Copy
"folder-name" as Pathname'. Go back to LipidQ and paste the folder path
(&#8984; Command button + V) into the output folder field.

Windows: Go to the folder of interest, right click on the folder, go to
properties, find Location and copy the path there (Ctrl + C). Go back to
LipidQ and paste the full path (Ctrl + V) into the output folder field.
Remember to change every "\\" in the path to "/". 

####3. Press 'Create column template file'
Finally the user specified column template names file is created by clicking on
the 'Create column template file' button.


