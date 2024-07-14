import psycopg2
from hashlib import sha256

from backend.env.constants import *
from user import User


class Database:
    def __init__(self, database: str = 'test', host: str = 'localhost', admin: str = ADMIN,
                 admin_pwd: str = ADMIN_PWD, connect_timeout: int = 3):
        try:
            self.conn = psycopg2.connect(
                database=database,
                host=host,
                user=admin,
                password=admin_pwd,
                connect_timeout=connect_timeout
            )
        except Exception as e:
            raise e

        self.cursor = self.conn.cursor()

        self.cursor.execute("""
        CREATE TABLE IF NOT EXISTS usr_login (
            id INTEGER PRIMARY KEY,
            username VARCHAR(255) UNIQUE NOT NULL,
            password VARCHAR(255) NOT NULL
        );
        """)
        self.conn.commit()

    def add_user(self, user: User):
        pwd = sha256(user.password.encode()).hexdigest()
        if not self.check_user_exists(user):
            self.cursor.execute(f"""
            INSERT INTO usr_login (id, username, password) VALUES
            ((SELECT COALESCE(MAX(id)+1, 1) FROM usr_login), '{user.name}', '{pwd}');
            """)
            self.conn.commit()

    def check_user_exists(self, user: User) -> bool:
        self.cursor.execute(f"SELECT EXISTS(SELECT TRUE FROM usr_login WHERE username='{user.name}');")
        return self.cursor.fetchall()[0][0]

