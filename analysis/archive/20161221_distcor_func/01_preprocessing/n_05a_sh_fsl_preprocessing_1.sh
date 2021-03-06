#!/bin/sh


################################################################################
# The purpose of this script is to preprocess the data of the Parametric       #
# Contrast Experiment. The following steps are performed in this script:       #
#   - Copy files into SPM directory tree                                       #
#   - Remove input files                                                       #
# Motion correction and registrations are performed with SPM afterwards.       #
################################################################################


#-------------------------------------------------------------------------------
# Define session IDs & paths:

# Parent directory:
strPathParent="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/"

# Functional runs (input):
arySessionIDs=(func_01 \
               func_02 \
               func_03 \
               func_04 \
               func_05 \
               func_06 \
               func_07 \
               func_08 \
               func_09 \
               func_10)

# Input directory:
strPathInput="${strPathParent}func/"

# SPM directory:
strPathSpmParent="${strPathParent}spm_regWithinRun/"
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Change filetype and save resulting nii file to SPM directory:

# SPM requires *.nii files as input, not *.nii.gz.

echo "------Change filetype and save resulting nii file to SPM directory:------"
date

for index01 in ${arySessionIDs[@]}
do
	strTmp01="${strPathInput}${index01}"
	strTmp02="${strPathSpmParent}${index01}/${index01}"

	echo "---fslchfiletype on: ${strTmp01}"
	echo "-------------output: ${strTmp02}"
	echo "---fslchfiletype NIFTI ${strTmp01} ${strTmp02}"
	fslchfiletype NIFTI ${strTmp01} ${strTmp02}

	# Remove func_roi:
	echo "---rm ${strTmp01}.nii.gz"
	rm "${strTmp01}.nii.gz"
done

date
echo "done"
#-------------------------------------------------------------------------------


