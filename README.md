# Tonomy-ID-integration

Developer environment to run Tonomy ID locally alongside a blockchain node, and the demo app.

## Dependancies

- Linux debian distribution (Ubuntu 20.0.4 LTS used)
- [Docker Compose](http://docs.docker.com/compose/) v1.29+
- [nvm](https://github.com/nvm-sh/nvm) v0.35+

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
