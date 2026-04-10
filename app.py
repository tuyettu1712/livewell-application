import streamlit as st
from views import page_registration, page_assessment, page_booking, page_my_booking

st.sidebar.image("images/logo.png", width=250)
st.sidebar.title("Menu")

# Default page
if "page" not in st.session_state:
    st.session_state["page"] = "register"
if st.sidebar.button("Register", use_container_width=True):
    st.session_state["page"] = "register"
if st.sidebar.button("Assessment", use_container_width=True):
    st.session_state["page"] = "assessment"
if st.sidebar.button("Booking", use_container_width=True):
    st.session_state["page"] = "booking"
if st.sidebar.button("My Bookings", use_container_width=True):
    st.session_state["page"] = "my_bookings"

# Route to page
if st.session_state["page"] == "register":
    page_registration.show()
elif st.session_state["page"] == "assessment":
    page_assessment.show()
elif st.session_state["page"] == "booking":
    page_booking.show()
elif st.session_state["page"] == "my_bookings":
    page_my_booking.show()