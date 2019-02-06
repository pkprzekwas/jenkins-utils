from app.db import DB


def test_adding():
    assert 2 + 2 == 4


def test_multiplying():
    assert 2*2 == 4


def test_subtracting():
    assert 2 - 2 == 0


def test_get_current_user():
    user = DB.get_current_user()
    assert user == "John"
