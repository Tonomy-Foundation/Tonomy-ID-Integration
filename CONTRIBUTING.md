# Tonomy-ID Contributor's Guide

A big welcome and thank you for considering contributing to Tonomy! It is people like you that help shape the future where your identity is in your hands.

Reading and following these guidelines will help us make the contribution process easy and effective for everyone involved. It also communicates that you respect the time of the developers managing and developing these open source projects. In return, we will reciprocate this by adressing your issue, assessing changes and helping you finalize your pull requests.

## Quicklinks

* [Getting Started](#getting-started)
* [Tonomy ID Workshop](#tonomy-id-workshop)
* [Design](#design)
* [General Practices](#general-practices)
* [Issues](#issues)
* [Pull Requests](#pull-requests)
* [Getting Help](#getting-help)

## Getting Started

### Software Repositories

We use the Ubuntu 20.04 / 22.04 environments. Please use them, as Windows is not suggested & Mac is untested.
If you have a Windows or Mac PC, it's suggested to install VirtualBox.

### Setup Virtualbox to connect to the React Native app

You need to change the network mode of the Virtualbox that is running Tonomy ID to use a Bridged connection:
<https://linuxhint.com/use-virtualbox-bridged-adapter/>

Once this is set up, you should be able to run `./app.sh start` and then connect with the QR code.

To connect to the service manually, or other services in the Virtualbox, find your IP address using `ip a` inside the Virtualbox as shown in the article above. Then you can use this IP address in your host to access exposed services. For example you can go to your browser and open <http://10.2.218.179:3000> to get to the demo app.

### Tonomy ID Workshop

<https://www.loom.com/share/d29cda0913bf4f569ed501aee76c5337>

### Design

<https://www.figma.com/file/cvV48t0f7O2znT6QBxK0Zj/Tonomy-ID>

### General practices

* The JavaScript variables capital convention is [CamelCase](https://textcaseconvert.com/blog/what-is-camel-case/)

### Issues

Issues should be used to report problems with the library, request a new feature, or to discuss potential changes before a PR is created.

If you find an issue that adresses the problems you're having, please add your own reproduction information to the existing issue rather than creating a new one. Adding a [reaction](link) can also help with indicating to our maintainers and developers.

### Pull Requests

PRs are the best and quickest way to get your fix, improvement or feature merged. In general, PRs should:

* Only fix/add the functionality in the issue
* Address a single concern in the least number of changed lines as possible

## Getting Help

Send a message to contact@tonomy.foundation for help.
