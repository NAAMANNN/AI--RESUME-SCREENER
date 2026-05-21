from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from fastapi.middleware.cors import CORSMiddleware 
from services.parser import extract_text_from_pdf
from services.nlp_engine import calculate_match_score
import mysql.connector # 1. ADD THIS IMPORT AT THE TOP
import time # Added for generating unique temporary emails

app = FastAPI(title="AI Resume Screener API")

# Add CORS Middleware to allow your frontend to connect
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],  
    allow_headers=["*"],  
)

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

        # 2. Your AI calculates the score
        match_score = calculate_match_score(raw_resume_text, job_description)

        # 3. ---> DATABASE LOGIC GOES HERE <---
        try:
            db_connection = mysql.connector.connect(
                host="localhost",
                user="root",          # Default XAMPP username
                password="",          # Default XAMPP password is usually empty
                database="resume_screener"
            )
            cursor = db_connection.cursor()

            # Step A: Dynamically create a Job entry based on the user's input
            job_title = "Demo Job - " + resume_file.filename
            insert_job = "INSERT INTO Jobs (title, description) VALUES (%s, %s)"
            cursor.execute(insert_job, (job_title, job_description))
            current_job_id = cursor.lastrowid

            # Step B: Dynamically create a Candidate entry 
            temp_email = f"demo_{int(time.time())}@bca-project.com" 
            insert_candidate = "INSERT INTO Candidates (full_name, email) VALUES (%s, %s)"
            cursor.execute(insert_candidate, (resume_file.filename, temp_email))
            current_candidate_id = cursor.lastrowid

            # Step C: Create the Resume entry linked to the new candidate
            insert_resume = "INSERT INTO Resumes (candidate_id, resume_text) VALUES (%s, %s)"
            cursor.execute(insert_resume, (current_candidate_id, raw_resume_text))
            current_resume_id = cursor.lastrowid

            # Step D: Insert the final Screening Result with the real dynamic IDs
            insert_result = """
                INSERT INTO Screening_Results (job_id, resume_id, match_score, status) 
                VALUES (%s, %s, %s, 'Pending')
            """
            cursor.execute(insert_result, (current_job_id, current_resume_id, match_score)) 
            
            db_connection.commit()
            
            cursor.close()
            db_connection.close()
            print(f"Success: Data saved! Job ID: {current_job_id}, Resume ID: {current_resume_id}")
            
        except Exception as db_error:
            print(f"Database Connection Error: {db_error}")
        # ----------------------------------------------

        # 4. Finally, return the data to the frontend
        return {
            "status": "success",
            "filename": resume_file.filename,
            "match_score_percentage": match_score
        }

    except ValueError as ve:
        raise HTTPException(status_code=400, detail=str(ve))
    except Exception as e:
        raise HTTPException(status_code=500, detail="Internal Server Error.")