import purple


def test_plugins_get_protocols_no_core():
    protocols = purple.Plugins.get_protocols()
    assert isinstance(protocols, list)
    assert not protocols


def test_plugins_get_protocols(core):
    protocols = purple.Plugins.get_protocols()
    assert isinstance(protocols, list)
    assert protocols
    assert len(protocols) > 3


def test_plugins_enabled():
    ret = purple.Plugins.plugins_enabled()
    assert ret is True


def test_plugins_get_all_no_core():
    plugins = purple.Plugins.get_plugins()
    assert isinstance(plugins, list)
    assert not plugins


def test_plugins_get_all(core):
    plugins = purple.Plugins.get_plugins()
    assert isinstance(plugins, list)
    assert plugins
    assert len(plugins) > 3


def test_plugins_get_search_paths_no_core():
    search_paths = purple.Plugins.get_search_paths()
    assert isinstance(search_paths, list)
    assert not search_paths


def test_plugins_get_search_paths(core):
    search_paths = purple.Plugins.get_search_paths()
    assert isinstance(search_paths, list)
    assert search_paths
    assert len(search_paths) == 1
