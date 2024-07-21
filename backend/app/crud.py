from sqlalchemy.orm import Session

from app.core.security import get_password_hash, verify_password
from . import models, schemas


def create_user(*, session: Session, user_create: schemas.UserCreate) -> models.User:
    hashed_password = get_password_hash(user_create.password)
    db_user = models.User(
        email=user_create.email,
        full_name=user_create.full_name,
        hashed_password=hashed_password,
    )
    session.add(db_user)
    session.commit()
    session.refresh(db_user)
    return db_user


def update_user(*, session: Session, db_user: models.User, user_in: schemas.UserUpdate) -> models.User | None:
    user_data = user_in.model_dump(exclude_unset=True)
    extra_data = {}
    if "password" in user_data:
        password = user_data["password"]
        hashed_password = get_password_hash(password)
        extra_data["hashed_password"] = hashed_password
        user_data.pop("password")
    session.query(models.User).filter(models.User.id == db_user.id).update(values=user_data, update_args=extra_data)
    session.add(db_user)
    session.commit()
    session.refresh(db_user)
    return db_user


def get_user_by_email(*, session: Session, email: str) -> models.User | None:
    return session.query(models.User).filter(models.User.email == email).first()


def authenticate(*, session: Session, email: str, password: str) -> models.User | None:
    db_user = get_user_by_email(session=session, email=email)
    if not db_user:
        return None
    if not verify_password(password, db_user.hashed_password):
        return None
    return db_user


def create_event(
    *, session: Session, event_create: schemas.EventCreate, creator_id_in: int
) -> models.Event:
    db_event = models.Event(
        title=event_create.title,
        description=event_create.description,
        latitude=event_create.latitude,
        longitude=event_create.longitude,
        time=event_create.time,
        creator_id=creator_id_in,
    )
    session.add(db_event)
    session.commit()
    session.refresh(db_event)
    return db_event
