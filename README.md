# python-purple

[![Build Status](https://travis-ci.com/Flared/python-purple.svg?branch=master)](https://travis-ci.com/Flared/python-purple)

Python bindings to [libpurple](https://developer.pidgin.im/wiki/WhatIsLibpurple).

# Note

This is [Flare System](https://flare.systems)'s attempt at reviving python-purple. The library was forked from [fahhem/python-purple](https://github.com/fahhem/python-purple), which was a short-lived fork of Anderson Briglia's original work.

Notable changes since then include:
- Moving to Python 3
- Adding tests
- (ongoing) Refactoring the API
- Type annotations for use with [mypy](https://github.com/python/mypy).
- High-level PurpleClient for an easier-to-use API.

No API stability promises are made at this time. However, whatever is tested (see [purple/tests](purple/tests)) can be considered somewhat stable.

# Examples

See [simpleclient.py](examples/simpleclient.py) for usage examples.

# Hacking on python-purple

## Setting up

pyhton-purple tests use libpurple's null protocol.
Your distro probably does not ship it by default.
For guidance on how to build it yourself, take a look at [.travis.yml](.travis.yml).

## Makefile targets

 - ``test``: Run all tests.
 - ``format``: Format the source code with black.
 - ``run-simpleclient``: Run simpleclient from the virtualenv.

## Tips

Here are some notes that may help you while working on python-purple. I found that some of these things are not entirely obvious so it may
help to read them before getting started.

 - Cast `char*` to `bytes` safely using `cdef bytes py_variable = c_variable or None`

# Roadmap

- [ ] Use kwargs for all callbacks.
- [ ] Strings should be used instead of bytes wherever it makes sense.
- [ ] Good test coverage.

# Changelog

See [CHANGELOG.md](CHANGELOG.md).
