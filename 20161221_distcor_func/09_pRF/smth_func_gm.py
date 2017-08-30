# -*- coding: utf-8 -*-

"""Smoothing of functional data within grey matter mask."""

# Part of py_pRF_motion library
# Copyright (C) 2016  Ingo Marquardt
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.


import numpy as np
import nibabel as nb
from utilities import fncLoadNii
from aniso_smooth import aniso_diff_3D


# *****************************************************************************
# *** Parameters

# Parent path of input data:
strPrnt = '/media/sf_D_DRIVE/MRI_Data_PhD/05_PacMan/20161221/nii_distcor/'

# Path of functional runs to perform smoothing on (parent path left open):
lstFunc = ['{}func_regAcrssRuns_cube_up/func_07_up.nii.gz',
           '{}func_regAcrssRuns_cube_up/func_08_up.nii.gz',
           '{}func_regAcrssRuns_cube_up/func_09_up.nii.gz',
           '{}func_regAcrssRuns_cube_up/func_10_up.nii.gz']

varNumIn = len(lstFunc)

# List of grey matter masks to restrict smoothing (parent path left open):
lstMsk = ['{}mp2rage/04_seg/02_up/20161221_mp2rage_seg_v26.nii.gz'] * varNumIn

# Value of grey matter within mask (smoothing will be restricted to these
# regions):
varMsk = 1

# Suffix for output files (will be saved in same directory as input files):
strSuff = '_aniso_smth.nii.gz'


# *****************************************************************************
# *** Loop through input files

print('-Smoothing of functional data within grey matter mask.')

idxIn = 0

for idxIn in range(varNumIn):

    # *************************************************************************
    # *** Load nii data

    print('--Loading data')

    # Path of current nii file:    
    strNiiTmp = lstFunc[idxIn].format(strPrnt)

    print(('---Loading functional data: ' + strNiiTmp))

    # Load nii:
    aryNii, objHdr, aryAff = fncLoadNii(strNiiTmp)

    # Reduce precision:
    if type(aryNii[0, 0, 0, 0]) == np.float16:
        print('------Functional data is of type np.float16.')
    else:
        print(('------Converting functional data to type np.float16.'))
        aryNii = aryNii.astype(np.float16)

    # Output file name:
    strPthOut = strNiiTmp.split('.')[0] + strSuff

    # Path of GM mask:
    strNiiTmp = lstMsk[idxIn].format(strPrnt)

    print(('---Loading mask: ' + strNiiTmp))

    # Load nii:
    aryNiiMsk, _, _ = fncLoadNii(strNiiTmp)

    # *************************************************************************
    # *** Apply mask

    print('--Applying mask')

    # Convert mask to integer:
    aryNiiMsk = aryNiiMsk.astype(np.int16)

    # Create binary mask for all voxels that are not GM:
    aryNiiMsk = np.not_equal(aryNiiMsk, int(varMsk))

    # In anisotropic smoothing, the mask restricts the smoothing through an
    # intensity gradient between values inside and outside the mask. We could
    # set all values outside the mask to zero; however, if some of the nii
    # data points have low intensities close to zero this may not properly
    # restrict the smoothing operation. Thus, we set the datapoints outside
    # the mask to a much lower value. 
    aryNii[aryNiiMsk, :] = -10000.0

    # *************************************************************************
    # *** Smoothing

    print('--Applying smoothing')

    # Number of volumes (time points):
    varNumVol = aryNii.shape[3]

    for idxVol in range(varNumVol):

        print(('---Volume ' + str(idxVol) + ' of ' + str(varNumVol)))

        # Apply smoothing to current volume:
        aryNii[:, :, :, idxVol] = aniso_diff_3D(aryNii[:, :, :, idxVol],
                                                niter=1,
                                                kappa=50,
                                                gamma=0.1,
                                                step=(1.0, 1.0, 1.0),
                                                option=1,
                                                ploton=False)

    # *************************************************************************
    # *** Save result

    print('--Saving result to disk')

    print(('---Saving: ' + strPthOut))

    # Create nii object for results:
    objNiiOut = nb.Nifti1Image(aryNii,
                               aryAff,
                               header=objHdr
                               )

    # Save nii:
    nb.save(objNiiOut, strPthOut)

print('-Done.')
