FPUsageServer
=============

A server which receives usage statistics from the [FlashPoll](http://www.flashpoll.eu/en/home) iOS app and stores them locally.

> **Note:** Tracking usage statistics not be done for versions on the App Store, so as not to trespass on the users' privacy.

## Usage

> **Note:** this app is made for Elixir 1.0.4. It has only been tested on OS X Yosemite.

1. Install [Elixir](http://elixir-lang.org/install.html), for instance with Homebrew: `brew update`, then `brew install elixir`.
2. Clone this repo.
3. Run `mix deps.get` from the project folder to get all out of date dependencies.
4. Run `mix run --no-halt` to start the server. To stop the server, press `Ctrl+C` and then `a`.

## Dependencies

This project makes use of the following dependencies:

* **Plug** for handling HTTP requests.
* **Cowboy** as the web server.
* **Poison** for JSON parsing.