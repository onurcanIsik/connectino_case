# app/models/note.py
from pydantic import BaseModel, Field
from datetime import datetime
from uuid import uuid4

class Note(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid4()))
    title: str
    content: str
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)