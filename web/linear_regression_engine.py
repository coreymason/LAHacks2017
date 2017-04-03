import warnings
warnings.filterwarnings(action="ignore", module="scipy", message="^internal gelsd")

import pandas as pd
import numpy as np
import sklearn.linear_model as skl
import matplotlib.pyplot as plt
reg = skl.LinearRegression()

data = pd.read_csv('sleep_quality_data.csv', index_col=0)
x_train = data.as_matrix(['temperature', 'humidity', 'brightness'])[:13]
y_train = data.as_matrix(['sleep quality'])[:13]


reg.fit (x_train, y_train)

# if there is a higher correlation coefficient
# then you want to maximise that variable, and vice versa
fields = ["Temperature", "Humidity", "Room brightness"]
index = 0
for cof in reg.coef_[0]:
	suggestion = ""
	if cof > 0.5:
		suggestion += "increase " + fields[index] + ", "
		print suggestion
		index += 1
	elif cof > 0: 
		suggestion += "slightly increase " + fields[index] + ", "
		print suggestion
		index += 1
	elif cof < -0.5:
		suggestion += "decrease " + fields[index] + ", "
		print suggestion
		index += 1
	elif cof < 0:
		suggestion += "slightly decrease " + fields[index] + ", "
		print suggestion
		index+=1
	else:
		suggestion += "it's fine " + ", "
		print suggestion
		index+=1

#print suggestion

x_test = data.as_matrix(['temperature', 'humidity', 'brightness'])[-1:]
#print x_test

predicted_value = reg.predict(x_test)
print predicted_value
# if predicted_value < 3:
# 	for cof in reg.coef_[0]:
# 	suggestion = ""
# 	if cof > 0.5:
# 		suggestion += "increase " + fields[index] + ", "
# 		print suggestion
# 		index += 1
# 	elif cof > 0: 
# 		suggestion += "slightly increase " + fields[index] + ", "
# 		print suggestion
# 		index += 1
# 	elif cof < -0.5:
# 		suggestion += "decrease " + fields[index] + ", "
# 		print suggestion
# 		index += 1
# 	elif cof < 0:
# 		suggestion += "slightly decrease " + fields[index] + ", "
# 		print suggestion
# 		index+=1
# 	else:
# 		suggestion += "it's fine " + ", "
# 		print suggestion
# 		index+=1

# plot data
data.plot(kind='scatter', x='temperature', y='sleep quality')

# plot the least squares line
plt.plot(x_test, predicted_value, c='red', linewidth=2)

#plt.show()