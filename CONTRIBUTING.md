# Tonomy-ID Contributor's Guide

A big welcome and thank you for considering contributing to Tonomy! It is people like you that help shape the future where your identity is in your hands.

Reading and following these guidelines will help us make the contribution process easy and effective for everyone involved. It also communicates that you respect the time of the developers managing and developing these open source projects. In return, we will reciprocate this by addressing your issue, assessing changes and helping you finalize your pull requests.

## Quick links

* [Developer Environment](#developer-environment)
* [Git and Development Policy](#git-and-development-policy)
* [Developer Expectations](#developer-expectations)
* [Conventions](#conventions)
* [Best Practices](#best-practices)
* [Resources](#resources)
* [Contributing](#contributing)

## Developer Environment

Developers are suggested to use linux with Ubuntu 20.04 for development. We use [VS Code](https://code.visualstudio.com/) as an IDE for development and have several suggested extensions in the repositories that are useful.

If you do not have a Linux machine we suggest setting up a [VirtualBox](https://www.virtualbox.org/) hypervisor on your machine, and installing a Ubuntu 20.04 virtual machine.

* We suggest you use Snapshots in Virtualbox to create snapshots you can go back to if you encounter unsolvable issues. (see below)
* To run Tonomy ID on your mobile device through the virtual machine, you will need use a [Bridged Network Adapter](https://www.techrepublic.com/article/how-to-set-bridged-networking-in-a-virtualbox-virtual-machine/) in the settings of the virtual machine

<img src="./assets/snapshots.jpg" />

## Git and development policy

### Development Process

<img src="./assets/Development process-Advanced dev process.drawio.png" />

Source: <https://drive.google.com/file/d/1-mACdt8ucz5ONKpqiECjSz3GAP0ASq8o/view?usp=sharing>

### **Definition of ready** (DOR) for **tasks in a DEV epic**

This policy defines when all developer tasks are ready to be started/worked on.

* [ ] Part of a valid **epic**
* [ ] **User story is defined** in the epic
* [ ] **Acceptance criteria are defined**: Set of pre-defined requirements that must be achieved to consider the story complete.
* [ ] All **dependencies are accounted for** (identified and handling is clear): If there are dependencies in a story, they should be outlined, and their handling should be defined.
* [ ] **Estimated and below our maximum limit**: Stories should be estimated using a non-linear scale. The maximum value depends on the team and should be set by each one.
* [ ] (**optional** for complex tasks open to mis-interpretation) A small **implementation plan** is created and reviewed by another developer before implementation starts. This is suggested for all new contributors, and all junior developers. See [Implementation plan](#implementation-plan) below.

### **Definition of done** (DOD) for **tasks in a DEV epic**

This policy defines when all developer tasks are finished and can be closed. This applies to all tasks with the 'Application' tag.

* [ ] 💯 **Acceptance criteria are met**: implemented and tested locally
  * [ ] Functional criteria are tested functionally (i.e. use the app and check the behavior is as expected)
  * [ ] Non-functional criteria are validated by the developer, via logging or other appropriate method
* [ ] 🖌️ **User interface** matches the Figma designs exactly
* [ ] 👌 **Tests** are created or updated to cover changes: Check:
  * [ ] Unit and integration tests cover new code main expected success and failure cases
  * [ ] Unit and integration tests are passing
  * [ ] All linting checks are passing
* [ ] 📄 **Documentation** is created or updated to match changes. Check the following
  * [ ] All changed classes and functions are **documented** with ([JSDoc](https://devhints.io/jsdoc) for Typescript)
  * [ ] All debugging **comments and logging is removed**
  * [ ] (**README.md**) is updated if the way to run is changed or anything else relevant
  * [ ] (**mkdocs**) documentation is updated if needed for external interface or behavioral changes. Or create a task to do this and tell the Product Owner.
  * [ ] Any other documentation that are relevant
* [ ] 🔗 **Dependant software or repositories** are updated if needed. Or create a task to do this and tell the Product Owner.
  * [ ] Check all repos in our multi-repo software: Tonomy ID, SDK, Integration, Demo website, Login website, Contracts and Communication
  * [ ] Think if there is other dependant software: errors, logging, services, UI components, package.json, navigation, storage, settings, cryptography, networking, initialization etc...
* [ ] ⏭️ Before the merge
  * [ ] **PR review** from a developer that did not do the work and approves it (or gives feedback which needs to be addressed).
  * [ ] **Rebase branch** from development. See [Git rebase](#git-rebase) below
  * [ ] **Test again** after rebase if there were upstream changes merged that affect your files
* [ ] ▶️ The PR is **merged**.
* [ ] 😊 **Check acceptance criteria on staging** and any functionalities effected by your code changes

#### Git rebase

You can press the "Update Branch" button on Github if there are no conflicts. Otherwise you will need to do the following:

Full `git merge` steps:

```bash
git checkout development
git pull
git checkout feature/task-no-description
git merge development
# fix conflicts
```

Don't use `git rebase` ([why?](https://medium.com/@fredrikmorken/why-you-should-stop-using-git-rebase-5552bee4fed1))

#### Implementation plan

An implementation plan shows the changes to class/function interfaces. Pseudo-code can also be added to show intended implementation. This should be done in the Github Issue, or a PR. The implementation plan exists to have a conversation, but not to fix the outcome at the end.

## Developer Expectations

### README.md

Read the README.md in full and in detail, before asking for help! In all repositories and sub-repositories that you are working in.

### Communication and creating PRs for review

<https://discord.com/channels/1029385699071381524/1039498885598552065/1070264623397351506>

### Branch naming

<img src="./assets/Development process-Branch.drawio.png" />

### Git commits

* Conventional commits: <https://www.conventionalcommits.org/en/v1.0.0/#summary>
* Use the VS Studio recommended extension to do commits

**Turn on all recommended VS Code extensions. They are configured to help!**

## Conventions

### Javascript Conventions

Read [JAVASCRIPT_CONVENTIONS](./JAVASCRIPT_CONVENTIONS.md).

## Best Practices

* **[DRY Principle](https://www.digitalocean.com/community/conceptual-articles/s-o-l-i-d-the-first-five-principles-of-object-oriented-design)**: Avoid code duplication.
* **[SOLID Principles](https://www.digitalocean.com/community/tutorials/what-is-dry-development)**: Maintainable, understandable, and flexible OOP design.
* **Refactoring**: Regularly refactor to improve performance and readability.
* **Testing**: Ensure unit tests cover all business logic adequately. Currently we do **not** do UI automated testing.
* **Dependencies**: Keep track of any dependencies the helper functions have and make sure they are kept up to date.
* **Single Responsibility**: One function, one purpose.
* **Pure Functions**: Aim for no side effects.

### Javascript Best Practices

Read [JAVASCRIPT_BEST_PRACTICES](./JAVASCRIPT_BEST_PRACTICES.md).

## Resources

### Tonomy ID Workshop

Watch to understand the architecture and general model and use case:

<https://www.loom.com/share/d29cda0913bf4f569ed501aee76c5337>

### Design

Figma design:

<https://www.figma.com/file/cvV48t0f7O2znT6QBxK0Zj/Tonomy-ID>

## Contributing

### Looking for how to contribute?

Check out the issues in the [repositories](./README.md#repositories), or, if you have access, the issues in our [Zenhub board](https://app.zenhub.com/workspaces/tonomy-id-62a06b705d27820023023630/board)

### Issues

Issues should be used to report problems with the library, request a new feature, or to discuss potential changes before a PR is created.

If you find an issue that addresses the problems you're having, please add your own reproduction information to the existing issue rather than creating a new one. Adding a [reaction](link) can also help with indicating to our maintainers and developers.

### Pull Requests

PRs are the best and quickest way to get your fix, improvement or feature merged. In general, PRs should:

* Only fix/add the functionality in the issue
* Address a single concern in the least number of changed lines as possible

### Getting Help

Send a message to <contact@tonomy.foundation> for help or reach out on our [Discord](https://discord.gg/rrJwz6Uf5P)
