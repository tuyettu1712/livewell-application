import mysql.connector
from db.connection import get_connection

def get_user_by_email(email):
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)  # accessing data with column names
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

def check_and_start_session(email):
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor()

        result = cursor.callproc("start_assessment_session", [email, 0])
        print(f"DEBUG callproc result: {result}")  # ← result là tuple chứa args sau khi procedure chạy

        # OUT parameter nằm ở index 1 trong result tuple
        session_id = result[1]
        print(f"DEBUG session_id from result: {session_id}")

        conn.commit()

        if session_id is None:
            return False, "Could not create session"

        return True, int(session_id)

    except mysql.connector.Error as e:
        print(f"DEBUG mysql error: {e.msg}")
        return False, e.msg
    finally:
        try:
            if cursor is not None: cursor.close()
            if conn is not None: conn.close()
        except: pass

def get_questions():
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            SELECT q.question_id, q.question_text, q.question_type,
                   q.is_required,
                   o.option_text, o.option_value, o.display_order
            FROM Question q
            JOIN Question_Option o ON q.question_id = o.question_id
            WHERE q.is_active = TRUE AND o.is_active = TRUE
            ORDER BY q.question_id, o.display_order
        """)
        rows = cursor.fetchall()

        questions = {}
        for row in rows:
            qid = row["question_id"]
            if qid not in questions:
                questions[qid] = {
                    "question_id": qid,
                    "question_text": row["question_text"],
                    "question_type": row["question_type"],
                    "is_required": bool(row["is_required"]),
                    "options": []
                }
            questions[qid]["options"].append({
                "option_text": row["option_text"],
                "option_value": row["option_value"]
            })

        return list(questions.values())

    except Exception as e:
        print(f"DEBUG get_questions error: {type(e)} — {e}")
        return []
    finally:
        try:
            if cursor is not None: cursor.close()
            if conn is not None: conn.close()
        except: pass


def submit_response(session_id, question_id, option_text):
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.callproc("submit_response", [session_id, question_id, option_text])
        conn.commit()
        return True, "OK"
    except mysql.connector.Error as e:
        return False, e.msg
    finally:
        try:
            if cursor is not None: cursor.close()
            if conn is not None: conn.close()
        except: pass


def submit_assessment(session_id, predicted_obesity_level):
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.callproc("submit_assessment", [session_id, predicted_obesity_level])
        conn.commit()
        return True, "OK"
    except mysql.connector.Error as e:
        return False, e.msg
    finally:
        try:
            if cursor is not None: cursor.close()
            if conn is not None: conn.close()
        except: pass


def get_assessment_result(session_id):
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            SELECT
                s.predicted_obesity_level,
                s.calories,
                s.protein_g,
                s.carbs_g,
                s.fat_g,
                r.description,
                r.message
            FROM Assessment_Session s
            JOIN Recommendation_Rule r ON s.predicted_obesity_level = r.obesity_level
            WHERE s.session_id = %s
        """, (session_id,))
        return True, cursor.fetchone()
    except mysql.connector.Error as e:
        return False, e.msg
    finally:
        try:
            if cursor is not None: cursor.close()
            if conn is not None: conn.close()
        except: pass


def is_existing_session(session_id):
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            "SELECT COUNT(*) FROM Selects WHERE session_id = %s",
            (session_id,)
        )
        count = cursor.fetchone()[0]
        return count > 0
    except:
        return False
    finally:
        try:
            if cursor is not None: cursor.close()
            if conn is not None: conn.close()
        except: pass

def clear_session_responses(session_id):
    conn = None
    cursor = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            "DELETE FROM Selects WHERE session_id = %s",
            (session_id,)
        )
        conn.commit()
        return True
    except:
        return False
    finally:
        try:
            if cursor is not None: cursor.close()
            if conn is not None: conn.close()
        except: pass