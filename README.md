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

* Rails v6.1.4.1 (but likely to work on any v6+ build of Rails, possibly even earlier?)

* Ruby v2.7.0 (At least any 2.7.? version, and most likely 2.? version of Ruby should work with minimal adjustment if your local machine is picky about Ruby version)

* Sqlite3 v1.4

To create a local development copy for testing, first you will also require a copy of the relevant Disco Elysium game data in a sqlite3 database. While we have our own script to extract the data from the JSON format it can be exported in, it requires a lot of hand holding, and HTMLBanjo's [Disco Courier](https://github.com/htmlbanjo/disco-courier) may be of use to build an appropriate database [TODO: describe what's an "appropriate structure" here]

Clone this repo using your preferred method. Once in the cloned directory, open your terminal and start your rails server with: ''' rails s '''

<h2>Next Steps</h2>

Work is continuing to improve upon:

* 1: Support for additional languages 

* 2: Improvements to layouts, usability etc

* 3: Technical Debts, optimisation and performance [Significant Progress made!]

<h2>Comments, contributions, questions</h2>

This project is primarily developed by MorgueXIIV, with contributions from pieartsy (The wonderful CSS stylesheets) and Sphinx111 (User Experience and Performance).

If there are any questions or comments, please feel free to contact "Boring Cop / Sorry Cop Morgue" on the official Disco Elysium discord.

<h2>Disclaimers</h2>

No copyright is claimed or implied over Disco Elysium or any of its characters and content, which is all wholly owned by ZA/UM. If you work at / represent ZA/UM and consider this use of their intellectual property to be unacceptable, that's fine and I will respect that. Please contact "Boring Cop / Sorry Cop Morgue" on the official Discord for a boring apology and to discuss removal / any alternative terms under which it might be acceptable. No malice is intended, and it is being hosted in the knowledge that the ZA/UM team have acknowledged and welcomed similar projects such as [Xyrilyn's Disco Reader](https://disco-reader.gitlab.io/disco-reader/#/) in official ZA/UM announcements.

Excluding any portions of the code that due to their relationship to the structure of the aforementioned material cannot be considered original work, the code is hereby distributed with uh, let's say the MIT licence, like Rails itself. 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
