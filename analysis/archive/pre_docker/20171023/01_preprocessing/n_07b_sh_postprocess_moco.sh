#!/bin/sh


###############################################################################
# The purpose of this script is to change the file type of the functional     #
# time series that have been motion corrected and registered with SPM back to #
# compressed nii.                                                             #
#                                                                             #
# IMPORTANT: The uncompressed nii files produced by SPM are subsequently      #
#            deleted in order so save disk space.                             #
###############################################################################


#------------------------------------------------------------------------------
# Define session IDs & paths:

strPathParent="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20171023/nii_distcor/"

# Functional runs (input):
arySessionIDs=(func_00)

# Input directory:
strPathInput="${strPathParent}spm_reg/"

# Output directory:
strPathOutput="${strPathParent}func_se_reg/"
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# Change filetype and save results to ".../nii/func_reg/":

echo "-----------Compress SPM output and delete uncompressed files-----------"
date

for index01 in ${arySessionIDs[@]}
do
	echo "-----------------------------------------------------------------"
	echo "---Processing ${index01}"

	strTmp01="${strPathInput}${index01}/r${index01}"
	strTmp02="${strPathOutput}${index01}"
	echo "------fslchfiletype on: ${strTmp01}"
	echo "----------------output: ${strTmp02}"
	echo "------fslchfiletype NIFTI_GZ ${strTmp01} ${strTmp02}"
	fslchfiletype NIFTI_GZ ${strTmp01} ${strTmp02}

	echo "---Removing uncompressed nii files"

	# The time series that motion corretion was performed on:
	strTmp03="${strPathInput}${index01}/${index01}.nii"

	# The time series that has been 'resliced':
	strTmp04="${strPathInput}${index01}/r${index01}.nii"

	echo "------rm ${strTmp03}"
	rm ${strTmp03}

	echo "------rm ${strTmp04}"
	rm ${strTmp04}
done

date
echo "done"
#------------------------------------------------------------------------------
