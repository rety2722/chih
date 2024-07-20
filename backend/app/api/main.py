from fastapi import APIRouter

from app.api.routes import hello, login

api_router = APIRouter()
api_router.include_router(hello.router)
api_router.include_router(login.router, tags=["login"])
