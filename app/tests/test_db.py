from app.db import DB


def test_get_current_user():
    user = DB.get_current_user()
    assert user == "John"
