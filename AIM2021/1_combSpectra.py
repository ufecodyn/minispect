# -*- coding: utf-8 -*-
"""
Created on Wed May 19 00:07:30 2021

@author: aditya01
"""


import pandas as pd
from scipy.interpolate import interp1d
import numpy as np

aFN='D:/_UF/UF_Students/Sierra/Sierra_Pastels/Spectra_ALL.csv'
oFN='D:/_UF/UF_Students/Sierra/Sierra_Pastels/Spectra_Mean.csv'

grpField='COLOR'
refField='REF'
fixJumps=True

allSpec=pd.read_csv(aFN)
allSpec=allSpec.loc[allSpec[refField]==False,]
allSpec.shape

if fixJumps:
    print('...Fixing jumps')
    WVLcols=[x for x in allSpec.columns if x.startswith('WVL')]
    WVLS=np.array([float(x.replace('WVL_','')) for x in WVLcols])
    WVLM=np.zeros(WVLS.shape)+1
    WVLM[(WVLS>960.0)&(WVLS<1100.0)]=0
    WVLM[(WVLS>1870.)&(WVLS<1950.0)]=0
    for i in allSpec.index:
        specArr=np.array(allSpec.loc[i,WVLcols])
        x=WVLS[WVLM==1]
        y=specArr[WVLM==1]
        f=interp1d(x, y,kind='quadratic')
        yPre=f(WVLS)
        specNew=specArr.copy()
        specNew[WVLM==0]=yPre[WVLM==0]
        allSpec.loc[i,WVLcols]=specNew

aveSpec=allSpec.groupby(by=grpField,axis=0,as_index=False).mean()
aveSpec.to_csv(oFN,index=False)
