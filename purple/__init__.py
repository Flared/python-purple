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

import sys
import os

dlopenflags = sys.getdlopenflags()
if not dlopenflags & os.RTLD_GLOBAL:
    sys.setdlopenflags(dlopenflags | os.RTLD_GLOBAL)

from .purple import Purple
from .plugin import Plugin
from .prpl import PluginProtocolInfo
from .prpl import ProtoChatEntry
from .account import Account
from .accountopt import AccountOption
from .signals import Signals
from .callbacks import Callbacks
from .request import Request
from .connection import Connection
from .server import Server

from .conversation import Conversation
from .conversation import IM
from .conversation import Chat
from .conversation import ConversationType
from .client import PurpleClient
