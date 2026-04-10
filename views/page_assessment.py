import streamlit as st
from services.assessment_service import (
    check_and_start_session,
    get_questions,
    submit_response,
    submit_assessment,
    get_assessment_result,
    is_existing_session,
    clear_session_responses
)
from ml.predictor import predict_obesity_level


def show():
    st.header("Health Assessment")
    st.subheader("Complete the questionnaire to receive your personalized health evaluation")

    # ── STEP 1: Email input ────────────────────────────────────────
    if "user_email" not in st.session_state:
        with st.form("email_form"):
            email = st.text_input("Enter your registered email *")
            submitted = st.form_submit_button("Start Assessment")
        if submitted:
            if not email:
                st.error("Email is required")
            else:
                success, result = check_and_start_session(email)
                if not success:
                    st.error(result)
                else:
                    st.session_state["user_email"] = email
                    st.session_state["session_id"] = result
                    st.session_state["resuming"] = is_existing_session(result)
                    st.session_state["assessment_step"] = "form"
                    st.rerun()
        return

    # ── If user_email already in session (came from registration) ──
    if "session_id" not in st.session_state:
        success, result = check_and_start_session(st.session_state["user_email"])
        if not success:
            st.error(result)
            if st.button("Back"):
                del st.session_state["user_email"]
                st.rerun()
            return
        st.session_state["session_id"] = result
        st.session_state["resuming"] = is_existing_session(result)
        st.session_state["assessment_step"] = "form"
        st.rerun()

    # ── STEP 2: Questionnaire form ─────────────────────────────────
    if st.session_state.get("assessment_step") == "form":
        questions = get_questions()
        if not questions:
            st.error("Could not load questions. Please try again.")
            return

        st.info(f"Session started for: {st.session_state['user_email']}")

        # Show resume banner if continuing incomplete session
        if st.session_state.get("resuming"):
            st.warning("You have an incomplete assessment. Resuming where you left off.")

        st.divider()

        with st.form("assessment_form"):
            responses = {}  # {question_text: option_text}

            for q in questions:
                options = [opt["option_text"] for opt in q["options"]]
                label = q["question_text"] if q["is_required"] else f"{q['question_text']} (Optional)"

                if q["question_type"] == "boolean":
                    selected = st.radio(
                        label,
                        options=options,
                        index=None,
                        horizontal=True,
                        key=f"q_{q['question_id']}"
                    )
                else:  # single_choice
                    selected = st.selectbox(
                        label,
                        options=["-- Select --"] + options,
                        key=f"q_{q['question_id']}"
                    )
                responses[q["question_text"]] = selected

            submitted = st.form_submit_button("Submit Assessment")

        if submitted:
            # Validate required questions answered
            unanswered = [
                q["question_text"] for q in questions
                if q["is_required"]
                and (
                    not responses.get(q["question_text"])
                    or responses[q["question_text"]] == "-- Select --"
                )
            ]
            if unanswered:
                st.error(f"Please answer all {len(unanswered)} required question(s).")
                return

            # Clear old responses before resubmitting
            clear_session_responses(st.session_state["session_id"])

            # Submit each response to DB
            with st.spinner("Saving your responses..."):
                for q in questions:
                    # Skip optional questions that were not answered
                    if not q["is_required"] and (
                        not responses.get(q["question_text"])
                        or responses[q["question_text"]] == "-- Select --"
                    ):
                        continue

                    success, msg = submit_response(
                        st.session_state["session_id"],
                        q["question_id"],
                        responses[q["question_text"]]
                    )
                    if not success:
                        st.error(f"Error on '{q['question_text']}': {msg}")
                        return

            st.session_state["responses"] = responses
            st.session_state["assessment_step"] = "completed"
            st.session_state.pop("resuming", None)
            st.rerun()

    # ── STEP 3: Completed screen ───────────────────────────────────
    if st.session_state.get("assessment_step") == "completed":
        st.success("Assessment completed!")
        st.write("Your responses have been recorded.")

        if st.button("See My Results", use_container_width=True):
            st.session_state["assessment_step"] = "result"
            st.rerun()

    # ── STEP 4: Run ML + show result ───────────────────────────────
    if st.session_state.get("assessment_step") == "result":
        
        # Only run ML + submit if not already done
        if "assessment_result" not in st.session_state:
            with st.spinner("Analyzing your results..."):
                from services.user_registration import get_user_by_email
                success, user = get_user_by_email(st.session_state["user_email"])
                if not success:
                    st.error(f"Could not load user profile: {user}")
                    return

                questions = get_questions()
                option_value_map = {}
                for q in questions:
                    for opt in q["options"]:
                        option_value_map[(q["question_text"], opt["option_text"])] = opt["option_value"]

                responses_for_model = {}
                for q in questions:
                    selected_text = st.session_state["responses"].get(q["question_text"])
                    if selected_text and selected_text != "-- Select --":
                        responses_for_model[q["question_text"]] = option_value_map.get(
                            (q["question_text"], selected_text), selected_text
                        )

                predicted_level = predict_obesity_level(
                    responses=responses_for_model,
                    gender=user["gender"],
                    age=user["age"],
                    height=float(user["height"]),
                    weight=float(user["weight"])
                )

                success, msg = submit_assessment(
                    st.session_state["session_id"],
                    predicted_level
                )
                if not success:
                    st.error(msg)
                    return

                success, result = get_assessment_result(st.session_state["session_id"])
                if not success:
                    st.error(result)
                    return

                # Cache result in session_state — avoid rerunning ML
                st.session_state["assessment_result"] = result

        # Display result from cache
        result = st.session_state["assessment_result"]

        st.divider()
        st.subheader(f"Your Result: {result['predicted_obesity_level']}")
        st.info(result["message"])
        st.write(f"*{result['description']}*")

        st.divider()
        st.subheader("Your Personalized Nutrition Plan")
        col1, col2, col3, col4 = st.columns(4)
        col1.metric("Daily Calories", f"{result['calories']:.0f} kcal")
        col2.metric("Protein", f"{result['protein_g']:.0f} g")
        col3.metric("Carbohydrates", f"{result['carbs_g']:.0f} g")
        col4.metric("Fat", f"{result['fat_g']:.0f} g")

        st.divider()
        col1, col2 = st.columns(2)
        with col1:
            if st.button("Book a Consultant", use_container_width=True):
                st.session_state["page"] = "booking"
                for key in ["session_id", "assessment_step", "responses", "assessment_result"]:
                    st.session_state.pop(key, None)
                st.rerun()
        with col2:
            if st.button("Start New Assessment", use_container_width=True):
                for key in ["session_id", "assessment_step", "responses", "assessment_result"]:
                    st.session_state.pop(key, None)
                st.rerun()