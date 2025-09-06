# app/routes/notes.py
from fastapi import APIRouter, HTTPException, Depends, status
from app.models.note import Note
from app.deps.auth import get_current_uid
from datetime import datetime

router = APIRouter()

# In-memory fake DB: kullanıcı -> [notes]
fake_notes: dict[str, list[dict]] = {}

@router.get("/", response_model=list[dict])
def list_notes(uid: str = Depends(get_current_uid)):
    return fake_notes.get(uid, [])

@router.post("/", status_code=status.HTTP_201_CREATED)
def create_note(
    note: Note,
    uid: str = Depends(get_current_uid),
):
    # kullanıcıya özel liste
    bucket = fake_notes.setdefault(uid, [])
    bucket.append(note.dict())
    return note

@router.put("/{note_id}", response_model=Note)
def update_note(note_id: str, note: Note, uid: str = Depends(get_current_uid)):
    bucket = fake_notes.get(uid, [])
    for i, n in enumerate(bucket):
        if n["id"] == note_id:
            # id'yi path'ten al, noteden gelen id'yi ez
            note.id = note_id
            note.updated_at = datetime.utcnow()
            bucket[i] = note.dict()
            return note
    raise HTTPException(status_code=404, detail="Note not found")

@router.delete("/{note_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_note(note_id: str, uid: str = Depends(get_current_uid)):
    bucket = fake_notes.get(uid, [])
    for i, n in enumerate(bucket):
        if n["id"] == note_id:
            bucket.pop(i)
            return
    raise HTTPException(status_code=404, detail="Note not found")