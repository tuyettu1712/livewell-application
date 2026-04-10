import mysql.connector
from db.connection import get_connection

def register_user(email, phone, first_name, last_name, gender, dob, height, weight):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        
        cursor.callproc("register_user", [
            email, phone, first_name, last_name,
            gender, dob, height, weight
        ])
        
        conn.commit()
        return True, "Registration successful!"
    
    except mysql.connector.Error as e:
        return False, e.msg  
    
    finally:
        cursor.close()
        conn.close()

def get_user_by_email(email):
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)  # ← phải có dictionary=True
        cursor.callproc("get_user_by_email", [email])
        user = None
        for result in cursor.stored_results():
            user = result.fetchone()
        conn.commit()
        if user is None:
            return False, "User not found"
        return True, user
    except mysql.connector.Error as e:
        return False, e.msg
    finally:
        try:
            if cursor is not None: cursor.close()
            if conn is not None: conn.close()
        except: pass