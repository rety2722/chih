from sqlmodel import SQLModel, Session, create_engine

from app.models import User

engine = create_engine("sqlite:///database.db")  # TODO: перевести на PostgreSQL


def init_db() -> None:
    SQLModel.metadata.create_all(engine)  # TODO: Добавить систему миграций
