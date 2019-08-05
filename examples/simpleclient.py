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
        self.account = None

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

    def cb_signal_conversation_received_chat_msg(
        self, *, account, sender, message, conversation, flags
    ):
        click.echo(
            "{prefix} {sender} {message}".format(
                prefix=click.style(
                    "[RECEIVED-CHAT-MSG]", fg="green", bold=True
                ),
                sender=click.style(
                    "[{sender}]".format(sender=sender.decode()),
                    fg="yellow",
                    bold=True,
                ),
                message=message.decode(),
            )
        )

    def cb_signal_conversation_chat_joined(self, *, conversation):
        click.echo(
            "{prefix} Joined chat {chat_name}".format(
                prefix=click.style("[STATUS]", fg="blue", bold=True),
                chat_name=click.style(
                    conversation.get_name().decode(), bold=True
                ),
            )
        )

    def cb_signal_conversation_chat_left(self, *, conversation):
        click.echo(
            "{prefix} Left chat {chat_name}".format(
                prefix=click.style("[STATUS]", fg="blue", bold=True),
                chat_name=click.style(
                    conversation.get_name().decode(), bold=True
                ),
            )
        )

    def cb_signal_conversation_chat_join_failed(self):
        click.echo(
            "{prefix} Failed to join chat".format(
                prefix=click.style("[STATUS]", fg="blue", bold=True)
            )
        )

    def cb_signal_connection_signing_on(self, *, connection):
        click.echo(
            "{prefix} Account {account_name} is signing on...".format(
                prefix=click.style("[STATUS]", fg="blue", bold=True),
                account_name=click.style(
                    connection.get_account().get_username().decode(), bold=True
                ),
            )
        )

    def cb_signal_connection_signed_on(self, *, connection):
        click.echo(
            "{prefix} Account {account_name} signed on.".format(
                prefix=click.style("[STATUS]", fg="blue", bold=True),
                account_name=click.style(
                    connection.get_account().get_username().decode(), bold=True
                ),
            )
        )

    def cb_signal_connection_error(
        self, *, connection, description, short_description
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
            protocol = purple.Plugin.find_with_id(self.protocol_id.encode())
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

        protocol = purple.Plugin.find_with_id(selected_plugin.get_id())

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
        self.account = purple.Account.new(protocol, username)
        self.account.set_password(password)

        ######################
        ## Register signals ##
        ######################

        ## Conversation
        self.core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONVERSATION_RECEIVED_IM_MSG,
            callback=self.cb_signal_conversation_received_im_msg,
        )
        self.core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONVERSATION_RECEIVED_CHAT_MSG,
            callback=self.cb_signal_conversation_received_chat_msg,
        )
        self.core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONVERSATION_CHAT_JOINED,
            callback=self.cb_signal_conversation_chat_joined,
        )
        self.core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONVERSATION_CHAT_LEFT,
            callback=self.cb_signal_conversation_chat_left,
        )
        self.core.signal_connect(
            signal_name=purple.Signals.SIGNAL_CONVERSATION_CHAT_JOIN_FAILED,
            callback=self.cb_signal_conversation_chat_join_failed,
        )

        ## Connection
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

        ########################
        ## Register callbacks ##
        ########################
        self.core.add_callback(
            callback_name=purple.Callbacks.CALLBACK_REQUEST_REQUEST_INPUT,
            callback=self.cb_request_request_input,
        )

        # Enable account (connects automatically)
        self.account.set_enabled(True)

        self.loop()

    def menu_item_quit(self):
        raise KeyboardInterrupt

    def menu_list_ims(self):
        ims = purple.Conversation.get_ims()
        if ims:
            click.echo(click.style("IMs:", bold=True))
            for im_index, im in enumerate(ims):
                click.echo("{im_index}. {im}".format(im_index=im_index, im=im))
        else:
            click.echo(click.style("There are no IMS to show.", bold=True))

    def menu_join_im(self):
        im_name = click.prompt("Enter im name", type=str).encode()
        conversation = purple.Conversation.new(
            type=purple.ConversationType.CONVERSATION_TYPE_IM,
            account=self.account,
            name=im_name,
        )

    def menu_send_im(self):
        im_name = click.prompt("Enter im name", type=str).encode()
        conversation = purple.Conversation.new(
            type=purple.ConversationType.CONVERSATION_TYPE_IM,
            account=self.account,
            name=im_name,
        )
        im = conversation.get_im_data()
        message = click.prompt("Message", type=str).encode()
        im.send(message)

    def menu_list_chats(self):
        chats = purple.Conversation.get_chats()
        if chats:
            click.echo(click.style("Chats:", bold=True))
            for chat_index, chat in enumerate(chats):
                click.echo(
                    "{chat_index}. {chat}".format(
                        chat_index=chat_index, chat=chat
                    )
                )
        else:
            click.echo(click.style("There are no Chats to show.", bold=True))

    def get_chat_data(self):
        connection = self.account.get_connection()
        plugin = purple.Plugin.find_with_id(self.account.get_protocol_id())
        protocol_info = plugin.get_protocol_info()
        chat_entries = protocol_info.get_chat_info(connection)

        chat_data = dict()

        for chat_entry in chat_entries:
            identifier = chat_entry.get_identifier()
            is_required = chat_entry.get_required()
            _input = click.prompt(
                "Enter {identifier} ({required})".format(
                    identifier=identifier.decode(),
                    required="required" if is_required else "not required",
                ),
                type=str,
                default="" if is_required else None,
                show_default=False,
            ).encode()

            if _input:
                chat_data[identifier] = _input

        return chat_data

    def menu_join_chat(self):
        chat_data = self.get_chat_data()

        purple.Server.join_chat(self.account.get_connection(), chat_data)

    def menu(self):
        click.echo(click.style("\nMenu", fg="green", bold=True))

        menu_items = [
            ("Quit (ctrl+c)", self.menu_item_quit),
            ("Continue (Exit the menu)", lambda *args: None),
            ("List IMs", self.menu_list_ims),
            ("List Chats", self.menu_list_chats),
            ("Join IM", self.menu_join_im),
            ("Join Chat", self.menu_join_chat),
            ("Send IM", self.menu_send_im),
        ]

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

        return menu_items

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
