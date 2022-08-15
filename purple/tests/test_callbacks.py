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

import purple


def test_callbacks_enum(core):
    callbacks = purple.Callbacks

    assert callbacks.CALLBACK_REQUEST_REQUEST_INPUT == "request-input"
    assert callbacks.CALLBACK_CONVERSATION_WRITE_CHAT == "write-chat"
    assert callbacks.CALLBACK_CONVERSATION_WRITE_IM == "write-im"


def test_add_callback_unknown(core):
    def handler():
        pass

    with pytest.raises(Exception, match="Unknown callback.*"):
        core.add_callback(callback_name="unknown callback", callback=handler)
