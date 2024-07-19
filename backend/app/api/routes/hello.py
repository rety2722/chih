"""
Заглушка для тестовых запросов
"""

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app import crud, schemas
from app.core.db import SessionLocal

router = APIRouter()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/")
def root():
    return {"Чих": "Пых"}


@router.post("/", response_model=schemas.User)
def new_user(
    user_in: schemas.UserCreate, db: Session = Depends(get_db)
) -> schemas.User:
    user = crud.get_user_by_email(session=db, email=user_in.email)
    if user:
        raise HTTPException(
            status_code=400,
            detail="The user with this email already exists in the system.",
        )

    user = crud.create_user(session=db, user_create=user_in)
    return user
