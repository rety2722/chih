from __future__ import annotations
from sqlalchemy import (
    Column,
    Float,
    ForeignKey,
    Integer,
    String,
    DateTime,
    Table,
    Boolean,
)
from sqlalchemy.orm import relationship
from app.core.db import Base


following = Table(
    "following",
    Base.metadata,
    Column("follower_id", Integer, ForeignKey("users.id"), primary_key=True),
    Column("follows_id", Integer, ForeignKey("users.id"), primary_key=True),
)


class Mode:
    user_id = Column(Integer, ForeignKey("users.id"), primary_key=True)
    event_id = Column(Integer, ForeignKey("events.id"), primary_key=True)


class Subscription(Mode, Base):
    __tablename__ = "subscription"


class Administration(Mode, Base):
    __tablename__ = "administration"


class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    email = Column(String, unique=True, index=True)
    full_name = Column(String(255))
    hashed_password = Column(String)

    active = Column(Boolean)
    superuser = Column(Boolean)

    followers = relationship(
        "User",
        secondary=following,
        primaryjoin=id == following.c.follows_id,
        secondaryjoin=id == following.c.follower_id,
        back_populates="follows",
        uselist=True,
    )
    follows = relationship(
        "User",
        secondary=following,
        primaryjoin=id == following.c.follower_id,
        secondaryjoin=id == following.c.follows_id,
        back_populates="followers",
        uselist=True,
    )

    created_events = relationship("Event", back_populates="creator", uselist=True)
    subscribed_events = relationship(
        "Event", secondary="subscription", back_populates="subscribers", uselist=True
    )
    administrated_events = relationship(
        "Event", secondary="administration", back_populates="admins", uselist=True
    )


class Event(Base):
    __tablename__ = "events"
    id = Column(Integer, primary_key=True)
    title = Column(String(255), default="unnamed")
    description = Column(String(255), default="")
    latitude = Column(Float)
    longitude = Column(Float)
    time = Column(DateTime)
    creator_id = Column(Integer, ForeignKey("users.id"), nullable=False)

    creator = relationship("User", back_populates="created_events", single_parent=True)
    subscribers = relationship(
        "User",
        secondary="subscription",
        back_populates="subscribed_events",
        uselist=True,
    )
    admins = relationship(
        "User",
        secondary="administration",
        back_populates="administrated_events",
        uselist=True,
    )
