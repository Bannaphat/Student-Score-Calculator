from flask import Flask, request, jsonify         
from flask_cors import CORS                       
from pydantic import BaseModel, Field, ValidationError  
from werkzeug.exceptions import BadRequest        
import joblib                                   
import numpy as np                                


app = Flask(__name__) 
CORS(app)

MODEL_PATH = "Students_Performance_Model.pkl"  # เปลี่ยนชื่อโมเดล


# โหลดโมเดล
try:
    model = joblib.load(MODEL_PATH) 
except Exception as e:
    raise RuntimeError(f"Failed to load model: {e}")


# Schema รับข้อมูลจากผู้ใช้
class StudentFeatures(BaseModel):
    gender: int = Field(..., ge=1, le=2)              # 1=หญิง, 2=ชาย
    race: int = Field(..., ge=1, le=5)                # 1-5
    education: int = Field(..., ge=1, le=6)           # 1-6
    lunch: int = Field(..., ge=1, le=2)               # 1=free/reduced, 2=standard
    test_prep: int = Field(..., ge=1, le=2)           # 1=none, 2=completed


@app.route("/api/student-score", methods=["POST"])
def predict_student_score():
    try:
        data = request.get_json()

        # Validate และ parse ข้อมูล
        features = StudentFeatures(**data)

        # จัดรูปแบบ input สำหรับโมเดล
        x = np.array([[features.gender,
                       features.race,
                       features.education,
                       features.lunch,
                       features.test_prep]])

        # ทำนายคะแนนรวม
        prediction = model.predict(x)

        return jsonify({
            "status": True,
            "total_score": np.round(float(prediction[0]), 1),
            "max_score": 300
        })

    except ValidationError as ve:
        errors = {}
        for error in ve.errors():
            field = error['loc'][0]
            msg = error['msg']
            errors.setdefault(field, []).append(msg)
        return jsonify({"status": False, "detail": errors}), 400

    except BadRequest as e:
        return jsonify({
            "status": False,
            "error": "Invalid JSON format",
            "detail": str(e)
        }), 400

    except Exception as e:
        return jsonify({"status": False, "error": str(e)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
