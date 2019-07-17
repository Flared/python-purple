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

import click
import tempfile
import getpass
import sys
import os
import time

import purple


class SimpleClient:
    def __init__(self):
        self.core = None

    def protocol_selection(self):
        plugins = purple.Plugins.get_protocols()

        click.echo("Please select a protocol:")
        for index, plugin in enumerate(plugins):
            click.echo(
                "[{index}]: {plugin_name}".format(
                    index=index, plugin_name=plugin.get_name().decode()
                )
            )

        selected_index = click.prompt(
            text="Enter the id",
            type=click.IntRange(min=0, max=len(plugins) - 1),
        )

        selected_plugin = plugins[selected_index]

        protocol = purple.Protocol.find_with_id(selected_plugin.get_id())

        return protocol

    def run(self):
        # Sets initial parameters
        self.core = purple.Purple(
            b"python-purple-simpleclient",
            b"0.1",
            b"https://github.com/flared/python-purple",
            b"https://github.com/flared/python-purple",
            debug_enabled=True,
            default_path=tempfile.mkdtemp().encode(),
        )
        self.core.purple_init()

        # Obtain the protocol
        protocol = self.protocol_selection()

        # Get username/password from user
        username = click.prompt(text="Enter the username", type=str).encode()

        password = click.prompt(
            text="Enter the password", type=str, hide_input=True
        ).encode()

        # Creates new account inside libpurple
        account = purple.Account.new(self.core, protocol, username)
        account.set_password(password)

        # Set account protocol options
        # info = {}
        # info[b'connect_server'] = b'talk.google.com'
        # info[b'port'] = b'443'
        # info[b'old_ssl'] = True
        # account.set_protocol_options(info)

        # Enable account (connects automatically)
        account.set_enabled(True)

        self.loop()

    def loop(self):
        while True:
            try:
                self.core.iterate_main_loop()
                time.sleep(0.01)
            except KeyboardInterrupt:
                click.echo("Quitting...")
                self.core.destroy()
                break


def main():
    client = SimpleClient()
    client.run()


if __name__ == "__main__":
    main()
