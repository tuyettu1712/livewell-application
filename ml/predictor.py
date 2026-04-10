import joblib
import pandas as pd

model = joblib.load("ml/model.pkl")

LABEL_MAP = {
    "Insufficient_Weight":  "Insufficient Weight",
    "Normal_Weight":        "Normal Weight",
    "Obesity_Type_I":       "Obesity Type I",
    "Obesity_Type_II":      "Obesity Type II",
    "Obesity_Type_III":     "Obesity Type III",
    "Overweight_Level_I":   "Overweight Level I",
    "Overweight_Level_II":  "Overweight Level II"
}

# All expected columns after get_dummies
EXPECTED_COLUMNS = [
    'Age', 'Height', 'Weight', 'FCVC', 'NCP', 'CH2O', 'FAF', 'TUE',
    'Gender_Female', 'Gender_Male',
    'family_history_with_overweight_no', 'family_history_with_overweight_yes',
    'FAVC_no', 'FAVC_yes',
    'CAEC_Always', 'CAEC_Frequently', 'CAEC_Sometimes', 'CAEC_no',
    'SMOKE_no', 'SMOKE_yes',
    'SCC_no', 'SCC_yes',
    'CALC_Frequently', 'CALC_Sometimes', 'CALC_no',
    'MTRANS_Automobile', 'MTRANS_Bike', 'MTRANS_Motorbike',
    'MTRANS_Public_Transportation', 'MTRANS_Walking'
]

def predict_obesity_level(responses: dict, gender: str, age: int, height: float, weight: float) -> str:
    # Build raw dataframe with original string values
    raw = {
        "Age":    float(age),
        "Height": height / 100,  # cm → meters
        "Weight": float(weight),
        "FCVC":   float(responses.get("How often do you consume vegetables?", 1)),
        "NCP":    float(responses.get("How many main meals do you have per day?", 3)),
        "CH2O":   float(responses.get("How much water do you drink daily?", 2)),
        "FAF":    float(responses.get("How often do you engage in physical activity?", 0)),
        "TUE":    float(responses.get("How much time do you spend using technology?", 0)),
        # Categorical — keep as string for get_dummies
        "Gender":                           gender,
        "family_history_with_overweight":   responses.get("Do you have a family history of being overweight?"),
        "FAVC":                             responses.get("Do you frequently consume high-calorie foods?"),
        "CAEC":                             responses.get("How often do you eat food between meals?"),
        "SMOKE":                            responses.get("Do you smoke?"),
        "SCC":                              responses.get("Do you monitor your calorie intake?"),
        "CALC":                             responses.get("How often do you consume alcohol?"),
        "MTRANS":                           responses.get("What is your main mode of transportation?"),
    }

    df = pd.DataFrame([raw])

    # Apply get_dummies — same as training
    df_encoded = pd.get_dummies(df)

    # Add missing columns with 0 (in case some categories absent)
    for col in EXPECTED_COLUMNS:
        if col not in df_encoded.columns:
            df_encoded[col] = 0

    # Reorder to match exact training column order
    df_encoded = df_encoded[EXPECTED_COLUMNS]

    raw_prediction = model.predict(df_encoded)[0]
    return LABEL_MAP.get(raw_prediction, raw_prediction)