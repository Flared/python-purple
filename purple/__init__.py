import sys
import os

dlopenflags = sys.getdlopenflags()
if not dlopenflags & os.RTLD_GLOBAL:
    sys.setdlopenflags(dlopenflags | os.RTLD_GLOBAL)

from .purple import Purple
from .purple import Protocol
from .purple import Plugins
from .purple import Plugin