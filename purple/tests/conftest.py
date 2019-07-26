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

import pytest
import sys
import os
import tempfile

import purple


@pytest.fixture
def core():
    c = purple.Purple(
        b"name",
        b"version",
        b"website",
        b"dev-website",
        debug_enabled=True,
        default_path=tempfile.mkdtemp().encode(),
    )
    c.purple_init()

    yield c

    c.destroy()
