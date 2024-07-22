from typing import Any

from fastapi import APIRouter, HTTPException, status

from app import crud
from app.api.deps import (
    CurrentUser,
    SessionDep,
)

# TODO раскомментить как будет готов переезд на postgres:
# get_current_active_superuser
from app.core.config import settings
from app.models import Event, User
from app.schemas import (
    Message,
    UserCreate,
    UserPublic,
    UsersPublic,
    UserUpdate,
)
from app.utils import generate_new_account_email, send_email

router = APIRouter()


@router.get(
    "/",
    # TODO раскомментить как будет готов переезд на postgres:
    # dependencies=[Depends(get_current_active_superuser)]
    response_model=UsersPublic,
)
def read_users(*, session: SessionDep, skip: int = 0, limit: int = 100) -> Any:
    users = session.query(User).offset(skip).limit(limit).all()
    total_count = len(users)
    return UsersPublic(data=users, count=total_count)


@router.post(
    "/",
    # TODO раскомментить как будет готов переезд на postgres:
    # dependencies=[Depends(get_current_active_superuser)],
    response_model=UserPublic,
)
def create_user(*, session: SessionDep, user_in: UserCreate) -> Any:
    # TODO тестить когда эмейлы начнут работать
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


@router.get("/{user_id}", response_model=UserPublic)
def read_user_by_id(user_id: int, session: SessionDep) -> Any:
    user = crud.get_user_by_id(session=session, user_id=user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )
    return user


@router.patch(
    "/{user_id}",
    # TODO раскомментить как будет готов переезд на postgres:
    # dependencies=[Depends(get_current_active_superuser)],
    response_model=UserPublic,
)
def update_user(
    *,
    session: SessionDep,
    user_id: int,
    user_in: UserUpdate,
) -> Any:
    user = crud.get_user_by_id(session=session, user_id=user_id)
    if not user:
        raise HTTPException(
            status_code=404,
            detail="User with this id does not exist in the system",
        )
    if user_in.email:
        existing_user = crud.get_user_by_email(session=session, email=user_in.email)
        if existing_user and existing_user.id != user_id:
            raise HTTPException(
                status_code=409, detail="User with this email already exists"
            )

    user = crud.update_user(session=session, user=user, user_in=user_in)
    return user


@router.delete(
    "/{user_id}",
    # TODO раскомментить как будет готов переезд на postgres:
    # dependencies=[Depends(get_current_active_superuser)]
)
def delete_user(
    session: SessionDep, current_user: CurrentUser, user_id: int
) -> Message:
    user = crud.get_user_by_id(session=session, user_id=user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    if user == current_user:
        raise HTTPException(
            status_code=403, detail="Super users are not allowed to delete themselves"
        )
    session.query(Event).filter(Event.creator_id == user_id).delete()
    session.query(User).filter(User.id == user_id).delete()
    session.commit()
    return Message(message="User deleted successfully")
