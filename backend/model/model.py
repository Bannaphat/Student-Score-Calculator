# Import Python Library
import numpy as np
import pandas as pd
from sklearn import linear_model
from sklearn.model_selection import train_test_split
import joblib

# Load Data
data = pd.read_csv('StudentsPerformanceP.csv')

# สร้าง Target: สมมุติว่าทำนายคะแนนรวม
data['total_score'] = data['math score'] + data['reading score'] + data['writing score']

# สร้าง X และ Y
x = data.iloc[:, 0:5]  # ใช้เฉพาะ column A ถึง E เป็น feature (เพราะเป็นข้อมูล input)
y = data['total_score']

# แบ่ง Training/Test Data
x_train, x_test, y_train, y_test = train_test_split(
    x, y, test_size=0.3, random_state=0
)

# สร้างและ Train Model
net = linear_model.LinearRegression()
net.fit(x_train, y_train)

# ทดสอบโมเดล
y_pred = net.predict(x_test)

# Evaluate Model
mape = np.mean(np.abs(y_test - y_pred) / y_test * 100)
print('MAPE :', np.round(mape, 2), '%')

# Export Model
joblib.dump(net, "Students_Performance_Model.pkl")
