# LiveWell — Health Assessment & Consultation Booking

LiveWell is an online health consultancy platform that provides users with an instant, data-driven obesity risk assessment using a pre-trained machine learning model, followed by personalized nutrition recommendations and consultant booking.

---

## Team

| Name | Email |
|---|---|
| Tuyet Tu | tu.tu@northeastern.edu |
| Neha Belavatha Krishnegowda | belavathakrishnego.n@northeastern.edu |

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Streamlit 1.56.0 |
| Backend | Python 3.12.7 |
| Database | MySQL 8.4.0 |
| ML Model | LightGBM 4.6.0 |
| DB Connector | mysql-connector-python 9.6.0 |

---

## Setup Instructions

### 1. Clone the project

> **Requirements:** Python 3.12.7 and MySQL 8.4.0 must be installed before proceeding.

```bash
git clone https://github.com/tuyettu1712/livewell-application
cd livewell-application
```

### 2. Create and activate environment

**Option A — Using Anaconda:**
```bash
conda create -n livewell_env python=3.12 pip
conda activate livewell_env
```

**Option B — Using Python venv:**
```bash
python -m venv livewell_env
source livewell_env/bin/activate        # macOS/Linux
livewell_env\Scripts\activate           # Windows
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Setup MySQL database

Make sure MySQL is running, then import the dump file:

**Option A — Terminal:**
```bash
mysql -u root -p < sql/livewell_dump.sql
```

**Option B — MySQL Workbench:**
1. Open MySQL Workbench
2. Go to Server → Data Import
3. Select "Import from Self-Contained File"
4. Choose `sql/livewell_dump.sql`
5. Click "Start Import"

The dump file includes all DDL, stored procedures, functions, triggers, and seed data.

> **Note:** If you encounter Error 1418 when importing functions, run the following in MySQL Workbench first:
> ```sql
> SET GLOBAL log_bin_trust_function_creators = 1;
> ```

### 5. Configure database connection

Edit `db/connection.py` with your MySQL credentials:

```python
def get_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",           # your MySQL username
        password="",           # your MySQL password
        database="livewell"
    )
```

### 6. Run the application

```bash
streamlit run app.py
```

App will open at `http://localhost:8501`

---

## Project Structure

```
livewell/
├── app.py                              # Streamlit entry point
├── requirements.txt
├── images/
│   └── logo.png
├── ml/
│   ├── model.pkl                       # Pre-trained LightGBM model
│   └── predictor.py                    # ML prediction module
├── db/
│   └── connection.py                   # MySQL connection
├── services/
│   ├── user_registration.py            # User CRUD
│   ├── assessment_service.py           # Assessment + ML pipeline
│   └── booking_service.py              # Booking CRUD
├── views/
│   ├── page_registration.py            # Registration page
│   ├── page_assessment.py              # Assessment page
│   ├── page_assessment_history.py      # Assessment history page
│   ├── page_booking.py                 # Booking page
│   └── page_my_booking.py              # My Bookings page
└── sql/
    └── livewell_dump.sql                # Full database dump
```

---

## Application Pages

| Page | Description |
|---|---|
| Register | Create a new user profile with personal and biometric data |
| Assessment | Complete a 13-question lifestyle questionnaire and receive obesity classification and personalized nutrition plan |
| Assessment History | View, continue incomplete, or delete past assessment sessions |
| Booking | Browse and book a consultation slot with available health consultants |
| My Bookings | View, update, or cancel existing bookings |

---

## Database Objects

| Type | Count | Description |
|---|---|---|
| Tables | 10 | Normalized to 3NF |
| Stored Procedures | 12 | Handle all CRUD and transactional operations |
| User-Defined Functions | 6 | BMI, age, calorie, protein, fat, carbs calculations |
| Triggers | 4 | Data validation and booking status automation |

---

## ML Model

- **Algorithm:** LightGBM Classifier
- **Input:** 16 features — gender, age, height, weight, and 12 lifestyle factors
- **Output:** One of 7 obesity levels — Insufficient Weight, Normal Weight, Overweight Level I, Overweight Level II, Obesity Type I, Obesity Type II, Obesity Type III
- **Model file:** `ml/model.pkl`

---

## Troubleshooting

| Issue | Fix |
|---|---|
| Error 1418 on function creation | Run `SET GLOBAL log_bin_trust_function_creators = 1` in Workbench |
| `pip` not found in conda env | Run `conda install pip` first |
| App not loading | Make sure MySQL is running before starting Streamlit |
| `model.pkl` not found | Ensure the file is placed in the `ml/` folder |
| Connection refused | Check MySQL credentials in `db/connection.py` |