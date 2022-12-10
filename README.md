# Tonomy-ID-integration

Developer environment to run Tonomy ID locally alongside a blockchain node, and the demo app.

All developers contributing to the project should check [Contributors Guide](./CONTRIBUTING.md) and first check the [Troubleshoot Guide](./TROUBLESHOOT.md) if you have issues installing or running.

## Repositories

- [Tonomy ID](https://github.com/Tonomy-Foundation/Tonomy-ID) - Our React Native cross-platform mobile wallet for public & private EOSIO blockchains.
  - [Directory Structure](https://learn.habilelabs.io/best-folder-structure-for-react-native-project-a46405bdba7)
- [SDK](https://github.com/Tonomy-Foundation/Tonomy-ID-SDK) - used in Tonomy ID to interact and call with the EOSIO blockchain and services.
- [Contracts](https://github.com/Tonomy-Foundation/Tonomy-Contracts) - Smart contracts to run the governance, identity, DAO, token and other ecosystem tools.
- [SSO-Demo](https://github.com/Tonomy-Foundation/Tonomy-ID-Demo) - A reactjs application to show demo flows with Tonomy ID
- [Market.com](https://github.com/Tonomy-Foundation/Tonomy-ID-Demo-market.com.git) - A reactjs application to show demo flows with Tonomy ID and Tonomy ID SSO

## Environment compatibility

- Linux debian distribution (Ubuntu 20.0.4 LTS used)

Hardware suggestions:

- 2 Gb RAM minimum
- 2 core minimum

## Dependancies

In case you have problems here is a list of the dependencies

- [Docker](http://docs.docker.com) v20.10+
- [Docker Compose](http://docs.docker.com/compose/) v1.29+
- [npm](https://www.npmjs.com/) v16.4-17.0. Suggested to install with [nvm](https://github.com/nvm-sh/nvm) v0.35+
- [pm2](https://pm2.io) v5.5+ installed globally by `npm`

Check out the file `./scripts/install_prerequisits.sh`. This can be used as a guide to install all dependancies on an Ubuntu 18+ machine. Run the script line-by-line, as sometimes you need to exit terminal or restart your machine to continue.

### Pre-run (one time)

In the `Tonomy-ID` repository you need to set up the expo build and install it on your phone. See instructions here

https://github.com/Tonomy-Foundation/Tonomy-ID/tree/development#pre-run-build-first-time-and-each-time-new-rn-only-packages-are-installed

## Run

Follow these steps one by one & read them carefully. Do not rush through it.

- Clone the repo
- `git checkout development`
- `./app.sh` and read what each command does
- `./app.sh gitinit`
- `./app.sh install`
- `./app.sh init`
- Now, you can do one of the following;
- `./app.sh start` or
- `./app.sh start all` to start all services (including the websites)
  - Open the installed Tonomy ID app downloaded from [https://expo.dev](https://expo.dev) (See #pre-run-one-time)
  - Call `getip` and then input the "Enter URL manually" `http://{ip fro getip}:8081
  - Check out the links shown
- `./app.sh test` or `./app.sh test all`
- `./app.sh log eosio`
- `./app.sh stop` or `./app.sh reset` or `./app.sh reset all`

See [TROUBLESHOOT.md](./TROUBLESHOOT.md) to fix common issues when running the app.

For visual aid, a recording of a full walkthrough of the setup with a junior dev can be found [here](https://www.loom.com/share/f44be75ce80044a08a73c53ea64a3afd)

A recording which explains how it all works, and how to run tests can be found [here](https://www.loom.com/share/8566b834759742309ebc96c74e955767)

## Environment variables

To run in staging or production, use:

```bash
export NODE_ENV=staging
#or
export NODE_ENV=production
#then
./app.sh start
```

## Staging server

See `./staging/staging.sh`
