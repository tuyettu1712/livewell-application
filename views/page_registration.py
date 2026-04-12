import streamlit as st
import re
from services import user_registration
from datetime import date

def show():
    if st.session_state.get("show_success_popup"):
    # Not showing header/subheader when pop-up is shown
        st.markdown("---")
        st.markdown("### Registration Successful")
        st.markdown(f"Welcome, **{st.session_state.get('registered_email', '')}**! Your account has been created successfully.")
        st.markdown("---")
        st.markdown("**Would you like to proceed with a Health Assessment now?**")
        st.markdown("")

        col1, col2 = st.columns(2)
        with col1:
            if st.button("Start Assessment", use_container_width=True):
                st.session_state["show_success_popup"] = False
                st.session_state["user_email"] = st.session_state["registered_email"]
                st.session_state["page"] = "assessment"
                st.rerun()
        with col2:
            if st.button("Make a Booking", use_container_width=True): 
                st.session_state["show_success_popup"] = False
                st.session_state["user_email"] = st.session_state["registered_email"]
                st.session_state["page"] = "booking"  
                st.rerun()
        return

    # ── Registration form ──────────────────────────────────────
    st.header("Let's Get You Started🌿")
    st.subheader("Fill in your details below to create your LiveWell profile")
    with st.form("registration_form"):
        email = st.text_input("Email *")
        phone = st.text_input("Phone *")
        first_name = st.text_input("First Name *")
        last_name = st.text_input("Last Name *")
        gender = st.selectbox("Gender *", ["", "Male", "Female", "Other"])
        dob = st.date_input("Date of Birth *", min_value=date(1900, 1, 1), max_value=date.today(), value=None)
        height = st.number_input("Height (cm) *", min_value=0.0, max_value=250.0, value=None)
        weight = st.number_input("Weight (kg) *", min_value=0.0, max_value=300.0, value=None)
        submitted = st.form_submit_button("Register")

    if submitted:
        # check required fields
        missing = []
        if not email: missing.append("Email")
        if not phone: missing.append("Phone")
        if not first_name: missing.append("First Name")
        if not last_name: missing.append("Last Name")
        if not gender: missing.append("Gender")
        if dob is None: missing.append("Date of Birth")
        if height is None: missing.append("Height")
        if weight is None: missing.append("Weight")
        if missing:
            st.error(f"Please fill in the required fields: {', '.join(missing)}")
        # check format of email and phone       
        elif not re.match(r'^[\w\.-]+@[\w\.-]+\.\w+$', email):
            st.error("Invalid email format")
        elif not re.match(r'^\d{10,15}$', phone):
            st.error("Phone must be 10-15 digits")
        else:
            with st.spinner("Registering..."):
                success, message = user_registration.register_user(
                    email, phone, first_name, last_name,
                    gender, dob, height, weight)
            if success:
                st.session_state["show_success_popup"] = True
                st.session_state["registered_email"] = email
                st.rerun()
            else:
                st.error(message)