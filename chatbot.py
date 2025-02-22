import streamlit as st

# --- Robot Icon ---
robot_icon_url = "https://img.icons8.com/color/96/000000/artificial-intelligence.png"

# --- App Title and Header ---
st.set_page_config(
    page_title="AI Chatbot Interface",
    page_icon=robot_icon_url,
)

st.title("🤖 AI Chatbot Assistant")

# --- Sidebar for Navigation and Settings ---
with st.sidebar:
    st.header("Settings")
    display_top_queries = st.checkbox("Show Top Queries", value=True)
    model_options = ["GPT-4", "BERT", "DALL-E", "T5"]
    selected_model = st.selectbox("Select AI Model", model_options)

    st.markdown("---")
    st.markdown("Made with ❤️ by [Samiksha]")

# --- FAQs Dictionary ---
faqs = {
    "What is AI?": "AI stands for Artificial Intelligence. It refers to the simulation of human intelligence in machines.",
    "How does machine learning work?": "Machine learning is a subset of AI that involves training algorithms on data to make predictions or decisions.",
    "What is deep learning?": "Deep learning is a subset of machine learning that uses neural networks with many layers to analyze data and make predictions.",
    # Add more FAQs as needed
}

# --- Main Area: Chat Interface ---
if "messages" not in st.session_state:
    st.session_state.messages = []

for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

# Get user query to find appropriate response
if prompt := st.chat_input("Ask me anything about AI..."):
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)
        
    with st.chat_message("assistant", avatar=robot_icon_url):
        message_placeholder = st.empty()
        
        # Find matching FAQ response
        full_response = faqs.get(prompt, f"AI Model ({selected_model}) says: " + prompt)
        
        message_placeholder.markdown(full_response + "▌")
        
    st.session_state.messages.append({"role": "assistant", "content": full_response})

# --- Display Top Queries ---
if display_top_queries:
    st.header("Top Frequently Asked Questions")
    top_queries = [
        "What is AI?",
        "How does machine learning work?",
        "What is deep learning?",
        # Add more top queries as needed
    ]

    for query in top_queries:
        st.write(f"- **{query}**")

# --- Display Top FAQs ---
st.header("Top Referenced FAQs")
top_faqs = [
    "What is AI?",
    "How does machine learning work?",
    "What is deep learning?",
    # Add more top FAQs as needed
]

for faq in top_faqs:
    st.write(f"- **{faq}**")