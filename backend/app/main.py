from fastapi import FastAPI

from backend.app.api.main import api_router

app = FastAPI(title="ЧИХ ПЫХ")

app.include_router(api_router)
