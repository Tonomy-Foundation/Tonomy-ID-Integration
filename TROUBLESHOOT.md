# Common issues

## Package dependancy issues

FIX: reset all and start again:

```bash
./app.sh reset all
./app.sh install
./app.sh init
./app.sh start
```

FIX: restart id after you have started

```bash
./app.sh start
...
pm2 restart id
```

FIX: re-clone the repo and install all from scratch

Make sure you push and code changes you want to keep before you reclone!

## [Error] Could not decrypt the item in SecureStore

Your secure hardware keystore has keys which have now changed config and cannot be removed.

FIX: Go to the settings on your phone and delete any storage associated with the app.
