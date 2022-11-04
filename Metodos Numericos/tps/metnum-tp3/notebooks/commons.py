import metnum
import numpy as np
import pandas as pd
from sklearn.model_selection import ShuffleSplit, KFold

def rmse(expec,pred):
    return np.sqrt(((expec-pred)**2).mean())

def rmsle(expec,pred):
    return np.sqrt(((np.log(expec+1)-np.log(pred+1))**2).mean())

def linear_regression(df,x_cols, y_cols, n_splits=5, shuffle=False):
    if not isinstance(y_cols,list):
        y_cols = [y_cols]
    x = df[x_cols+y_cols].dropna()[x_cols].values
    y = df[x_cols+y_cols].dropna()[y_cols].values
    rmse_res = []
    rmsle_res = []
    folds = []
    kf = ShuffleSplit(n_splits=n_splits, test_size=.25, random_state=0) if shuffle else KFold(n_splits=n_splits)
    for train, test in kf.split(x): 
        linear_regressor = metnum.LinearRegression()
        linear_regressor.fit(x[train,:],y[train])
        x_test = x[test,:]
        pred = linear_regressor.predict(x_test).reshape(len(test))
        
        expec = y[test]
        x_data = {}
        
        for i,c in enumerate(x_cols):
            x_data[c] = x_test[:,i]
            
        folds += [{"pred":pred,"expect":expec,"x":x_data}]
        rmse_res += [rmse(expec,pred)]
        rmsle_res += [rmsle(expec,pred)]
    return folds, np.mean(rmse_res),np.mean(rmsle_res)
    
