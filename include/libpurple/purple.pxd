#
#  Copyright (c) 2008 INdT - Instituto Nokia de Tecnologia
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

cimport glib

from libpurple cimport account as c_libaccount
from libpurple cimport accountopt as c_libaccountopt
from libpurple cimport buddyicon as c_libbuddyicon
from libpurple cimport blist as c_libblist
from libpurple cimport connection as c_libconnection
from libpurple cimport conversation as c_libconversation
from libpurple cimport core as c_libcore
from libpurple cimport debug as c_libdebug
from libpurple cimport eventloop as c_libeventloop
from libpurple cimport ft as c_libft
from libpurple cimport idle as c_libidle
from libpurple cimport notify as c_libnotify
from libpurple cimport plugin as c_libplugin
from libpurple cimport pounce as c_libpounce
from libpurple cimport prefs as c_libprefs
from libpurple cimport privacy as c_libprivacy
from libpurple cimport proxy as c_libproxy
from libpurple cimport prpl as c_libprpl
from libpurple cimport request as c_librequest
from libpurple cimport roomlist as c_libroomlist
from libpurple cimport server as c_libserver
from libpurple cimport signals as c_libsignals
from libpurple cimport status as c_libstatus
from libpurple cimport savedstatuses as c_libsavedstatuses
from libpurple cimport value as c_libvalue
from libpurple cimport util as c_libutil
from libpurple cimport xmlnode as c_libxmlnode

cdef extern from "libpurple/purple.h":
    pass
