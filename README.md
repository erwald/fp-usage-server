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
cd fp_usage_server

# Get all out-of-date dependencies
mix deps.get

# Compile the project files
mix compile
```

## Usage

1. Run `mix run --no-halt` to start the server. To stop the server, enter `Ctrl+C` and then `a` in the console.
2. Navigate to [localhost:4000/reports](http://localhost:4000/reports) to see a presentation of the collected usage statistics.

### Reporting usage statistics

Send a POST request to `/report` with a JSON body like so (for example):

```json
{
	"type": "openedPoll",
	"time": "1430819719.025690",
	"pollId": "7EA410C3-55FB-4A3D-B8DE-5E3BFCC5A608",
	"deviceId": "4280065409640689646"
}
```

## Dependencies

This project makes use of the following dependencies:

* **Plug** for handling HTTP requests.
* **Cowboy** as the web server.
* **Poison** for JSON parsing.
* **Timex** for parsing and formatting of dates.