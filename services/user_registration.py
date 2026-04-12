import mysql.connector
from db.connection import get_connection

def register_user(email, phone, first_name, last_name, gender, dob, height, weight):
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.callproc("register_user", [email, phone, first_name, last_name,
                                            gender, dob, height, weight])
        conn.commit()
        return True, "Registration successful!"
    
    except mysql.connector.Error as e:
        return False, e.msg  
    finally:
        cursor.close()
        conn.close()
