# Common issues

## Package issues

### Error: Requiring module "node_modules/

**FIX** you need to create a new expo build with the latest dependencies

`yarn run build:ios` (ios) or `yarn run build:android`

### Error: Cannot find module './tonomy-id-sdk.cjs.development.js'

**FIX:** re-install the SDK manually and restart id

```bash
cd Tonomy-ID-SDK
yarn
pm2 restart id
```

### Other package errors

**FIX:** reset all and start again:

```bash
./app.sh reset all
./app.sh install
./app.sh init
./app.sh start
```

**FIX:** re-clone the repo and install all from scratch

Make sure you push and code changes you want to keep before you reclone!

## CombinedError [GraphQL]: Entity not authorized

You are not authorized for this project with this EAS user

FIX: change the value of projectID in the `./Tonomy-ID/app.default.json` file

## [Error] Could not encrypt/decrypt the item in SecureStore

Your secure hardware keystore has keys which have now changed config and cannot be removed.

FIX: Go to the settings on your phone and delete any storage associated with the app.
