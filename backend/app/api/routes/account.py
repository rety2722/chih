from typing import Any

from fastapi import APIRouter, HTTPException, status

from app import crud, models, schemas
from app.api.deps import CurrentUser, SessionDep
from app.core import security

router = APIRouter()


@router.get("/", response_model=schemas.UserPublic)
def read_user_me(current_user: CurrentUser) -> Any:
    return current_user


@router.patch("/update", response_model=schemas.UserPublic)
def update_user_me(
    *, session: SessionDep, user_in: schemas.UserUpdateMe, current_user: CurrentUser
) -> Any:
    if user_in.email:
        existing_user = crud.get_user_by_email(session=session, email=user_in.email)
        if existing_user and existing_user.id != current_user.id:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="User with this email already exists",
            )
    user_data = user_in.model_dump(exclude_unset=True)
    session.query(models.User).filter(models.User.id == current_user.id).update(
        user_data
    )
    db_user = (
        session.query(models.User).filter(models.User.id == current_user.id).first()
    )

    session.add(db_user)
    session.commit()
    return current_user


@router.patch("/update-password", response_model=schemas.Message)
def update_password_me(
    *, session: SessionDep, body: schemas.UpdatePassword, current_user: CurrentUser
) -> Any:
    if not security.verify_password(
        body.current_password, current_user.hashed_password
    ):
        raise HTTPException(status_code=400, detail="Incorrect password")
    if body.current_password == body.new_password:
        raise HTTPException(
            status_code=400, detail="New password cannot be the same as the current one"
        )
    hashed_password = security.get_password_hash(body.new_password)
    current_user.hashed_password = hashed_password

    session.query(models.User).filter(models.User.id == current_user.id).update(
        {"hashed_password": hashed_password}
    )
    session.commit()
    return schemas.Message(message="Password updated successfully")
