#!/bin/sh


###############################################################################
# The purpose of this script is to copy the 'original' nii images, after      #
# DICOM to nii conversion, and reorient them to standard orientation. The     #
# contents of this script have to be adjusted individually for each session,  #
# as the original file names may differ from session to session.              #
###############################################################################


#------------------------------------------------------------------------------
# *** Define paths:

# Session ID:
strSess="20180111"

# Parent directory:
strPthPrnt="/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/${strSess}/nii_distcor"

# 'Raw' data directory, containing nii images after DICOM->nii conversion:
strRaw="${strPthPrnt}/raw_data/"

# Destination directory for functional data:
strFunc="${strPthPrnt}/func/"

# Destination directory for same-phase-polarity SE images:
strSe="${strPthPrnt}/func_se/"

# Destination directory for opposite-phase-polarity SE images:
strSeOp="${strPthPrnt}/func_se_op/"

# Destination directory for mp2rage images:
strAnat="${strPthPrnt}/mp2rage/01_orig/"
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy functional data

fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func01_FOV_RL_SERIES_011_c32 ${strFunc}func_01
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func02_FOV_RL_SERIES_013_c32 ${strFunc}func_02
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func03_FOV_RL_SERIES_015_c32 ${strFunc}func_03
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func04_FOV_RL_SERIES_017_c32 ${strFunc}func_04
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func05_FOV_RL_SERIES_025_c32 ${strFunc}func_05
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func06_FOV_RL_SERIES_027_c32 ${strFunc}func_06
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func07_FOV_RL_pRF_SERIES_029_c32 ${strFunc}func_07
fslreorient2std ${strRaw}PROTOCOL_BP_ep3d_bold_func08_FOV_RL_long_SERIES_031_c32 ${strFunc}func_08
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy opposite-phase-polarity SE images

fslreorient2std ${strRaw}PROTOCOL_cmrr_mbep2d_se_LR_SERIES_007_c32 ${strSeOp}func_00
fslreorient2std ${strRaw}PROTOCOL_cmrr_mbep2d_se_RL_SERIES_008_c32 ${strSe}func_00
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# *** Copy mp2rage images

# Note: Because the first MP2RAGEs was affected by a motion artefact, a second
# MP2RAGE was acquired for this subject at the end of the session.
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_018_c32 ${strAnat}mp2rage_inv1
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_019_c32 ${strAnat}mp2rage_inv1_phase
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_020_c32 ${strAnat}mp2rage_t1
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_021_c32 ${strAnat}mp2rage_uni
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_022_c32 ${strAnat}mp2rage_pdw
fslreorient2std ${strRaw}PROTOCOL_mp2rage_0.7_iso_p2_SERIES_023_c32 ${strAnat}mp2rage_pdw_phase
#------------------------------------------------------------------------------
