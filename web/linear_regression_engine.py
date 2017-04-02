import warnings
warnings.filterwarnings(action="ignore", module="scipy", message="^internal gelsd")

import pandas as pd
import numpy as np
import sklearn.linear_model as skl
import matplotlib.pyplot as plt
reg = skl.LinearRegression()

data = pd.read_csv('Advertising.csv', index_col=0)
x_train = data.as_matrix(['TV', 'Radio', 'Newspaper'])[:150]
y_train = data.as_matrix(['Sales'])[:150]


reg.fit (x_train, y_train)
print reg.coef_
#print reg.intercept_

x_test = data.as_matrix(['TV', 'Radio', 'Newspaper'])[-50:]
#print x_test

preds = reg.predict(x_test)
#print preds

# plot data
data.plot(kind='scatter', x='TV', y='Sales')

# plot the least squares line
plt.plot(x_test, preds, c='red', linewidth=2)

#plt.show()