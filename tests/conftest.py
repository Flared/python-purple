import pytest
import sys
import os
import tempfile

import purple


@pytest.fixture
def core():
    c = purple.Purple(
        b"name",
        b"version",
        b"website",
        b"dev-website",
        debug_enabled=True,
        default_path=tempfile.mkdtemp().encode(),
    )
    c.purple_init()

    yield c

    c.destroy()
