import streamlit as st
from datetime import date
from services.booking_service import (
    get_all_specializations,
    get_consultants_filtered,
    get_available_slots,
    book_slot
)

def show():
    st.header("Book a Consultant 👨‍⚕️")
    st.subheader("Find a specialist and reserve your consultation slot")

    # ─1: Identify user 
    if "user_email" not in st.session_state:
        with st.form("email_form_booking"):
            email = st.text_input("Enter your registered email *")
            submitted = st.form_submit_button("Continue")
        if submitted:
            if not email:
                st.error("Email is required")
            else:
                st.session_state["user_email"] = email
                st.rerun()
        return

    st.info(f"Booking as: {st.session_state['user_email']}")
    st.divider()

    # 2: Filter bar 
    st.subheader("Find a Consultant")

    col1, col2, col3 = st.columns(3)

    with col1:
        selected_date = st.date_input(
            "SELECT A DATE",
            value=None,
            min_value=date.today(),)

    with col2:
        success, specs = get_all_specializations()
        spec_names = [s["specialization_name"] for s in specs] if success else []
        selected_spec = st.selectbox(
            "SPECIALIZATION",
            options=["All"] + spec_names)

    with col3:
        consultant_name = st.text_input(
            "🔍 Search Consultant Name",
            placeholder="e.g. David")

    st.divider()

    # 3: Load and display consultants 
    success, consultants = get_consultants_filtered(
        specialization=selected_spec if selected_spec != "All" else None,
        filter_date=selected_date,
        name=consultant_name if consultant_name else None
    )

    if not success:
        st.error(consultants)
        return

    if not consultants:
        st.warning("No consultants found matching your filters.")
        return

    st.subheader(f"{len(consultants)} Consultant(s) Found")

    # 4: Consultant cards with slot selection 
    for c in consultants:
        with st.expander(
            f"👨‍⚕️ {c['first_name']} {c['last_name']} "
            f"— {c['specializations']} "
            f"| 🟢 {c['available_slots']} slot(s) available"):
            st.write(f"{c['description']}")
            st.divider()

            # Load available slots for this consultant
            success, slots = get_available_slots(
                consultant_email=c["consultant_email"],
                filter_date=selected_date)

            if not success:
                st.error(slots)
                continue

            if not slots:
                st.info("No available slots for the selected date.")
                continue

            # Slot selector
            slot_options = {
                f"{s['slot_date']}  |  {s['slot_time']}": s
                for s in slots}

            selected_slot_label = st.selectbox(
                "Choose an available slot",
                options=["-- Select a slot --"] + list(slot_options.keys()),
                key=f"slot_{c['consultant_email']}")

            if selected_slot_label == "-- Select a slot --":
                continue

            slot = slot_options[selected_slot_label]

            # Booking summary
            st.markdown(f"""
                > **Consultant:** {c['first_name']} {c['last_name']}  
                > **Date:** {slot['slot_date']}  
                > **Time:** {slot['slot_time']}
            """)

            if st.button(
                "Confirm Booking",
                key=f"book_{c['consultant_email']}",
                use_container_width=True):
                with st.spinner("Booking your slot..."):
                    success, message = book_slot(
                        st.session_state["user_email"],
                        c["consultant_email"],
                        slot["slot_date"],
                        slot["slot_time"])
                if success:
                    st.success("Booking confirmed!")
                else:
                    st.error(message)