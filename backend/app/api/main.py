from fastapi import APIRouter

from app.api.routes import auth, login, users, event

api_router = APIRouter()
api_router.include_router(auth.router, prefix="/auth", tags=["auth"])
api_router.include_router(login.router, tags=["login"])
api_router.include_router(users.router, prefix="/users", tags=["users"])
api_router.include_router(event.router, prefix="/event", tags=["event"])
