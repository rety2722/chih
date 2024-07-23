from fastapi import APIRouter, HTTPException, Depends

from app import crud
from app.api.deps import (
    CurrentUser,
    SessionDep,
    get_current_active_superuser
)
from app.models import Event, User
from app.schemas import (
    Message
)

router = APIRouter()



@router.delete(
    "/users/{user_id}",
    dependencies=[Depends(get_current_active_superuser)],
    response_model=Message
)
def delete_user(
    session: SessionDep, current_user: CurrentUser, user_id: int
) -> Message:
    user = crud.get_user_by_id(session=session, user_id=user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    if user == current_user and user.superuser:
        raise HTTPException(
            status_code=403, detail="Super users are not allowed to delete themselves"
        )
    session.query(Event).filter(Event.creator_id == user_id).delete()
    session.query(User).filter(User.id == user_id).delete()
    session.commit()
    return Message(message="User deleted successfully")
