from typing import Any

from fastapi import APIRouter, HTTPException
from sqlalchemy import func, select, update

from app import crud
from app.api.deps import (
    CurrentUser,
    SessionDep,
    # TODO раскомментить как будет готов переезд на postgres:
    # get_current_active_superuser
)
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
from app.utils import generate_new_account_email, send_email


router = APIRouter()


@router.get(
    "/", 
    # TODO раскомментить как будет готов переезд на postgres:
    # dependencies=[Depends(get_current_active_superuser)]
    response_model=UserPublic
)
def read_users(*, session: SessionDep, skip: int = 0, limit: int = 100) -> Any:
    count_statements = select(func.count()).select_from(User)
    count = session.execute(count_statements.one())
    
    statement = select(User).offset(skip).limit(limit)
    users = session.execute(statement).all()
    
    return UsersPublic(data=users, count=count)


@router.post(
    "/", 
    # TODO раскомментить как будет готов переезд на postgres:
    # dependencies=[Depends(get_current_active_superuser)], 
    response_model=UserPublic
)
def create_user(*, session: SessionDep, user_in: UserCreate) -> Any:
    user = crud.get_user_by_email(session=session, email=user_in.email)
    if user:
        raise HTTPException(
            status_code=400,
            detail="The user with this email already exists in the system.",
        )

    user = crud.create_user(session=session, user_create=user_in)
    if settings.emails_enabled and user_in.email:
        email_data = generate_new_account_email(
            email_to=user_in.email, username=user_in.email, password=user_in.password
        )
        send_email(
            email_to=user_in.email,
            subject=email_data.subject,
            html_content=email_data.html_content,
        )
    return user


@router.patch("/me", response_model=UserPublic)
def update_user_me(
    *, session: SessionDep, user_in: UserUpdateMe, current_user: CurrentUser
) -> Any:
    if user_in.email:
        existing_user = crud.get_user_by_email(session=session, email=user_in.email)
        if existing_user and existing_user.id != current_user.id:
            raise HTTPException(
                status_code=409, detail="User with this email already exists"
            )
    user_data = user_in.model_dump(exclude_unset=True)
    statement = update(User).where(User.id == current_user.id).values(**user_data)
    current_user = session.execute(statement)
    session.commit()
    session.refresh(current_user)
    return current_user