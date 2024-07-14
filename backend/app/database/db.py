from sqlmodel import SQLModel, Session, create_engine

from app.database.models.user import User
from app.database.models.event import Event

engine = create_engine("sqlite:///database.db")  # TODO: перевести на PostgreSQL


def init_db() -> None:
    SQLModel.metadata.create_all(engine)  # TODO: Добавить систему миграций
