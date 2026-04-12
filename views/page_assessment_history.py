import streamlit as st
from services.assessment_service import get_assessment_history, delete_assessment_session, is_existing_session


def show():
    st.header("Assessment History")
    st.subheader("View and manage your past health assessments")

    # 1: Identify user 
    if "user_email" not in st.session_state:
        with st.form("email_form_history"):
            email = st.text_input("Enter your registered email *")
            submitted = st.form_submit_button("View History")
        if submitted:
            if not email:
                st.error("Email is required")
            else:
                st.session_state["user_email"] = email
                st.rerun()
        return

    st.info(f"Showing assessments for: {st.session_state['user_email']}")
    st.divider()

    # 2: Load history
    success, sessions = get_assessment_history(st.session_state["user_email"])

    if not success:
        st.error(sessions)
        return

    if not sessions:
        st.info("No assessment history found.")
        if st.button("Start Your First Assessment", use_container_width=True):
            st.session_state["page"] = "assessment"
            st.rerun()
        return

    st.subheader(f"{len(sessions)} Assessment(s) Found")
    st.divider()

    # ── STEP 3: Display sessions ───────────────────────────────
    for i, s in enumerate(sessions):
        col1, col2 = st.columns([5, 1])

        col1, col2, col3 = st.columns([4, 1, 1])

        with col1:
            if s["predicted_obesity_level"]:
                st.markdown(f"""
                    **{s['predicted_obesity_level']}**  
                    📅 {s['started_at']}  
                    📊 Calories: {s['calories']} kcal &nbsp;|&nbsp;
                    Protein: {s['protein_g']} g &nbsp;|&nbsp;
                    Carbs: {s['carbs_g']} g &nbsp;|&nbsp;
                    Fat: {s['fat_g']} g  
                    Status: `{s['status']}`
                """)
            else:
                st.markdown(f"""
                    **Incomplete Assessment**  
                    📅 {s['started_at']}  
                    Status: `{s['status']}`
                """)

        with col2:
            if s["status"] == "in-progress":
                has_responses = is_existing_session(s["session_id"])
                if has_responses:
                    if st.button("Get Results", key=f"continue_{i}", use_container_width=True):
                        st.session_state["session_id"] = s["session_id"]
                        st.session_state["assessment_step"] = "result"  
                        st.session_state["page"] = "assessment"
                        st.rerun()
                else:
                    if st.button("Continue", key=f"continue_{i}", use_container_width=True):
                        st.session_state["session_id"] = s["session_id"]
                        st.session_state["assessment_step"] = "form"
                        st.session_state["resuming"] = True
                        st.session_state["page"] = "assessment"
                        st.rerun()

        with col3:
            if st.button("Delete", key=f"delete_{i}", use_container_width=True):
                st.session_state[f"confirm_delete_{i}"] = True

        # Confirm delete dialog
        if st.session_state.get(f"confirm_delete_{i}"):
            st.warning(f"Are you sure you want to delete this assessment from **{s['started_at']}**?")
            c1, c2 = st.columns(2)
            with c1:
                if st.button("Yes, Delete", key=f"yes_delete_{i}", use_container_width=True):
                    success, message = delete_assessment_session(
                        s["session_id"],
                        st.session_state["user_email"]
                    )
                    if success:
                        st.success("Assessment deleted.")
                        del st.session_state[f"confirm_delete_{i}"]
                        st.rerun()
                    else:
                        st.error(message)
            with c2:
                if st.button("Cancel", key=f"no_delete_{i}", use_container_width=True):
                    del st.session_state[f"confirm_delete_{i}"]
                    st.rerun()

        st.divider()