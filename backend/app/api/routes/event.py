from typing import Any

from fastapi import APIRouter, HTTPException, status

from app import crud, models, schemas
from app.api.deps import CurrentUser, SessionDep

router = APIRouter()


@router.get("/{id}", response_model=schemas.EventPublic)
def get_event(*, session: SessionDep, id: int) -> Any:
    event = session.query(models.Event).get(id)
    if not event:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Event not found"
        )
    return event


@router.post("/create", response_model=schemas.EventPublic)
def create_event(
    *, session: SessionDep, current_user: CurrentUser, event_in: schemas.EventCreate
) -> Any:
    event = crud.create_event(
        session=session, event_create=event_in, creator=current_user
    )
    return event


@router.post("/{event_id}/subscribe", response_model=schemas.Message)
def subscribe_event(*, session: SessionDep, current_user: CurrentUser, event_id: int):
    db_event = session.query(models.Event).get(event_id)
    db_me = session.query(models.User).get(current_user.id)
    if not db_event:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Event not found"
        )
    if not db_me:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )
    if db_event in db_me.subscribed_events:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT, detail="Already subscribed"
        )

    db_me.subscribed_events.append(db_event)
    session.commit()
    return schemas.Message(message="Subscribed successfully")


@router.post("/{event_id}/unsubscribe", response_model=schemas.Message)
def unsubscribe_event(*, session: SessionDep, current_user: CurrentUser, event_id: int):
    db_event = session.query(models.Event).get(event_id)
    db_me = session.query(models.User).get(current_user.id)
    if not db_event:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Event not found"
        )
    if not db_me:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )
    if db_event not in db_me.subscribed_events:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Not subscribed"
        )
    db_me.subscribed_events.remove(db_event)
    session.commit()
    return schemas.Message(message="Unsubscribed successfully")


@router.delete("/{event_id}/delete", response_model=schemas.Message)
def delete_event(*, session: SessionDep, current_user: CurrentUser, event_id: int):
    db_event = session.query(models.Event).get(event_id)
    db_me = session.query(models.User).get(current_user.id)
    if not db_event:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Event not found"
        )
    if not db_me:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )
    if db_me not in db_event.admins and db_me.id != db_event.creator_id:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Only admins can delete event",
        )
    session.delete(db_event)
    session.commit()
    return schemas.Message(message="Deleted successfully")
