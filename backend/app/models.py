from sqlalchemy import Column, Float, ForeignKey, Integer, String
from sqlalchemy.orm import relationship

from app.core.db import Base


class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    email = Column(String, unique=True, index=True)
    full_name = Column(String(255))
    hashed_password = Column(String)
    events = relationship("Event", back_populates="creator")
    subscribed_events = relationship(
        "Event", secondary="subscription", back_populates="subscribers"
    )


class Event(Base):
    __tablename__ = "events"
    id = Column(Integer, primary_key=True)
    creator_id = Column(Integer, ForeignKey("users.id"))
    creator = relationship("User", back_populates="events")
    latitude = Column(Float)
    longitude = Column(Float)
    time = Column(String)
    subscribers = relationship(
        "User", secondary="subscription", back_populates="subscribed_events"
    )


class Subscription(Base):
    __tablename__ = "subscription"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    event_id = Column(Integer, ForeignKey("events.id"))
