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


def test_plugin_find_with_id(core):
    plugin = purple.Plugin.find_with_id(b"prpl-irc")
    assert plugin
    assert plugin.get_name() == b"IRC"
    assert plugin.get_id() == b"prpl-irc"
    assert repr(plugin) == "<Plugin: b'prpl-irc'>"


def test_plugin_find_with_id_unknown(core):
    plugin = purple.Plugin.find_with_id(b"unknown-id")
    assert plugin is None


def test_plugin_get_protocols_no_core():
    protocols = purple.Plugin.get_protocols()
    assert isinstance(protocols, list)
    assert not protocols


def test_plugin_get_protocols(core):
    protocols = purple.Plugin.get_protocols()
    assert isinstance(protocols, list)
    assert protocols
    assert len(protocols) > 3


def test_plugin_enabled():
    ret = purple.Plugin.plugins_enabled()
    assert ret is True


def test_plugin_get_all_no_core():
    plugins = purple.Plugin.get_plugins()
    assert isinstance(plugins, list)
    assert not plugins


def test_plugin_get_all(core):
    plugins = purple.Plugin.get_plugins()
    assert isinstance(plugins, list)
    assert plugins
    assert len(plugins) > 3


def test_plugin_get_search_paths_no_core():
    search_paths = purple.Plugin.get_search_paths()
    assert isinstance(search_paths, list)
    assert not search_paths


def test_plugin_get_search_paths(core):
    search_paths = purple.Plugin.get_search_paths()
    assert isinstance(search_paths, list)
    assert search_paths
    assert len(search_paths) == 1
