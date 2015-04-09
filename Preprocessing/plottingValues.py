# -*- coding: utf-8 -*-
"""
Created on Sun Mar 15 11:56:25 2015

@author: Dalton
"""

import pandas as pd
import seaborn as sb
import numpy as np
import matplotlib.pyplot as plt

options = pd.DataFrame.from_csv('../records/options.csv')
responses = pd.DataFrame.from_csv('../records/responses.csv', index_col = 'index')

#%%
sb.pairplot(options[['elicitedRank','valueLBUBSUM','valueLBUB','valueLB','value']], 
#            kind = 'reg'
            )

#%% Heatmaps

# Reduce to only singleton options
responses_Singleton = responses[(responses.opt1item2 == 0) & (responses.opt2item2 == 0)]    
heatMapData_Singleton = pd.pivot_table(responses_Singleton,index='opt2Code', columns='opt1Code', values='chosenOpt')
plt.figure(figsize=(18, 12))
sb.heatmap(heatMapData_Singleton,square=True,mask=heatMapData_Singleton.isnull())

#responses = responses[['opt1Code','opt2Code','chosenOpt']]

heatMapData = pd.pivot_table(responses,index='opt2Code', columns='opt1Code', values='chosenOpt')
mask=heatMapData.isnull()
plt.figure(figsize=(18, 12))
sb.heatmap(heatMapData,square=True,mask=heatMapData.isnull())

plt.figure()
sb.jointplot('elicitedRank','value',options)

#%%

options.sort(['value'],inplace = True)