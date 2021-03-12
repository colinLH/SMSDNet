import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
%matplotlib inline
data = pd.read_csv("metric.csv")
x_index = np.arange(1,7)
labels = data.columns.tolist()[1:]
markers = ['o','^','s','+','*','D']
plt.figure(figsize=(10,10))
for index in range(0,6):
    one_row = data.loc[index].tolist()
    labels = one_row[0]
    value = one_row[1:]
    plt.plot(x_index,value,label=labels,marker=markers[index],markersize=10)
plt.legend(loc='upper center',bbox_to_anchor = (0.5,1.05) ,ncol=6)
plt.xticks(x_index,data.columns.tolist()[1:])
plt.yticks(np.arange(0,100,5))
plt.show()