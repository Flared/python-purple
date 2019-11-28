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
from typing import Optional
from typing import Dict
from typing import Any
from typing import Callable
from typing import Tuple
from typing import List

import click
import tempfile
import getpass
import sys
import os
import time

import purple
from purple import PurpleClient


class SimpleClient:
    def __init__(
        self,
        *,
        debug: bool,
        protocol_id: Optional[str] = None,
        username: Optional[str] = None,
        password: Optional[str] = None,
    ) -> None:
        self.debug: bool = debug

        self.account: Optional[purple.Account] = None

        self.purple_client = PurpleClient()

        self.protocol_id = protocol_id
        self.username = username
        self.password = password

    def _get_account(self) -> purple.Account:
        account = self.account
        if not account:
            raise Exception("No account!")
        return account

    def cb_signal_conversation_received_im_msg(
        self,
        *,
        account: purple.Account,
        sender: bytes,
        message: bytes,
        conversation: purple.Conversation,
        flags: Any,
    ) -> None:
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
        self,
        *,
        account: purple.Account,
        sender: bytes,
        message: bytes,
        conversation: purple.Conversation,
        flags: Any,
    ) -> None:
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

    def cb_signal_conversation_chat_joined(
        self, *, conversation: purple.Conversation
    ) -> None:
        click.echo(
            "{prefix} Joined chat {chat_name}".format(
                prefix=click.style("[STATUS]", fg="blue", bold=True),
                chat_name=click.style(
                    conversation.get_name().decode(), bold=True
                ),
            )
        )

    def cb_signal_conversation_chat_left(
        self, *, conversation: purple.Conversation
    ) -> None:
        click.echo(
            "{prefix} Left chat {chat_name}".format(
                prefix=click.style("[STATUS]", fg="blue", bold=True),
                chat_name=click.style(
                    conversation.get_name().decode(), bold=True
                ),
            )
        )

    def cb_signal_conversation_chat_join_failed(self) -> None:
        click.echo(
            "{prefix} Failed to join chat".format(
                prefix=click.style("[STATUS]", fg="blue", bold=True)
            )
        )

    def cb_signal_connection_signing_on(self, *, connection: purple.Connection):
        click.echo(
            "{prefix} Account {account_name} is signing on...".format(
                prefix=click.style("[STATUS]", fg="blue", bold=True),
                account_name=click.style(
                    connection.get_account().get_username().decode(), bold=True
                ),
            )
        )

    def cb_signal_connection_signed_on(
        self, *, connection: purple.Connection
    ) -> None:
        click.echo(
            "{prefix} Account {account_name} signed on.".format(
                prefix=click.style("[STATUS]", fg="blue", bold=True),
                account_name=click.style(
                    connection.get_account().get_username().decode(), bold=True
                ),
            )
        )

    def cb_signal_connection_error(
        self,
        *,
        connection: purple.Connection,
        description: bytes,
        short_description: bytes,
    ) -> None:
        click.echo(
            "{prefix} Connection error for {account_name}: {short_description}: {description}".format(
                prefix=click.style("[ERROR]", fg="red", bold=True),
                account_name=click.style(
                    connection.get_account().get_username().decode(), bold=True
                ),
                short_description=short_description.decode(),
                description=description.decode(),
            )
        )

    def cb_request_request_input(
        self,
        *,
        title: bytes,
        primary: bytes,
        secondary: bytes,
        default_value: bytes,
        multiline: bool,
        masked: bool,
        hint: bytes,
        ok_text: bytes,
        ok_cb: Callable,
        cancel_text: bytes,
        cancel_cb: Callable,
        account: purple.Account,
        who: bytes,
        conversation: purple.Conversation,
    ) -> None:
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

    def protocol_selection(self) -> purple.Plugin:
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

    def run(self) -> None:
        # Sets initial parameters
        self.purple_client.do_loop()

        # Obtain the protocol
        protocol = self.protocol_selection()

        # Get username/password from user
        username: bytes = (
            self.username or click.prompt(text="Enter the username", type=str)
        ).encode()

        password: bytes = (
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
        account: purple.Account = purple.Account.new(protocol, username)
        self.account = account
        account.set_password(password)

        ###############################
        ## Register Signal Callbacks ##
        ###############################

        ## Conversation
        self.purple_client.set_cb_signal_conversation_received_im_msg(
            self.cb_signal_conversation_received_im_msg
        )
        self.purple_client.set_cb_signal_conversation_received_chat_msg(
            self.cb_signal_conversation_received_chat_msg
        )
        self.purple_client.set_cb_signal_conversation_chat_joined(
            self.cb_signal_conversation_chat_joined
        )
        self.purple_client.set_cb_signal_conversation_chat_left(
            self.cb_signal_conversation_chat_left
        )
        self.purple_client.set_cb_signal_conversation_chat_join_failed(
            self.cb_signal_conversation_chat_join_failed
        )

        ## Connection
        self.purple_client.set_cb_signal_connection_signing_on(
            self.cb_signal_connection_signing_on
        )
        self.purple_client.set_cb_signal_connection_signed_on(
            self.cb_signal_connection_signed_on
        )
        self.purple_client.set_cb_signal_connection_error(
            self.cb_signal_connection_error
        )

        ########################
        ## Register callbacks ##
        ########################
        self.purple_client.set_cb_request_request_input(
            self.cb_request_request_input
        )

        # Enable account (connects automatically)
        account.set_enabled(True)

        self.loop()

    def menu_item_quit(self) -> None:
        raise KeyboardInterrupt

    def menu_list_ims(self) -> None:
        ims = purple.Conversation.get_ims()
        if ims:
            click.echo(click.style("IMs:", bold=True))
            for im_index, im in enumerate(ims):
                click.echo("{im_index}. {im}".format(im_index=im_index, im=im))
        else:
            click.echo(click.style("There are no IMS to show.", bold=True))

    def menu_join_im(self) -> None:
        im_name = click.prompt("Enter im name", type=str).encode()
        conversation = purple.Conversation.new(
            type=purple.ConversationType.CONVERSATION_TYPE_IM,
            account=self.account,
            name=im_name,
        )

    def menu_send_im(self) -> None:
        im_name = click.prompt("Enter im name", type=str).encode()
        conversation = purple.Conversation.new(
            type=purple.ConversationType.CONVERSATION_TYPE_IM,
            account=self.account,
            name=im_name,
        )
        im = conversation.get_im_data()
        message: bytes = click.prompt("Message", type=str).encode()
        im.send(message)

    def menu_list_chats(self) -> None:
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

    def get_chat_data(self, *, prompt_required_only=False) -> Dict:
        connection = self._get_account().get_connection()
        plugin = purple.Plugin.find_with_id(
            self._get_account().get_protocol_id()
        )
        protocol_info = plugin.get_protocol_info()
        chat_entries = protocol_info.get_chat_info(connection)

        chat_data = dict()

        for chat_entry in chat_entries:
            identifier = chat_entry.get_identifier()
            is_required = chat_entry.get_required()

            if not is_required and prompt_required_only:
                continue

            _input = click.prompt(
                "Enter {identifier} ({required})".format(
                    identifier=identifier.decode(),
                    required="required" if is_required else "not required",
                ),
                type=str,
                default=None if is_required else "",
                show_default=False,
            ).encode()

            if _input:
                chat_data[identifier] = _input

        return chat_data

    def menu_join_chat(self) -> None:
        chat_data = self.get_chat_data()

        purple.Server.join_chat(self._get_account().get_connection(), chat_data)

    def menu_send_chat(self) -> None:
        chat_name = click.prompt("Enter chat name", type=str).encode()

        for chat_conv in purple.Conversation.get_chats():
            if chat_conv.get_name() == chat_name:
                chat = chat_conv.get_chat_data()
                message = click.prompt("Message", type=str).encode()
                chat.send(message)
                break
        else:
            click.echo(
                "Could not find chat named {chat_name}".format(
                    chat_name=chat_name
                )
            )

    def menu(self) -> None:
        click.echo(click.style("\nMenu", fg="green", bold=True))

        menu_items = [
            ("Quit (ctrl+c)", self.menu_item_quit),
            ("Continue (Exit the menu)", lambda *args: None),
            ("List IMs", self.menu_list_ims),
            ("List Chats", self.menu_list_chats),
            ("Join IM", self.menu_join_im),
            ("Join Chat", self.menu_join_chat),
            ("Send IM", self.menu_send_im),
            ("Send Chat", self.menu_send_chat),
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

    def loop(self) -> None:
        while True:
            try:
                self.purple_client.do_loop()
                time.sleep(0.01)
            except KeyboardInterrupt:
                try:
                    self.menu()
                except KeyboardInterrupt:
                    click.echo("Quitting...")
                    self.purple_client.close()
                    break


@click.command()
@click.option("--protocol_id", default=None, type=str)
@click.option("--username", default=None, type=str)
@click.option("--password", default=None, type=str)
@click.option("--debug", default=False, is_flag=True)
def main(
    *, debug: bool, protocol_id: str, username: str, password: str
) -> None:
    client = SimpleClient(
        debug=debug,
        protocol_id=protocol_id,
        username=username,
        password=password,
    )
    client.run()


if __name__ == "__main__":
    main()
