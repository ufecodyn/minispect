# -*- coding: utf-8 -*-
"""
Created on Mon Jan 25 14:33:44 2021

Updated on Fri June 4 19:18:52 2021 by Varun Puri

@author: aditya01
"""

import glob, os
import pandas as pd

def read_svc(baseDir='./', csvName='Spectra_ALL.csv'):
    if (baseDir[-1] != '/'):
        baseDir += '/'
    print('Searching',baseDir)

        
    outName=baseDir+csvName

    ###############################################################################

    allSIG=glob.glob(baseDir+'*.sig')
    print(len(allSIG),'spectra found')

    ctr=0
    dfList=[]
    for spec in allSIG:
        fSpec=open(spec).readlines()
        print(os.path.basename(spec),len(fSpec))
        tDate=fSpec[17].split()[1]
        tTime=fSpec[17].split()[2]
        tAMPM=fSpec[17].split()[3].replace(',','').strip()
        WVLarr=[]
        REFarr=[]
        for l in range(25,len(fSpec)):
            lArr=[float(x) for x in fSpec[l].split()]
            WVLarr.append(lArr[ 0])
            REFarr.append(lArr[-1])
        WVLarr=['WVL_'+str(x) for x in WVLarr]
        outDF=pd.DataFrame(columns=['SR','FileName','Date','Time','AMPM']+WVLarr)
        outDF.loc[0,'SR']=ctr
        outDF.loc[0,'FileName']=os.path.basename(spec)
        outDF.loc[0,'Date']=tDate
        outDF.loc[0,'Time']=tTime
        outDF.loc[0,'AMPM']=tAMPM
        outDF.loc[0,WVLarr]=REFarr
        dfList.append(outDF)
        ctr+=1

    allDF=pd.concat(dfList)
    allDF.to_csv(outName,index=False)    
