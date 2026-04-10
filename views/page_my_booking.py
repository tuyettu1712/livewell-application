import streamlit as st
from datetime import date
from services.booking_service import (
    get_booking_history,
    cancel_booking,
    update_booking,
    get_all_specializations,
    get_consultants_filtered,
    get_available_slots
)

def show():
    st.header("My Bookings 📋")
    st.subheader("View, update or cancel your upcoming appointments")

    # ── STEP 1: Identify user ──────────────────────────────────────
    if "user_email" not in st.session_state:
        with st.form("email_form_mybooking"):
            email = st.text_input("Enter your registered email *")
            submitted = st.form_submit_button("View My Bookings")
        if submitted:
            if not email:
                st.error("Email is required")
            else:
                st.session_state["user_email"] = email
                st.rerun()
        return

    st.info(f"Showing bookings for: {st.session_state['user_email']}")

    # ── STEP 2: Check if in update mode ───────────────────────────
    if st.session_state.get("update_mode"):
        _show_update_form()
        return

    st.divider()

    # ── STEP 3: Load booking history ──────────────────────────────
    success, bookings = get_booking_history(st.session_state["user_email"])

    if not success:
        st.error(bookings)
        return

    if not bookings:
        st.info("You have no bookings yet.")
        if st.button("Book a Consultant →"):
            st.session_state["page"] = "booking"
            st.rerun()
        return

    st.subheader(f"{len(bookings)} Booking(s) Found")
    st.divider()

    # ── STEP 4: Display bookings with action buttons ───────────────
    for i, b in enumerate(bookings):
        col1, col2, col3 = st.columns([4, 1, 1])

        with col1:
            st.markdown(f"""
                **👨‍⚕️ {b['first_name']} {b['last_name']}**  
                🏥 {b['specializations']}  
                📅 {b['slot_date']}  &nbsp;&nbsp; 🕐 {b['slot_time']}  
                📌 Status: `{b['booking_status']}`
            """)

        with col2:
            if st.button("Update", key=f"update_{i}", use_container_width=True):
                # Store current booking info for update form
                st.session_state["update_mode"] = True
                st.session_state["update_booking"] = {
                    "consultant_email": b["consultant_email"],
                    "consultant_name": f"{b['first_name']} {b['last_name']}",
                    "slot_date": b["slot_date"],
                    "slot_time": b["slot_time"]
                }
                st.rerun()

        with col3:
            if st.button("Cancel", key=f"cancel_{i}", use_container_width=True):
                st.session_state[f"confirm_cancel_{i}"] = True

        # Confirm cancel dialog
        if st.session_state.get(f"confirm_cancel_{i}"):
            st.warning(
                f"Are you sure you want to cancel your booking with "
                f"**{b['first_name']} {b['last_name']}** "
                f"on **{b['slot_date']}** at **{b['slot_time']}**?"
            )
            c1, c2 = st.columns(2)
            with c1:
                if st.button("Yes, Cancel", key=f"yes_cancel_{i}", use_container_width=True):
                    with st.spinner("Cancelling..."):
                        success, message = cancel_booking(
                            st.session_state["user_email"],
                            b["consultant_email"],
                            b["slot_date"],
                            b["slot_time"]
                        )
                    if success:
                        st.success("Booking cancelled.")
                        del st.session_state[f"confirm_cancel_{i}"]
                        st.rerun()
                    else:
                        st.error(message)
            with c2:
                if st.button("No, Keep It", key=f"no_cancel_{i}", use_container_width=True):
                    del st.session_state[f"confirm_cancel_{i}"]
                    st.rerun()

        st.divider()


def _show_update_form():
    """Update booking — select new consultant/slot"""
    old = st.session_state["update_booking"]

    st.subheader("Update Booking")
    st.markdown(f"""
        **Current booking:**  
        {old['consultant_name']}  
        {old['slot_date']}  &nbsp;&nbsp; {old['slot_time']}
    """)
    st.divider()
    st.write("**Select a new slot:**")

    # Filter bar
    col1, col2, col3 = st.columns(3)
    with col1:
        new_date = st.date_input(
            "New Date",
            value=None,
            min_value=date.today()
        )
    with col2:
        success, specs = get_all_specializations()
        spec_names = [s["specialization_name"] for s in specs] if success else []
        new_spec = st.selectbox("Specialization", options=["All"] + spec_names)
    with col3:
        new_name = st.text_input("🔍 Consultant Name", placeholder="e.g. Ananya")

    st.divider()

    # Load filtered consultants
    success, consultants = get_consultants_filtered(
        specialization=new_spec if new_spec != "All" else None,
        filter_date=new_date,
        name=new_name if new_name else None
    )

    if not success:
        st.error(consultants)
    elif not consultants:
        st.warning("No consultants found.")
    else:
        for c in consultants:
            with st.expander(
                f"👨‍⚕️ {c['first_name']} {c['last_name']} "
                f"— {c['specializations']} "
                f"| 🟢 {c['available_slots']} slot(s)"
            ):
                st.write(f"📋 {c['description']}")

                success, slots = get_available_slots(
                    consultant_email=c["consultant_email"],
                    filter_date=new_date
                )

                if not slots:
                    st.info("No available slots.")
                    continue

                slot_options = {
                    f"{s['slot_date']}  |  {s['slot_time']}": s
                    for s in slots
                }

                selected_slot_label = st.selectbox(
                    "Choose new slot",
                    options=["-- Select --"] + list(slot_options.keys()),
                    key=f"new_slot_{c['consultant_email']}"
                )

                if selected_slot_label == "-- Select --":
                    continue

                new_slot = slot_options[selected_slot_label]

                st.markdown(f"""
                    > **New Consultant:** {c['first_name']} {c['last_name']}  
                    > **New Date:** {new_slot['slot_date']}  
                    > **New Time:** {new_slot['slot_time']}
                """)

                if st.button(
                    "Confirm Update",
                    key=f"confirm_update_{c['consultant_email']}",
                    use_container_width=True
                ):
                    with st.spinner("Updating booking..."):
                        success, message = update_booking(
                            st.session_state["user_email"],
                            old["consultant_email"],
                            old["slot_date"],
                            old["slot_time"],
                            c["consultant_email"],
                            new_slot["slot_date"],
                            new_slot["slot_time"]
                        )
                    if success:
                        st.success("Booking updated!")
                        del st.session_state["update_mode"]
                        del st.session_state["update_booking"]
                        st.rerun()
                    else:
                        st.error(message)

    st.divider()
    if st.button("← Back to My Bookings", use_container_width=True):
        del st.session_state["update_mode"]
        del st.session_state["update_booking"]
        st.rerun()