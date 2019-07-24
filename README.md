# python-purple

[![Build Status](https://travis-ci.com/Flared/python-purple.svg?branch=master)](https://travis-ci.com/Flared/python-purple)

Python bindings to [libpurple](https://developer.pidgin.im/wiki/WhatIsLibpurple).

# Note

This is [Flare System](https://flare.systems)'s attempt at reviving python-purple. The library was forked from [fahhem/python-purple](https://github.com/fahhem/python-purple), which was a short-lived fork of Anderson Briglia's original work.

Notable changes since then include:
- Moving to Python 3
- Adding tests
- (ongoing) Refactoring the API

No API stability promises are made at this time. However, whatever is tested (see [purple/tests](purple/tests)) can be considered somewhat stable.

# Examples

See [simpleclient.py](examples/simpleclient.py) for usage examples.

# Hacking on python-purple

**Setting up**: pyhton-purple tests use libpurple's null protocol.
Your distro probably does not install it by default.
For guidance on how to build it yourself, take a look at [.travis.yml](.travis.yml).

**Makefile targets**:
 - ``test``: Run all tests.
 - ``format``: Format the source code with black.
 - ``run-simpleclient``: Run simpleclient from the virtualenv.

# Roadmap
- [ ] Use kwargs for all callbacks.
- [ ] Strings should be used instead of bytes wherever it makes sense.

# Changelog

See [CHANGELOG.md](CHANGELOG.md).
