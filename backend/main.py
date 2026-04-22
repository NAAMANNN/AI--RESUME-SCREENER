from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from services.parser import extract_text_from_pdf
from services.nlp_engine import calculate_match_score

app = FastAPI(title="AI Resume Screener API")

@app.post("/api/screen-resume/")
async def screen_resume(
    job_description: str = Form(...),
    resume_file: UploadFile = File(...)
):
    if not resume_file.filename.endswith(".pdf"):
        raise HTTPException(status_code=400, detail="Only PDF files are allowed.")

    try:
        pdf_bytes = await resume_file.read()
        raw_resume_text = extract_text_from_pdf(pdf_bytes)
        
        if not raw_resume_text:
             raise HTTPException(status_code=400, detail="Could not extract text from PDF.")

        match_score = calculate_match_score(raw_resume_text, job_description)

        return {
            "status": "success",
            "filename": resume_file.filename,
            "match_score_percentage": match_score
        }

    except ValueError as ve:
        raise HTTPException(status_code=400, detail=str(ve))
    except Exception as e:
        raise HTTPException(status_code=500, detail="Internal Server Error.")