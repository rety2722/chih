from pydantic import BaseModel, EmailStr

from datetime import datetime


# user
class UserBase(BaseModel):
    email: EmailStr
    full_name: str


class UserCreate(UserBase):
    password: str


class UserRegister(BaseModel):
    email: EmailStr
    password: str
    full_name: str | None


class User(UserBase):
    id: int
    hashed_password: str
    created_events: list["Event"] = []
    subscribed_events: list["Event"] = []
    administrated_events: list["Event"] = []

    class Config:
        from_attributes = True


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
    creator: User
    subscribers: list["User"] = []
    admins: list["User"] = []

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
