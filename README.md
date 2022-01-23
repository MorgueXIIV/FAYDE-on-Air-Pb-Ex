# README

![](https://i.imgur.com/TbF6PLl.png)

<h2>General Overview</h2>

Fayde-on-Air is a community-built online dialogue-browser for the game [Disco Elysium](https://discoelysium.com), allowing visitors to search for specific snippets of conversations, and then follow that conversation forwards or backwards.

The project is designed to be hosted online, using a simple installation of Ruby on Rails. Fayde-on-air also boasts reliable functionality on mobile browsers, and a low-resource interface.

<h2>How it Works</h2>

The Fayde-on-air app sits on top of a Relational Database containing all of the game's dialogue, and other objects linking each piece of Dialogue with those around it.

<h4>What are HUBs?</h4>
Internally, the game refers to "linking" objects between pieces of dialogue as "HUBs". these specify how the player can move from one piece of dialogue to another. As an example, in the screenshot above, you can see Hub "21" contains two options for the player to click on, moving them to the next stage of dialogue. HUBs can also feed output to the game, showing how the game tracks the player's choices as they play. Fayde gives users a "look under the hood" at these hidden variables.

<h4>Searching:</h4>
When the user searches for a piece of dialogue, Fayde fetches any objects containing that dialogue from the database, and lists them. The user can choose to enter the conversation at the point of the dialogue searched for, or start from the beginning of that conversation.

<h4>Browsing Conversations:</h4>
Once a user has selected the conversation they want to follow, Fayde displays a sequence of dialogue, showing all the previous pieces of dialogue from the start of that conversation, onwards to the next choice after the user's chosen line. The user can click on these choices to move the conversation along just as they would in game, but without the obstacle of skill checks.

<h2>Installation</h2>

FAYDE-on-air was built primarily for Linux systems, but is likely to work on Windows systems with minimal changes. Fayde-on-air has the following dependencies:

* Rails v6.1.4.1 (but likely to work on any v6+ build of Rails)

* Ruby v2.7.0

* Sqlite3 v1.4

You will also require a copy of the Disco Elysium dialogue in a sqlite3 database. (Database instructions???)

Clone this repo using your preferred method. Once in the cloned directory, open your terminal and start your rails server with: ''' rails s '''

If hosting for public / external access, start your rails server with ''' rails s -b 0.0.0.0 -p 80 '''. ""-b 0.0.0.0" instructs rails to bind to any valid ip address, -p tells rails which port to listen on. For websites this will usually be port 80.

Ensure your firewall policies allow access to your machine at this port.

Your rails server will now be accepting external connections. If you want the server to persist after you close your console window, consider using additional commands like [nohup or disown](https://unix.stackexchange.com/questions/3886/difference-between-nohup-disown-and)

<h2>Next Steps</h2>

Work is continuing to improve upon:

* 1: Improvements to layouts, usability etc

* 2: Formatting of Conversation Browser

* 3: Technical Debts, optimisation and performance [Significant Progress made!]

<h2>Comments, contributions, questions</h2>

This project is primarily developed by MorgueXIIV, with contributions from pieartsy (The wonderful CSS stylesheets) and Sphinx111 (User Experience and Performance).

If there are any questions or comments, please feel free to contact "Boring Cop / Sorry Cop Morgue" on the official Disco Elysium discord.

<h2>Licensing and Copyright</h2>

No copyright is claimed or implied over Disco Elysium or any of its characters and content, which is all wholly owned by ZA/UM. If you work at / represent Za/um and consider this use of their intellectual property to be unacceptable, that's fine and I will respect that. Please contact "Boring Cop / Sorry Cop Morgue" on the official Discord for a boring apology and to discuss removal / any alternative terms under which it might be acceptable. No malice is intended, and it is being hosted in the knowledge that the Za/um team have acknowledged and welcomed similar projects such as Xyrilyn's Disco Reader in official Za/um announcements.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You can view a copy of the GNU General Public License at <https://www.gnu.org/licenses/>.
