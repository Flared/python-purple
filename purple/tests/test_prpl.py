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


from . import utils


def test_plugin_protocol_info_get_options(core):
    plugin = purple.Plugin.find_with_id(b"prpl-null")
    protocol_info = plugin.get_protocol_info()

    options = protocol_info.get_options()
    assert len(options) == 1

    option = options[0]
    assert isinstance(option, purple.AccountOption)
    assert option.get_text() == b"Example option"
    assert option.get_setting() == b"example"
    assert option.get_default_string() == b"default"
    assert option.get_masked() == False
    assert not option.get_list()
