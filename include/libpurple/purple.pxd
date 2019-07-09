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

from libpurple cimport account
from libpurple cimport accountopt
from libpurple cimport buddyicon
from libpurple cimport blist
from libpurple cimport connection
from libpurple cimport conversation
from libpurple cimport core
from libpurple cimport debug
from libpurple cimport eventloop
from libpurple cimport ft
from libpurple cimport idle
from libpurple cimport notify
from libpurple cimport plugin
from libpurple cimport pounce
from libpurple cimport prefs
from libpurple cimport privacy
from libpurple cimport proxy
from libpurple cimport prpl
from libpurple cimport request
from libpurple cimport roomlist
from libpurple cimport server
from libpurple cimport signals
from libpurple cimport status
from libpurple cimport savedstatuses
from libpurple cimport value
from libpurple cimport util
from libpurple cimport xmlnode

cdef extern from "libpurple/purple.h":
    pass
