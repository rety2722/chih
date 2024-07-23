from fastapi import APIRouter

from app.api.routes import auth, account, users, event, admin

api_router = APIRouter()
api_router.include_router(auth.router, prefix="/auth", tags=["auth"])
api_router.include_router(account.router, prefix="/account", tags=["account"])
api_router.include_router(users.router, prefix="/users", tags=["users"])
api_router.include_router(admin.router, prefix="/admin", tags=["admin"])
api_router.include_router(event.router, prefix="/event", tags=["event"])
