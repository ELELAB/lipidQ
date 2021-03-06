---
title: "Parameters"
author: "André Vidas Olsen"
date: "2018-04-15"
output: html_document
vignette: >
  %\VignetteIndexEntry{Vignette Title}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---




# Introduction
This vigentte will focus on describing the different parameters in regards to
the quantification procedure in LidpiqQuan.



### Number of replicates
LipidQ contains a section for specifying the number of replicates in the
input intensity data. If the input text is set to 1, this means that there is
only the original sample extract, whereas setting the number to 2 means 2
replicates, 3 means 3 replicates etc. Also, in this field, the user can specify
whether the input intensity data contains replicates in the blank extracts or
not. This is done by using the checkbox marked as 'Blank contains replicates'.




### Number of instances threshold & Threshold of instance
Below the field of specifying the number of replicates, the user can also
specify two parameters for filtering out unrealiable measurements. This is done
by using the 'Threshold of instance' and 'Number of instances threshold' fields
in LipidQ. In the 'Threshold of instance' the user can specify what level of
intensity will be considered as 'real signal'. In the 'Number of instances
threshold' the user can specify how many of the replicates in a given sample
that should have a value above the 'Threshold of instance' before the sample in
question will be considered to have a 'real' signal. 








### Multiply MS1 columns by a factor (for LipidX users)

In cases where a low mass range and high mass range has overlapping parts, a
multiplication factor will be needed for LipidX users. The reason is that LipidX
takes the average of the overlapping and non-overlapping part of the low and
high mass range, resulting in a division factor of 2 for some lipids, since they
will not be in the overlapping part of those two overlaps. If this is the case,
then the "Multiply MS1 columns by a factor (for LipidX users)" checkbox should
be marked. A file containing every classes which intensity values needs to be
multiplied should be included by using the "Browse..." button below "Choose the
list of classes to be multiplied (.csv-file)" and selecting the file. Finally a
multiplication factor should be selected in the "Set multiplication factor"
field, which specify the number to multiply each classes with.





### Spike ISTD



### Filter types


#### LOQ
Limit of quantification (LOQ) is a threshold setting which specifies whether the
quantification of a given lipid/species is high enough to be considered as
measurable (see parameters vignette).





#### Threshold for rounding down to zero for mol% species:

















