# TODO Как хранить координаты в бд?

from sqlmodel import Field, SQLModel, Relationship
from app.database.models.user import User
from datetime import datetime


class Event(SQLModel, table=True):
    id: int = Field(default=None, primary_key=True)
    creator: User = Relationship(back_populates="events")
    # admins TODO
    # place: str  # TODO
    time: datetime = Field()
    # subscribers: list  # TODO
