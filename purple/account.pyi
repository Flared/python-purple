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
from typing import Any
from typing import Optional

import purple

class Account:
    @staticmethod
    def new(protocol: purple.Plugin, username: bytes) -> "Account": ...
    @staticmethod
    def find(protocol: purple.Plugin, username: bytes) -> Optional[Account]: ...
    def is_connected(self) -> bool: ...
    def get_username(self) -> bytes: ...
    def get_password(self) -> Optional[bytes]: ...
    def get_protocol_id(self) -> Optional[bytes]: ...
    def get_protocol_name(self) -> bytes: ...
    def get_string(self, name: bytes, default_value: bytes) -> bytes: ...
    def get_bool(self, name: bytes, default_value: bool) -> bool: ...
    def is_enabled(self, ui_name: Optional[bytes] = None) -> bool: ...
    def set_password(self, password: bytes) -> None: ...
    def set_string(self, name: bytes, value: bytes) -> None: ...
    def set_bool(self, name: bytes, value: bool) -> None: ...
    def set_enabled(
        self, enabled: bool, *, ui_name: Optional[bytes] = None
    ) -> None: ...
    def get_connection(self) -> purple.Connection: ...
