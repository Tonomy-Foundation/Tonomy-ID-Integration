# Tonomy-ID-integration

Developer environment to run Tonomy ID locally alongside a blockchain node, and the demo app.

All developers contributing to the project should check [Contributors Guide](./CONTRIBUTING.md) and first check the [Troubleshoot Guide](./TROUBLESHOOT.md) if you have issues installing or running.

## Environment details

| Category | Service | Production | Testnet | Staging |
|---|---|---|---|---|
| Apps | Demo | <https://demo.pangea.web4.world> | <https://demo.testnet.pangea.web4.world> | <https://demo.staging.tonomy.foundation> |
|  | Developers Console | <https://console.developers.pangea.web4.world> | <https://console.developers.testnet.pangea.web4.world> | <https://console.developers.staging.tonomy.foundation> |
|  | Accounts | <https://accounts.pangea.web4.world> | <https://accounts.testnet.pangea.web4.world> | <https://accounts.staging.tonomy.foundation> |
| Blockchain | chainId | 66d565f72ac08f8321a3036e2d92eea7f96ddc90599bdbfc2d025d810c74c248 | 8a34ec7df1b8cd06ff4a8abbaa7cc50300823350cadc59ab296cb00d104d2b8f | - |
|  | Block explorer | <https://explorer.pangea.web4.world> | <https://explorer.testnet.pangea.web4.world> | - |
|  | Bloks.io explorer | <https://local.bloks.io/?nodeUrl=https%3A%2F%2Fblockchain-api.pangea.web4.world&coreSymbol=LEOS&corePrecision=6&systemDomain=eosio> | <https://local.bloks.io/?nodeUrl=https%3A%2F%2Fblockchain-api-testnet.pangea.web4.world&coreSymbol=LEOS&corePrecision=6&systemDomain=eosio> | <https://local.bloks.io/?nodeUrl=https%3A%2F%2Fblockchain-api-staging.tonomy.foundation&coreSymbol=LEOS&corePrecision=6&systemDomain=eosio> |
|  | Blockchain API | <https://blockchain-api.pangea.web4.world> | <https://blockchain-api-testnet.pangea.web4.world> | <https://blockchain-api-staging.tonomy.foundation> |
|  | Hyperion API | <https://pangea.eosusa.io> | <https://test.pangea.eosusa.io> | - |
| Communication | Service | <https://communication.pangea.web4.world> | <https://communication.testnet.pangea.web4.world> | <https://communication.staging.tonomy.foundation> |
| Docs | Gitbook | <https://docs.pangea.web4.world> | - | <https://docs.staging.tonomy.foundation> |
| Wallet | Play store | <https://play.google.com/store/apps/details?id=foundation.tonomy.projects.unitedwallet> | <https://play.google.com/store/apps/details?id=foundation.tonomy.projects.pangeatestnet> | <https://play.google.com/store/apps/details?id=foundation.tonomy.projects.tonomyidstaging> |
|  | iTunes store | <https://apps.apple.com/us/app/united-citizens-wallet/id6482296993> | - | - |
|  | TestFlight | - | <https://testflight.apple.com/join/ou7KmYiE> | <https://testflight.apple.com/join/7Bdd9jdB> |

## Repositories

- [Tonomy ID](https://github.com/Tonomy-Foundation/Tonomy-ID) - Our expo (React Native) cross-platform mobile wallet for public & private Antelope blockchains.
  - [Directory Structure](https://learn.habilelabs.io/best-folder-structure-for-react-native-project-a46405bdba7)
- [SDK](https://github.com/Tonomy-Foundation/Tonomy-ID-SDK) - typescript library used in Tonomy ID to interact and call with the Antelope blockchain and services.
  - [Contracts](https://github.com/Tonomy-Foundation/Tonomy-Contracts) (inside SDK repo) - Antelope smart contracts to run the governance, identity, DAO, token and other ecosystem tools.
  - [Microservice](https://github.com/Tonomy-Foundation/Tonomy-Communication) (inside SDK repo) - nextjs peer to peer message broker for communication between different identities.
- Apps Websites
  - [Accounts](https://github.com/Tonomy-Foundation/Tonomy-App-Websites/tree/master/src/accounts) - A reactjs application to facilitate the SSO login with Tonomy ID to web apps
  - [Developers Console](https://github.com/Tonomy-Foundation/Tonomy-App-Websites/tree/master/src/developersConsole) - Tonomy Developers Console
  - [Demo](https://github.com/Tonomy-Foundation/Tonomy-App-Websites/tree/master/src/demo) - A reactjs application to show demo flows with Tonomy ID and Tonomy ID SSO

## Environment compatibility

- Linux debian distribution (Ubuntu 20.0.4 LTS used)

Hardware suggestions:

- 2 Gb RAM minimum
- 2 core minimum

## Dependencies

In case you have problems here is a list of the dependencies

- [Docker](http://docs.docker.com) v20.10+
- [Docker Compose](http://docs.docker.com/compose/) v1.29+
- [npm](https://www.npmjs.com/) with `corepack enabled` v20+. Suggested to install with [nvm](https://github.com/nvm-sh/nvm) v0.35+

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

## Test all

Run all the above steps up to and including `./app.sh install`, then:

- `./app.sh link`
- `./app.sh test`

## Environment variables

To run in staging or testnet or mainnet, use:

```bash
export NODE_ENV=staging
#or
export NODE_ENV=testnet
#or 
export NODE_ENV=production
#then
./app.sh start
```

To show logs within the SDK, use

```bash
export LOG=true
```

## Servers

See `./servers/README.md`
