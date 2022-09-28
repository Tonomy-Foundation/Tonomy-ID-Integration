# Tonomy-ID-integration

Developer environment to run Tonomy ID locally alongside a blockchain node, and the demo app.

# Enviroment

## Dependancies

- Linux debian distribution (Ubuntu 20.0.4 LTS used)
- [Docker](http://docs.docker.com) v20.10+
- [Docker Compose](http://docs.docker.com/compose/) v1.29+
- [watchman](https://facebook.github.io/watchman/) v4.9.0+
- [npm](https://www.npmjs.com/) v16.4-17.0. Suggested to install with [nvm](https://github.com/nvm-sh/nvm) v0.35+
- [expo-cli](https://expo.dev/) v5.2+ installed globally by `npm`
- [pm2](https://pm2.io) v5.5+ installed globally by `npm`
- [tsdx](https://tsdx.io) v0.14.1 installed globally by `npm`
- [wml](https://www.wml.io) v0.0.83+ installed globally by `npm`

Check `./scripts/install_prerequisits.sh` for way to install this on Ubuntu 20.0.4.

## Integration
[Integration Repo](https://github.com/Tonomy-Foundation/Tonomy-ID-Integration)

## Run

Follow these steps one by one & read them carefully. Do not rush through it.
* Clone the repo
* `git checkout development`
* go through [this](https://github.com/Tonomy-Foundation/Tonomy-ID-Integration/blob/development/scripts/install_prerequisits.sh) script, line by line, and install the dependencies you don't have.
* `./app.sh` and read what each command does
* `./app.sh gitinstall`
* `./app.sh install`
* `./app.sh init`
* Now, you can do one of the following;
* `./app.sh start`
* Check out the links shown
* Scan the QR code with the expo app
* `./app.sh test` or `./app.sh test all`
* `./app.sh log eosio`
* `./app.sh stop` or `./app.sh reset` or `./app.sh reset all`

For visual aid, a recording of a full walkthrough of the setup with a junior dev can be found [here](https://www.loom.com/share/f44be75ce80044a08a73c53ea64a3afd)

A recording which explains how it all works, and how to run tests can be found [here](https://www.loom.com/share/8566b834759742309ebc96c74e955767)

## Repositories

* [Tonomy ID](https://github.com/Tonomy-Foundation/Tonomy-ID) - Our React Native cross-platform mobile wallet for public & private EOSIO blockchains.
* [Directory Structure](https://learn.habilelabs.io/best-folder-structure-for-react-native-project-a46405bdba7)
* [SDK](https://github.com/Tonomy-Foundation/Tonomy-ID-SDK) - used in Tonomy ID to interact and call with the EOSIO blockchain and services.
* [Contracts](https://github.com/Tonomy-Foundation/Tonomy-Contracts) - Smart contracts to run the governance, identity, DAO, token and other ecosystem tools.
* [Demo](https://github.com/Tonomy-Foundation/Tonomy-ID-Demo) - A reactjs application to show demo flows with Tonomy ID
