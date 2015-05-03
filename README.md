FPUsageServer
=============

A server which receives usage statistics from the [FlashPoll](http://www.flashpoll.eu/en/home) iOS app and stores them locally.

> **Warning:** tracking usage statistics should not be done for versions on the App Store, so as not to trespass on the users' privacy.

## Installation

> **Note:** this program has only been tested with Elixir 1.0.4, Erlang 17.5 and on OS X Yosemite.

1. Install [Elixir](http://elixir-lang.org/install.html), for instance with Homebrew: `brew update`, then `brew install elixir`.
2. Clone this repo.
3. Run `mix deps.get` from the project folder to get all out of date dependencies.
4. *(If necessary)* run `mix compile` to compile the project files.

## Usage

1. Run `mix run --no-halt` to start the server. To stop the server, enter `Ctrl+C` and then `a` in the console.
2. Go to `localhost:4000/reports` to see a presentation of the collected usage statistics.

## Dependencies

This project makes use of the following dependencies:

* **Plug** for handling HTTP requests.
* **Cowboy** as the web server.
* **Poison** for JSON parsing.
* **Timex** for parsing and formatting of dates.