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
