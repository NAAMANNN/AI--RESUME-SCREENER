import spacy
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

nlp = spacy.load("en_core_web_sm")

def clean_text(text: str) -> str:
    doc = nlp(text)
    cleaned_tokens = [
        token.lemma_.lower() for token in doc 
        if not token.is_stop and not token.is_punct and not token.is_space
    ]
    return " ".join(cleaned_tokens)

def calculate_match_score(resume_text: str, job_description: str) -> float:
    cleaned_resume = clean_text(resume_text)
    cleaned_jd = clean_text(job_description)

    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform([cleaned_resume, cleaned_jd])

    similarity_matrix = cosine_similarity(tfidf_matrix[0:1], tfidf_matrix[1:2])
    score = similarity_matrix[0][0] * 100
    
    return round(score, 2)