#
#  Copyright (c) 2019 Flare Systems Inc.
#
#  This file is part of python-purple.
#
#  python-purple is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  python-purple is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
import time
import pytest

import purple
from purple import PurpleClient

from .utils import get_test_account


def test_request_input_callback_ok(client: PurpleClient):

    _requester_cancel_callback_called = False
    _requester_cancel_callback_user_data = None

    _requester_ok_callback_called = False
    _requester_ok_callback_user_data = None
    _requester_ok_callback_input = None

    def _requester_ok_cb(user_data, _input):
        nonlocal _requester_ok_callback_called
        nonlocal _requester_ok_callback_user_data
        nonlocal _requester_ok_callback_input

        _requester_ok_callback_called = True
        _requester_ok_callback_user_data = user_data
        _requester_ok_callback_input = _input

    def _requester_cancel_cb(user_data):
        nonlocal _requester_cancel_callback_called
        nonlocal _requester_cancel_callback_user_data

        _requester_cancel_callback_called = True
        _requester_cancel_callback_user_data = user_data

    _client_callback_called = False
    _title = None
    _primary = None
    _secondary = None

    def client_callback(
        *,
        title,
        primary,
        secondary,
        default_value,
        multiline,
        masked,
        hint,
        ok_text,
        ok_cb,
        cancel_text,
        cancel_cb,
        account,
        who,
        conversation,
    ):
        nonlocal _client_callback_called
        nonlocal _title
        nonlocal _primary
        nonlocal _secondary

        _client_callback_called = True
        _title = title
        _primary = primary
        _secondary = secondary

        ok_cb(b"INPUT")

    client.set_cb_request_request_input(callback=client_callback)

    assert not _client_callback_called
    assert not _requester_ok_callback_called
    assert not _requester_cancel_callback_called

    purple.Request.request_input(
        title=b"title",
        primary=b"primary",
        secondary=b"secondary",
        default_value=b"default_value",
        multiline=True,
        masked=True,
        hint=b"hint",
        ok_text=b"ok text",
        ok_callback=_requester_ok_cb,
        cancel_text=b"cancel_text",
        cancel_callback=_requester_cancel_cb,
        account=None,
        who=b"who",
        conversation=None,
        user_data="some-data",
    )

    assert _requester_ok_callback_called
    assert _requester_ok_callback_user_data == "some-data"
    assert _requester_ok_callback_input == b"INPUT"

    assert not _requester_cancel_callback_called
    assert not _requester_cancel_callback_user_data

    assert _client_callback_called
    assert _title == b"title"
    assert _primary == b"primary"
    assert _secondary == b"secondary"


def test_request_input_callback_cancel(client: PurpleClient):

    _requester_cancel_callback_called = False
    _requester_cancel_callback_user_data = None

    _requester_ok_callback_called = False
    _requester_ok_callback_user_data = None

    def _requester_ok_cb(user_data):
        nonlocal _requester_ok_callback_called
        nonlocal _requester_ok_callback_user_data

        _requester_ok_callback_called = True
        _requester_ok_callback_user_data = user_data

    def _requester_cancel_cb(user_data):
        nonlocal _requester_cancel_callback_called
        nonlocal _requester_cancel_callback_user_data

        _requester_cancel_callback_called = True
        _requester_cancel_callback_user_data = user_data

    _client_callback_called = False
    _title = None
    _primary = None
    _secondary = None

    def client_callback(
        *,
        title,
        primary,
        secondary,
        default_value,
        multiline,
        masked,
        hint,
        ok_text,
        ok_cb,
        cancel_text,
        cancel_cb,
        account,
        who,
        conversation,
    ):
        nonlocal _client_callback_called
        nonlocal _title
        nonlocal _primary
        nonlocal _secondary

        _client_callback_called = True
        _title = title
        _primary = primary
        _secondary = secondary

        cancel_cb()

    client.set_cb_request_request_input(callback=client_callback)

    assert not _client_callback_called
    assert not _requester_ok_callback_called
    assert not _requester_cancel_callback_called

    purple.Request.request_input(
        title=b"title",
        primary=b"primary",
        secondary=b"secondary",
        default_value=b"default_value",
        multiline=True,
        masked=True,
        hint=b"hint",
        ok_text=b"ok text",
        ok_callback=_requester_ok_cb,
        cancel_text=b"cancel_text",
        cancel_callback=_requester_cancel_cb,
        account=None,
        who=b"who",
        conversation=None,
        user_data="some-data",
    )

    assert not _requester_ok_callback_called
    assert not _requester_ok_callback_user_data

    assert _requester_cancel_callback_called
    assert _requester_cancel_callback_user_data == "some-data"

    assert _client_callback_called
    assert _title == b"title"
    assert _primary == b"primary"
    assert _secondary == b"secondary"
