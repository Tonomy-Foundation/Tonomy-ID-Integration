# Tonomy-ID-integration

Developer environment to run Tonomy ID locally alongside a blockchain node, and the demo app.

Check the [CONTRIBUTING.md](./CONTRIBUTING.md) for developers contributing to this project.

## Repositories

- [Tonomy ID](https://github.com/Tonomy-Foundation/Tonomy-ID) - Our React Native cross-platform mobile wallet for public & private EOSIO blockchains.
  - [Directory Structure](https://learn.habilelabs.io/best-folder-structure-for-react-native-project-a46405bdba7)
- [SDK](https://github.com/Tonomy-Foundation/Tonomy-ID-SDK) - used in Tonomy ID to interact and call with the EOSIO blockchain and services.
- [Contracts](https://github.com/Tonomy-Foundation/Tonomy-Contracts) - Smart contracts to run the governance, identity, DAO, token and other ecosystem tools.
- [Demo](https://github.com/Tonomy-Foundation/Tonomy-ID-Demo) - A reactjs application to show demo flows with Tonomy ID

## Environment compatibility

- Linux debian distribution (Ubuntu 20.0.4 LTS used)

## Dependancies

In case you have problems here is a list of the dependencies

- [Docker](http://docs.docker.com) v20.10+
- [Docker Compose](http://docs.docker.com/compose/) v1.29+
- [watchman](https://facebook.github.io/watchman/) v4.9.0+
- [npm](https://www.npmjs.com/) v16.4-17.0. Suggested to install with [nvm](https://github.com/nvm-sh/nvm) v0.35+
- [expo-cli](https://expo.dev/) v5.2+ installed globally by `npm`
- [pm2](https://pm2.io) v5.5+ installed globally by `npm`
- [tsdx](https://tsdx.io) v0.14.1 installed globally by `npm`
- [wml](https://www.wml.io) v0.0.83+ installed globally by `npm`
- [Eas-cli](https://docs.expo.dev/workflow/expo-cli/) v2.2.1 globally installed with npm

## Run

Follow these steps one by one & read them carefully. Do not rush through it.

- Clone the repo
- `git checkout development`
- `./app.sh` and read what each command does
- `./app.sh gitinit`
- `./app.sh install`
- Now run the Pre-run setup below***
- `./app.sh init`
- Now, you can do one of the following;
- `./app.sh start`
  - Check out the links shown
  - Scan the QR code with the expo app
- `./app.sh test` or `./app.sh test all`
- `./app.sh log eosio`
- `./app.sh stop` or `./app.sh reset` or `./app.sh reset all`

If you see errors related to missing pages, then try `pm2 restart id`

To run in staging or production, use:

```bash
export NODE_ENV=staging
#or
export NODE_ENV=production
#then
./app.sh start
```

For visual aid, a recording of a full walkthrough of the setup with a junior dev can be found [here](https://www.loom.com/share/f44be75ce80044a08a73c53ea64a3afd)

A recording which explains how it all works, and how to run tests can be found [here](https://www.loom.com/share/8566b834759742309ebc96c74e955767)

### Pre-run (one time)

See the Run instructions below for when to do this***

1. Create an expo account to build the app. [https://expo.dev/signup](https://expo.dev/signup)
2. Move to the Tonomy-ID directory `cd ./Tonomy-ID`
3. Remove the following lines from `app.json`

```json
    "extra": {
      "eas": {
        "projectId": "afffe2ee-9f93-4d18-9361-df30429cbd98"
      }
    }
```

4. (for IOS only) Run `eas device:create` to create a device profile for your phone
5. Run `eas build --profile development --platform ios` (ios) or `eas build --profile development --platform android` (android) to build the app for your phone
6. Return to [https://expo.dev/](https://expo.dev/) and click on the Tonomy ID project build
7. Install the created app on your phone
