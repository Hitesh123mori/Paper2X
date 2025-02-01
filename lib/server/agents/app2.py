from fastapi import FastAPI, UploadFile, File, HTTPException
import shutil
import os
import uuid
from langgraph.graph import StateGraph
from typing import Dict, Any
from pydantic import BaseModel
# Import your existing functions and graph setup
from agent import graph, ResPaperExtractState, PPTPresentation, Conversation

app = FastAPI()
UPLOAD_DIR = "uploaded_pdfs"
os.makedirs(UPLOAD_DIR, exist_ok=True)

# In-memory storage for processed results
processed_results: Dict[str, Dict[str, Any]] = {}

class PPTResponse(BaseModel):
    title: str
    authors: list[str]
    institution: str
    slides: list[dict[str, Any]]

@app.get("/")
def read_root():
    return {"message": "Hello, World!"}

@app.post("/generate-ppt")
def generate_ppt(file: UploadFile = File(...)):
    """Endpoint to process a PDF file and generate structured PPT content."""
    file_id = str(uuid.uuid4())  # Generate a unique identifier
    pdf_path = os.path.join(UPLOAD_DIR, file.filename)
    
    try:
        with open(pdf_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        
        # Initialize state
        state: ResPaperExtractState = {"pdf_path": pdf_path}
        
        # Run the graph workflow
        result: Dict[str, Any] = graph.invoke(state)
        print("Graph invocation result:", result)
       
        # Store results using the unique ID
        processed_results[file_id] = result
        
        return {"file_id": file_id}  # Return the ID for retrieval
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Processing error: {str(e)}")
    
    finally:
        if os.path.exists(pdf_path):
            os.remove(pdf_path)

@app.get("/ppt/{file_id}", response_model=PPTResponse)
def get_ppt(file_id: str):
    """Retrieve PPT content for a given file ID."""
    result = processed_results.get(file_id)
    
    if not result:
        raise HTTPException(status_code=404, detail="File ID not found")

    ppt_object: PPTPresentation = result.get("ppt_object")
    return ppt_object


@app.get("/summary/{file_id}")
def get_summary(file_id: str):
    """Retrieve summary for a given file ID."""
    result = processed_results.get(file_id)
    
    if not result:
        raise HTTPException(status_code=404, detail="File ID not found")

    summary: str = result.get("summary_text").content
    return {"summary" : summary}


@app.get("/convo/{file_id}")
def get_convo(file_id: str):
    """Retrieve conversation details for a given file ID."""
    result = processed_results.get(file_id)
    
    if not result:
        raise HTTPException(status_code=404, detail="File ID not found")

    convo: Conversation = result.get("convo")
    return convo

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
