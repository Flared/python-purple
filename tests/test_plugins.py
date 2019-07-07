import purple


def test_plugins_get_protocols():
    plugins = purple.Plugins()
    protocols = plugins.get_protocols()
    assert isinstance(protocols, list)


def test_plugins_enabled():
    plugins = purple.Plugins()
    ret = plugins.plugins_enabled()
    assert ret is True


def test_plugins_get_all():
    purple_plugins = purple.Plugins()
    plugins = purple_plugins.get_plugins()
    assert isinstance(plugins, list)


def test_plugins_get_search_paths():
    purple_plugins = purple.Plugins()
    search_paths = purple_plugins.get_search_paths()
    assert isinstance(search_paths, list)
    assert len(search_paths)
