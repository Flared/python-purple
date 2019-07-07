import purple


def test_plugins_get_protocols():
    plugins = purple.Plugins()
    protocols = plugins.get_protocols()
    assert isinstance(protocols, list)
