from scipy import ndimage

import scipy as sp
import numpy as np
import pandas as pd


def rawTextScansToDataframe(filename='scans.txt', gaussian=False, sigma=1):
    scanfile = open(filename, 'r')
    pd.DataFrame()
    name=''
    integration=''
    scans = []

    for line in scanfile:
        line=line.strip()
        colon = line.find(':')
        if(line==''):
            continue
        elif(colon != -1):
            name = line[:colon]
            integration = line[colon+1:]
        else:        
            data = [int(x) for x in line.split(' ')]
            if gaussian:
                scan = {'name':name, 'data':sp.ndimage.gaussian_filter1d(data, sigma)}
            else:
                scan = {'name':name, 'data':data}

            scans.append(scan)
    return scans

