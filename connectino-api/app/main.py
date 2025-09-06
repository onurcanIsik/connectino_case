from fastapi import FastAPI
from app.routes import notes

app = FastAPI()

# Routers
app.include_router(notes.router, prefix="/notes", tags=["notes"])

@app.get("/")
def root():
    return {"message": "FastAPI backend works!"}