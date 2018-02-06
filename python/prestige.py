import numpy as np
import pandas as pd
import statsmodels.api as sm

df = pd.read_csv("prestige.csv") #load data into pandas dataframe

#split data
y = df.as_matrix(columns=['prestige']).ravel() #column 'prestige', as a 1d numpy array

X = df.as_matrix(columns=df.columns[1:4]) #education, income and percent women, as a 2d numpy array

X = np.hstack((np.ones((X.shape[0],1)),X)) #add an intercept

#compute the estimator

betahat = np.dot(np.dot(np.linalg.inv(np.dot(X.T,X)),X.T),y)

# Fill in the blanks
betacov = ?
se_beta = ?
#Now compare to least squares

results = sm.OLS(y,X).fit()
print(results.summary()) 
