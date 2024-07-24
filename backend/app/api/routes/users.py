from typing import Any

from fastapi import APIRouter, HTTPException, status

from app import crud
from app.api.deps import (
    CurrentUser,
    SessionDep,
)

from app.models import User
from app.schemas import (
    Message,
    UserPublic,
)

router = APIRouter()


@router.get("/{user_id}", response_model=UserPublic)
def read_user_by_id(user_id: int, session: SessionDep) -> Any:
    user = crud.get_user_by_id(session=session, user_id=user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )
    return user


@router.post("/{user_id}/subscribe", response_model=Message)
def follow(*, session: SessionDep, current_user: CurrentUser, user_id: int):
    db_me = session.query(User).get(current_user.id)
    db_user = session.query(User).get(user_id)
    if not (db_me and db_user):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )

    if db_user in db_me.follows:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT, detail="Already subscribed"
        )
    db_me.follows.append(db_user)
    session.commit()
    return Message(message="Subscribed Successfully")


@router.post("/{user_id}/unsubscribe", response_model=Message)
def unfollow(*, session: SessionDep, current_user: CurrentUser, user_id: int):
    db_me = session.query(User).get(current_user.id)
    db_user = session.query(User).get(user_id)
    if not (db_me and db_user):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )

    if db_user not in db_me.follows:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Not subscribed"
        )
    db_me.follows.remove(db_user)
    session.commit()
    return Message(message="Unsubscribed Successfully")
