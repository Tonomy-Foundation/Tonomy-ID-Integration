# Tonomy-ID-integration

Developer environment to run Tonomy ID locally alongside a blockchain node, and the demo app.

All developers contributing to the project should check [Contributors Guide](./CONTRIBUTING.md) and first check the [Troubleshoot Guide](./TROUBLESHOOT.md) if you have issues installing or running.

## Try it out here

See `./staging`

- Demo market.com: <https://demo.staging.tonomy.foundation>
- SSO website: <https://accounts.staging.tonomy.foundation>
- Tonomy login website: <https://tonomy-id-staging.tonomy.foundation>
- Block explorer: <https://local.bloks.io/?nodeUrl=https%3A%2F%2Fblockchain-api-staging.tonomy.foundation&systemDomain=eosio>
- Blockchain API: <https://blockchain-api-staging.tonomy.foundation>
- Communication Service: <https://communication.staging.tonomy.foundation>
- Docs: <https://docs.staging.tonomy.foundation>
- Tonomy ID:
  - Play store: <https://play.google.com/store/apps/details?id=foundation.tonomy.projects.tonomyidstaging>
  - iTunes store: <https://apps.apple.com/us/app/tonomy-id-demo/id1663471436>
- Testers issue reporting sheet: <https://tonomy-foundation.notion.site/Tonomy-ID-Testing-Procedure-4a084f9e43df413695425289ca017446?pvs=4>

## Testing environment

See `./demo`

- Demo market.com: <https://demo.demo.tonomy.foundation>
- SSO website: <https://accounts.demo.tonomy.foundation>
- Tonomy login website: <https://tonomy-id-demo.tonomy.foundation>
- Block explorer: <https://local.bloks.io/?nodeUrl=https%3A%2F%2Fblockchain-api-demo.tonomy.foundation&systemDomain=eosio>
- Blockchain API: <https://blockchain-api-demo.tonomy.foundation>
- Communication Service: <https://communication.demo.tonomy.foundation>
- Docs: <https://docs.tonomy.foundation>
- Tonomy ID:
  - Play store: <https://play.google.com/store/apps/details?id=foundation.tonomy.projects.tonomyidstaging>
  - iTunes store: <https://apps.apple.com/us/app/tonomy-id-demo/id1663471436>
    - TestFlight: TODO
- Testers issue reporting sheet: <https://docs.google.com/spreadsheets/d/1_LtUzEV8aiw5OYYuEHnQd-Mf0Jpwd4jWEUZgnJqI9ME/edit#gid=1902629582>

## Repositories

- [Tonomy ID](https://github.com/Tonomy-Foundation/Tonomy-ID) - Our expo (React Native) cross-platform mobile wallet for public & private Antelope blockchains.
  - [Directory Structure](https://learn.habilelabs.io/best-folder-structure-for-react-native-project-a46405bdba7)
- [SDK](https://github.com/Tonomy-Foundation/Tonomy-ID-SDK) - typescript library used in Tonomy ID to interact and call with the Antelope blockchain and services.
  - [Contracts](https://github.com/Tonomy-Foundation/Tonomy-Contracts) (inside SDK repo) - Antelope smart contracts to run the governance, identity, DAO, token and other ecosystem tools.
  - [Microservice](https://github.com/Tonomy-Foundation/Tonomy-Communication) (inside SDK repo) - nextjs peer to peer message broker for communication between different identities.
- [Demo](https://github.com/Tonomy-Foundation/Tonomy-App-Websites/tree/master/src/demo) - A reactjs application to facilitate the SSO login with Tonomy ID to web apps
- [SSO Login](https://github.com/Tonomy-Foundation/Tonomy-App-Websites/tree/master/src/sso) - A reactjs application to show demo flows with Tonomy ID and Tonomy ID SSO

## Environment compatibility

- Linux debian distribution (Ubuntu 20.0.4 LTS used)

Hardware suggestions:

- 2 Gb RAM minimum
- 2 core minimum

## Dependencies

In case you have problems here is a list of the dependencies

- [Docker](http://docs.docker.com) v20.10+
- [Docker Compose](http://docs.docker.com/compose/) v1.29+
- [npm](https://www.npmjs.com/) v18.12.1. Suggested to install with [nvm](https://github.com/nvm-sh/nvm) v0.35+
- [pm2](https://pm2.io) v5.5+ installed globally by `npm`
- [mkdocs](https://www.mkdocs.org) with [material](https://squidfunk.github.io/mkdocs-material) theme

Check out the file `./scripts/install_prerequisits.sh`. This can be used as a guide to install all dependencies on an Ubuntu 18+ machine. Run the script line-by-line, as sometimes you need to exit terminal or restart your machine to continue.

### Pre-run (one time)

In the `Tonomy-ID` repository you need to set up the expo build and install it on your phone. See instructions here

<https://github.com/Tonomy-Foundation/Tonomy-ID/tree/development#pre-run-build-first-time-and-each-time-new-rn-only-packages-are-installed>

## Run

Follow these steps one by one & read them carefully. Do not rush through it.

- Clone the repo
- `git checkout development`
- `./app.sh` and read what each command does
- `./app.sh gitinit`
- `./app.sh install`
- `./app.sh init`
- Now, you can do one of the following;
- `./app.sh start`
  - Open the installed Tonomy ID app downloaded from [https://expo.dev](https://expo.dev) (See #pre-run-one-time)
  - Check out the links shown
- `./app.sh log antelope`
- `./app.sh stop` or `./app.sh reset` or `./app.sh reset all`

See [TROUBLESHOOT.md](./TROUBLESHOOT.md) to fix common issues when running the app.

## Environment variables

To run in staging or demo, use:

```bash
export NODE_ENV=staging
#or
export NODE_ENV=demo
#then
./app.sh start
```

To show logs within the SDK, use

```bash
export LOG=true
```

## Staging server

See `./staging/staging.sh`

## Demo server

See `./demo/demo.sh`
