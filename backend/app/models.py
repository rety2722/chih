from datetime import datetime
from decimal import Decimal

from pydantic import EmailStr
from sqlmodel import Field, Relationship, SQLModel


class UserEventLink(SQLModel, table=True):
    user_id: int | None = Field(default=None, foreign_key="user.id", primary_key=True)
    event_id: int | None = Field(default=None, foreign_key="event.id", primary_key=True)


class UserBase(SQLModel):
    email: EmailStr = Field(unique=True, index=True, max_length=255)
    full_name: str = Field(max_length=255)


class UserCreate(UserBase):
    password: str = Field(min_length=8, max_length=40)


class User(UserBase, table=True):
    id: int | None = Field(default=None, primary_key=True)
    hashed_password: str
    events: list["Event"] = Relationship(
        back_populates="users", link_model=UserEventLink
    )


class UserPublic(UserBase):
    id: int


class UsersPublic(SQLModel):
    data: list[UserPublic]
    count: int


class Event(SQLModel, table=True):
    id: int = Field(default=None, primary_key=True)
    creator_id: User = Field(default=None, foreign_key="user.id")
    creator: User = Relationship(back_populates="events")
    latitude: Decimal = Field(default=None, decimal_places=6)
    longitude: Decimal = Field(default=None, decimal_places=6)
    time: datetime = Field()
    subscribers: list["User"] = Relationship(
        back_populates="events", link_model=UserEventLink
    )
