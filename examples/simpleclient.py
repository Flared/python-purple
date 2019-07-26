#
#  Copyright (c) 2008 INdT - Instituto Nokia de Tecnologia
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

import click
import tempfile
import getpass
import sys
import os
import time

import purple


class SimpleClient:
    def __init__(
        self, *, debug, protocol_id=None, username=None, password=None
    ):
        self.debug = debug
        self.core = None

        self.protocol_id = protocol_id
        self.username = username
        self.password = password

    def cb_signal_conversation_received_im_msg(
        self, *, account, sender, message, conversation, flags
    ):
        click.echo(
            "{prefix} {sender} {message}".format(
                prefix=click.style("[RECEIVED-IM-MSG]", fg="green", bold=True),
                sender=click.style(
                    "[{sender}]".format(sender=sender.decode()),
                    fg="yellow",
                    bold=True,
                ),
                message=message.decode(),
            )
        )

    def cb_signal_connection_signing_on(self, connection):
        click.echo(
            "{prefix} Account {account_name} is signing on...".format(
                prefix=click.style("[STATUS]", fg="blue", bold=True),
                account_name=click.style(
                    connection.get_account().get_username().decode(), bold=True
                ),
            )
        )

    def cb_signal_connection_signed_on(self, connection):
        click.echo(
            "{prefix} Account {account_name} signed on.".format(
                prefix=click.style("[STATUS]", fg="blue", bold=True),
                account_name=click.style(
                    connection.get_account().get_username().decode(), bold=True
                ),
            )
        )

    def cb_signal_connection_error(
        self, connection, description, short_description
    ):
        click.echo(
            "{prefix} Connection error for {account_name}: {short_description}: {description}".format(
                prefix=click.style("[ERROR]", fg="red", bold=True),
                account_name=click.style(
                    connection.get_account().get_username().decode(), bold=True
                ),
                short_description=short_description,
                description=description,
            )
        )

    def cb_request_request_input(
        self,
        *,
        title,
        primary,
        secondary,
        default_value,
        multiline,
        masked,
        hint,
        ok_text,
        ok_cb,
        cancel_text,
        cancel_cb,
        account,
        who,
        conversation,
    ):
        click.echo(
            "{title} {primary}".format(
                title=click.style(
                    "[" + title.decode() + "]", fg="yellow", bold=True
                ),
                primary=click.style(primary.decode(), bold=True),
            )
        )

        try:
            _input = click.prompt("Enter response", type=str).encode()
            ok_cb(_input)
        except click.Abort:
            cancel_cb()

    def protocol_selection(self):
        # If self.protocol_id is set, try to use it
        # before asking anything to the user.
        if self.protocol_id:
            protocol = purple.Protocol.find_with_id(self.protocol_id.encode())
            if protocol is not None:
                return protocol
            else:
                click.echo(
                    "{protocol_id} is not a valid protocol id.".format(
                        protocol_id=self.protocol_id
                    )
                )

        plugins = purple.Plugin.get_protocols()

        click.echo(
            click.style("Please select a protocol:", fg="green", bold=True)
        )
        for index, plugin in enumerate(plugins):
            click.echo(
                "{index}: {plugin_name} ({plugin_id})".format(
                    index=click.style("[" + str(index) + "]", bold=True),
                    plugin_name=plugin.get_name().decode(),
                    plugin_id=plugin.get_id().decode(),
                )
            )

        selected_index = click.prompt(
            text="Enter the index",
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
            debug_enabled=self.debug,
            default_path=tempfile.mkdtemp().encode(),
        )
        self.core.purple_init()

        # Obtain the protocol
        protocol = self.protocol_selection()

        # Get username/password from user
        username = (
            self.username or click.prompt(text="Enter the username", type=str)
        ).encode()

        password = (
            self.password
            if self.password is not None
            else click.prompt(
                text="Enter the password",
                default="",
                type=str,
                hide_input=True,
                show_default=False,
            )
        ).encode()

        # Creates new account inside libpurple
        account = purple.Account.new(protocol, username)
        account.set_password(password)

        # Set account protocol options
        # info = {}
        # info[b'connect_server'] = b'talk.google.com'
        # info[b'port'] = b'443'
        # info[b'old_ssl'] = True
        # account.set_protocol_options(info)

        # Register signals
        self.core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONVERSATION_RECEIVED_IM_MSG,
            callback=self.cb_signal_conversation_received_im_msg,
        )
        self.core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONNECTION_SIGNING_ON,
            callback=self.cb_signal_connection_signing_on,
        )
        self.core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONNECTION_SIGNED_ON,
            callback=self.cb_signal_connection_signed_on,
        )
        self.core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONNECTION_CONNECTION_ERROR,
            callback=self.cb_signal_connection_error,
        )

        # Register callbacks
        self.core.add_callback(
            callback_name=purple.Callbacks.CALLBACK_REQUEST_REQUEST_INPUT,
            callback=self.cb_request_request_input,
        )

        # Enable account (connects automatically)
        account.set_enabled(True)

        self.loop()

    def menu_item_quit(self):
        raise KeyboardInterrupt

    def menu(self):
        click.echo(click.style("\nMenu", fg="green", bold=True))

        menu_items = [("Quit (ctrl+c)", self.menu_item_quit)]

        for (
            menu_item_index,
            (menu_item_description, menu_item_callback),
        ) in enumerate(menu_items):

            click.echo(
                "{prefix} {menu_item_description}".format(
                    prefix=click.style(
                        "[" + str(menu_item_index) + "]", bold=True
                    ),
                    menu_item_description=menu_item_description,
                )
            )

        selected_index = click.prompt(
            text="Enter the index",
            type=click.IntRange(min=0, max=len(menu_items) - 1),
        )

        menu_items[selected_index][1]()

    def loop(self):
        while True:
            try:
                self.core.iterate_main_loop()
                time.sleep(0.01)
            except KeyboardInterrupt:
                try:
                    self.menu()
                except KeyboardInterrupt:
                    click.echo("Quitting...")
                    self.core.destroy()
                    break


@click.command()
@click.option("--protocol_id", default=None, type=str)
@click.option("--username", default=None, type=str)
@click.option("--password", default=None, type=str)
@click.option("--debug", default=False, is_flag=True)
def main(*, debug, protocol_id, username, password):
    client = SimpleClient(
        debug=debug,
        protocol_id=protocol_id,
        username=username,
        password=password,
    )
    client.run()


if __name__ == "__main__":
    main()
