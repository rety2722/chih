from pydantic import EmailStr
from sqlmodel import Field, SQLModel, Session


class User(SQLModel, table=True):
    id: int = Field(default=None, primary_key=True)
    email: EmailStr = Field(unique=True, index=True, max_length=255)
    password: str = Field(
        min_length=8, max_length=40
    )  # TODO: Прикрутить анальное хэширование
    full_name: str = Field(max_length=255)
