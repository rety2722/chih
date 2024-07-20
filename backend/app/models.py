from sqlalchemy import Column, Float, ForeignKey, Integer, String, DateTime
from sqlalchemy.orm import relationship

from app.core.db import Base


class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    email = Column(String, unique=True, index=True)
    full_name = Column(String(255))
    hashed_password = Column(String)

    created_events = relationship(
        "Event",
        back_populates="creator",
    )
    subscribed_events = relationship(
        "Event", secondary="subscription", back_populates="subscribers"
    )
    administrated_events = relationship(
        "Event", secondary="administration", back_populates="admins"
    )


class Event(Base):
    __tablename__ = "events"
    id = Column(Integer, primary_key=True)
    title = Column(String(255), default="unnamed")
    description = Column(String(255), default="")
    latitude = Column(Float)
    longitude = Column(Float)
    time = Column(DateTime)
    creator_id = Column(Integer, ForeignKey("users.id"))

    creator = relationship("User", back_populates="created_events")
    subscribers = relationship(
        "User", secondary="subscription", back_populates="subscribed_events"
    )
    admins = relationship(
        "User", secondary="administration", back_populates="administrated_events"
    )

class Mode:
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"), primary_key=True)
    event_id = Column(Integer, ForeignKey("events.id"), primary_key=True)
    
    
class Subscription(Mode, Base):
    __tablename__ = "subscription"

class Administration(Mode, Base):
    __tablename__ = "administration"
