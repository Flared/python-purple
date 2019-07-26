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

import purple


def test_prplnull_is_present(core):
    assert purple.Protocol.find_with_id(b"prpl-null")


def test_protocol_find_with_id(core):
    protocol = purple.Protocol.find_with_id(b"prpl-irc")
    assert protocol
    assert protocol.get_name() == b"IRC"
    assert protocol.get_id() == b"prpl-irc"
    assert repr(protocol) == "<Protocol: b'prpl-irc'>"


def test_protocol_find_with_id_unknown(core):
    protocol = purple.Protocol.find_with_id(b"unknown-id")
    assert protocol is None
