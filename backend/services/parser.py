import pdfplumber
import io

def extract_text_from_pdf(pdf_bytes: bytes) -> str:
    extracted_text = ""
    try:
        with pdfplumber.open(io.BytesIO(pdf_bytes)) as pdf:
            for page in pdf.pages:
                text = page.extract_text()
                if text:
                    extracted_text += text + "\n"
        return extracted_text.strip()
    except Exception as e:
        raise ValueError(f"Failed to parse PDF: {str(e)}")