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

from libpurple cimport account as c_libaccount
from libpurple cimport proxy as c_libproxy

cdef class ProxyInfoType:
    cdef c_libproxy.PurpleProxyType c_type

    def __init__(self):
        self.c_type = c_libproxy.PURPLE_PROXY_NONE

    def get_NONE(self):
        self.c_type = c_libproxy.PURPLE_PROXY_NONE
        return self
    NONE = property(get_NONE)

    def get_USE_GLOBAL(self):
        self.c_type = c_libproxy.PURPLE_PROXY_USE_GLOBAL
        return self
    USE_GLOBAL = property(get_USE_GLOBAL)

    def get_HTTP(self):
        self.c_type = c_libproxy.PURPLE_PROXY_HTTP
        return self
    HTTP = property(get_HTTP)

    def get_SOCKS4(self):
        self.c_type = c_libproxy.PURPLE_PROXY_SOCKS4
        return self

    def get_SOCKS5(self):
        self.c_type = c_libproxy.PURPLE_PROXY_SOCKS5
        return self

    def get_USE_ENVVAR (self):
        self.c_type = c_libproxy.PURPLE_PROXY_USE_ENVVAR
        return self
    USE_ENVVAR = property(get_USE_ENVVAR)

cdef class ProxyInfo:

    cdef c_libproxy.PurpleProxyInfo *c_proxyinfo
    cdef object types

    def __init__(self):
        self.c_proxyinfo = NULL

        self.types = {"HTTP": c_libproxy.PURPLE_PROXY_HTTP,
                "USER_GLOBAL": c_libproxy.PURPLE_PROXY_USE_GLOBAL,
                "USE_ENVVAR": c_libproxy.PURPLE_PROXY_USE_ENVVAR,
                "SOCKS4": c_libproxy.PURPLE_PROXY_SOCKS4,
                "SOCKS5": c_libproxy.PURPLE_PROXY_SOCKS5,
                "NONE": c_libproxy.PURPLE_PROXY_NONE}


    def set_type(self, ProxyInfoType type):
        if self.c_proxyinfo:
            c_libproxy.c_purple_proxy_info_set_type(self.c_proxyinfo, type.c_type)

    def set_host(self, char *host):
        if self.c_proxyinfo:
            c_libproxy.c_purple_proxy_info_set_host(self.c_proxyinfo, host)

    def set_port(self, int port):
        if self.c_proxyinfo:
            c_libproxy.c_purple_proxy_info_set_port(self.c_proxyinfo, port)

    def set_username(self, char *username):
        if self.c_proxyinfo:
            c_libproxy.c_purple_proxy_info_set_username(self.c_proxyinfo, username)

    def set_password(self, char *password):
        if self.c_proxyinfo:
            c_libproxy.c_purple_proxy_info_set_password(self.c_proxyinfo, password)

    def get_types(self):
        return self.types.keys()

    def set_info(self, acc, info):
        ''' @param acc Tuple (username, protocol id) '''
        ''' @param info Dictionary {'type': "HTTP", 'port': "1234", '''
        '''   'host': "1.2.3.4", 'username': "foo", 'passworld': "foo123"} '''

        cdef c_libaccount.PurpleAccount *c_account
        cdef c_libproxy.PurpleProxyInfo *c_proxyinfo
        c_account = c_libaccount.purple_accounts_find(acc[0], acc[1])

        if c_account == NULL:
            #FIXME: Message error or call a callback handle to error
            return False

        c_proxyinfo = c_libaccount.purple_account_get_proxy_info(c_account)
        if c_proxyinfo == NULL:
                c_proxyinfo = c_libproxy.c_purple_proxy_info_new()
                c_libaccount.purple_account_set_proxy_info(c_account, c_proxyinfo)

        if 'type' in info and info['type']:
            type = info['type']
            if not type in self.types:
                type = 'HTTP'
            c_libproxy.c_purple_proxy_info_set_type(c_proxyinfo, self.types[type])

        if 'host' in info and info['host']:
            host = info['host']
            c_libproxy.c_purple_proxy_info_set_host(c_proxyinfo, host)

        if 'port' in info and info['port']:
            port = int(info['port'])
            c_libproxy.c_purple_proxy_info_set_port(c_proxyinfo, port)

        if 'username' in info and info['username']:
            username = info['username']
            c_libproxy.c_purple_proxy_info_set_username(c_proxyinfo, username)

        if 'password' in info and info['password']:
            password = info['password']
            c_libproxy.c_purple_proxy_info_set_password(c_proxyinfo, password)

        return True
