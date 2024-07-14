from fastapi import APIRouter

from backend.app.api.routes import hello

api_router = APIRouter()
api_router.include_router(hello.router)
