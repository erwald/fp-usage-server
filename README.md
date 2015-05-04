FPUsageServer
=============

A server which receives usage statistics from the [FlashPoll](http://www.flashpoll.eu/en/home) iOS app and stores them locally.

> **Warning:** tracking usage statistics should not be done for versions on the App Store, so as not to trespass on the users' privacy.

## Installation

> **Note:** this program has only been tested with Elixir 1.0.4, Erlang 17.5 and on OS X Yosemite.

First, install [Elixir](http://elixir-lang.org/install.html), for instance with Homebrew:

```sh
# Update Homebrew
brew update

# Install Elixir
brew install elixir
```

Then, clone this repo and run the following from within the project folder:

```sh
# Get all out-of-date dependencies
mix deps.get

# (If necessary) compile the project files
mix compile
```

## Usage

1. Run `mix run --no-halt` to start the server. To stop the server, enter `Ctrl+C` and then `a` in the console.
2. Go to `localhost:4000/reports` to see a presentation of the collected usage statistics.

## Dependencies

This project makes use of the following dependencies:

* **Plug** for handling HTTP requests.
* **Cowboy** as the web server.
* **Poison** for JSON parsing.
* **Timex** for parsing and formatting of dates.