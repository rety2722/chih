from datetime import datetime

from pydantic import BaseModel, EmailStr, field_validator


# user
class UserBase(BaseModel):
    full_name: str


class UserCreate(UserBase):
    email: EmailStr
    password: str


class UserRegister(BaseModel):
    email: EmailStr
    password: str
    full_name: str | None


class User(UserBase):
    id: int
    email: EmailStr
    hashed_password: str

    active: bool = True
    superuser: bool = False  # TODO можно вынести в отдельную табличку users/privileges

    followers: list["UserPublic"] = []
    follows: list["UserPublic"] = []

    created_events: list["EventPublic"] = []
    subscribed_events: list["EventPublic"] = []
    administrated_events: list["EventPublic"] = []

    class Config:
        from_attributes = True

    @field_validator(
        "created_events", "subscribed_events", "administrated_events", mode="before"
    )
    def validate(cls, events_relationship, **kwargs):
        return [
            EventPublic.model_validate(event.__dict__) for event in events_relationship
        ]


# update
class UserUpdate(UserBase):
    email: EmailStr | None
    password: str | None


class UserUpdateMe(BaseModel):
    full_name: str | None
    email: EmailStr | None


class UpdatePassword(BaseModel):
    current_password: str
    new_password: str


# public
class UserPublic(UserBase):
    id: int
    # TODO: Предлагаю добавить сюда больше полей
    # followers/follows
    # events

    class Config:
        from_attributes = True


class UsersPublic(BaseModel):
    data: list["UserPublic"]
    count: int


# event
class EventBase(BaseModel):
    title: str
    description: str
    latitude: float
    longitude: float
    time: datetime


class EventCreate(EventBase):
    title: str


class Event(EventBase):
    id: int
    creator_id: int
    creator: UserPublic
    subscribers: list["UserPublic"] = []
    admins: list["UserPublic"] = []

    class Config:
        from_attributes = True


# update
class EventUpdate(EventBase):
    title: str | None
    description: str | None
    latitude: float | None
    longitude: float | None
    time: datetime | None


# public
class EventPublic(EventBase):
    id: int
    creator_id: int
    # TODO тогда creator и subscribers здесб тоже
    # надо бы добавить


class EventsPublic(BaseModel):
    data: list["EventPublic"]
    count: int


# message
class Message(BaseModel):
    message: str


# token
class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


class TokenPayload(BaseModel):
    sub: int | None = None
