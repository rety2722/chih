from pydantic import BaseModel, EmailStr

from datetime import datetime


class UserBase(BaseModel):
    email: EmailStr
    full_name: str


class UserCreate(UserBase):
    password: str


class User(UserBase):
    id: int
    hashed_password: str
    evemts: list["Event"] = []

    class Config:
        from_attributes = True


class UserPublic(UserBase):
    id: int


class UsersPublic(BaseModel):
    data: list[UserPublic]
    count: int


class Event(BaseModel):
    id: int
    creator_id: int
    creator: User
    latitude: float
    longitude: float
    time: datetime
    subscribers: list[User] = []

    class Config:
        from_attributes = True
