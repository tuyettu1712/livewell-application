import mysql.connector
from db.connection import get_connection

def get_all_specializations():
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(
            "SELECT specialization_name FROM Specialization ORDER BY specialization_name"
        )
        return True, cursor.fetchall()
    except mysql.connector.Error as e:
        return False, e.msg
    finally:
        try:
            if cursor is not None: cursor.close()
            if conn is not None: conn.close()
        except: pass


def get_consultants_filtered(specialization=None, filter_date=None, name=None):
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)

        # Build dynamic query
        date_join = "AND ca.slot_date = %s" if filter_date else ""
        spec_filter = "AND o.specialization_name = %s" if specialization else ""
        name_filter = "AND CONCAT(c.first_name, ' ', c.last_name) LIKE %s" if name else ""

        query = f"""
            SELECT DISTINCT
                c.consultant_email,
                c.first_name,
                c.last_name,
                c.description,
                GROUP_CONCAT(DISTINCT o.specialization_name ORDER BY o.specialization_name SEPARATOR ', ') AS specializations,
                COUNT(DISTINCT ca.slot_time) AS available_slots
            FROM Consultant c
            JOIN Obtains o ON c.consultant_email = o.consultant_email
            LEFT JOIN Consultant_Availability ca
                ON c.consultant_email = ca.consultant_email
                AND ca.booking_status = 'open'
                {date_join}
            WHERE 1=1
                {spec_filter}
                {name_filter}
            GROUP BY c.consultant_email, c.first_name, c.last_name, c.description
            ORDER BY available_slots DESC
        """

        params = []
        if filter_date: params.append(filter_date)
        if specialization: params.append(specialization)
        if name: params.append(f"%{name}%")

        cursor.execute(query, params)
        return True, cursor.fetchall()

    except mysql.connector.Error as e:
        return False, e.msg
    finally:
        try:
            if cursor is not None: cursor.close()
            if conn is not None: conn.close()
        except: pass


def get_available_slots(consultant_email, filter_date=None):
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)

        if filter_date:
            cursor.execute("""
                SELECT slot_date, slot_time
                FROM Consultant_Availability
                WHERE consultant_email = %s
                AND booking_status = 'open'
                AND slot_date = %s
                ORDER BY slot_date, slot_time
            """, (consultant_email, filter_date))
        else:
            cursor.execute("""
                SELECT slot_date, slot_time
                FROM Consultant_Availability
                WHERE consultant_email = %s
                AND booking_status = 'open'
                AND slot_date >= CURDATE()
                ORDER BY slot_date, slot_time
            """, (consultant_email,))

        return True, cursor.fetchall()

    except mysql.connector.Error as e:
        return False, e.msg
    finally:
        try:
            if cursor is not None: cursor.close()
            if conn is not None: conn.close()
        except: pass


def book_slot(user_email, consultant_email, slot_date, slot_time):
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.callproc("book_slot", [user_email, consultant_email, slot_date, slot_time])
        conn.commit()
        return True, "Booking confirmed!"
    except mysql.connector.Error as e:
        return False, e.msg
    finally:
        try:
            if cursor is not None: cursor.close()
            if conn is not None: conn.close()
        except: pass

def get_booking_history(user_email):
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc("sp_get_booking_history", [user_email])
        results = []
        for result in cursor.stored_results():
            results = result.fetchall()
        return True, results
    except mysql.connector.Error as e:
        return False, e.msg
    finally:
        try:
            if cursor is not None: cursor.close()
            if conn is not None: conn.close()
        except: pass


def cancel_booking(user_email, consultant_email, slot_date, slot_time):
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.callproc("cancel_booking", [user_email, consultant_email, slot_date, slot_time])
        conn.commit()
        return True, "Booking cancelled successfully."
    except mysql.connector.Error as e:
        return False, e.msg
    finally:
        try:
            if cursor is not None: cursor.close()
            if conn is not None: conn.close()
        except: pass


def update_booking(user_email, old_consultant_email, old_slot_date, old_slot_time,
                   new_consultant_email, new_slot_date, new_slot_time):
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.callproc("update_booking", [
            user_email,
            old_consultant_email, old_slot_date, old_slot_time,
            new_consultant_email, new_slot_date, new_slot_time
        ])
        conn.commit()
        return True, "Booking updated successfully."
    except mysql.connector.Error as e:
        return False, e.msg
    finally:
        try:
            if cursor is not None: cursor.close()
            if conn is not None: conn.close()
        except: pass