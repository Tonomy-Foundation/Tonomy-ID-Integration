# Common issues

## Package dependancy issues

FIX: reset all and start again:

```bash
./app.sh reset all
./app.sh install
./app.sh start
```

FIX restart id after you have started

```bash
./app.sh start
...
pm2 restart id
```

## [Error] Could not decrypt the item in SecureStore

Your secure hardware keystore has keys which have now changed config and cannot be removed.

FIX: Go to the settings on your phone and delete any storage associated with the app.
