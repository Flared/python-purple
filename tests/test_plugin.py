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
