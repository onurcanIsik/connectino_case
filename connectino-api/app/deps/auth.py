from fastapi import Header, HTTPException, Depends
import firebase_admin
from firebase_admin import auth, credentials

cred = credentials.Certificate("firebase-key.json")  
firebase_admin.initialize_app(cred)

def get_current_uid(authorization: str = Header(...)):
    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Missing Bearer token")
    token = authorization.split(" ", 1)[1]
    try:
        decoded = auth.verify_id_token(token)
        return decoded["uid"]
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid or expired token")