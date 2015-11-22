# Multiboard

Dashboard whose purpose is to live on EisTVs.

![Screenshot](/screenshot.png?raw=true)

## Installing

To install all dependencies, just run the following command

    bundle install

## Running

To launch the server, just run the following command

    bundle exec ruby main.rb

By default, the server will run on port 4567.

### Tokens

The server depends on SNCF and OpenWeatherMap APIs, both
require tokens, once you have your tokens, follow these
steps:

* Create a `sncf_token` file at the root of the project
* Paste the login on the first line, the password on
the second

* Create a `owm_token` file at the root of the project
* Paste the token on the first line


You're ready to rock!

