# Tonomy-ID-integration

Developer environment to run Tonomy ID locally alongside a blockchain node, and the demo app.

## Dependancies

- Linux debian distribution (Ubuntu 20.0.4 LTS used)
- [Docker](http://docs.docker.com) v20.10+
- [Docker Compose](http://docs.docker.com/compose/) v1.29+
- [npm](https://www.npmjs.com/) v16.4-17.0. Suggested to install with [nvm](https://github.com/nvm-sh/nvm) v0.35+
- [expo-cli](https://expo.dev/) v5.2+ installed globally by `npm`
- [pm2](https://pm2.io) v5.5+ installed globally by `npm`

Check `./scripts/install_prerequisits.sh` for way to install this on Ubuntu 20.0.4.

## Use

Get the app running for the first time

```bash
./app.sh gitinit
./app.sh install
./app.sh init
```

You can then start and stop the services with.

```bash
./app.sh start
```

For other features like logging and data reset see

```bash
./app.sh
```
