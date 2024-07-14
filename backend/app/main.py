from fastapi import FastAPI

from app.api.main import api_router
from app.database.db import init_db

app = FastAPI(title="ЧИХ ПЫХ")
app.add_event_handler("startup", lambda: init_db())
app.include_router(api_router)
