from typing import Any

from fastapi import APIRouter, HTTPException

from app import crud
from app.core.config import settings
from app.core.security import get_password_hash, verify_password
from app.models import (
    Event,
    User
)
from app.schemas import (
    UpdatePassword,
    UserCreate,
    UserPublic,
    UserRegister,
    UsersPublic,
    UserUpdate,
    UserUpdateMe,
    Message
)

router = APIRouter()