import sys
import os

dlopenflags = sys.getdlopenflags()
if not dlopenflags & os.RTLD_GLOBAL:
    sys.setdlopenflags(dlopenflags | os.RTLD_GLOBAL)

from .purple import Purple
from .protocol import Protocol
from .plugin import Plugins
from .plugin import Plugin
