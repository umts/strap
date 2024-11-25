# Strap

A script to bootstrap a minimal macOS development system. This does not assume you're doing Ruby/Rails/web development
but installs the minimal set of software every macOS developer will want.

## Motivation

Replacing [Boxen][boxen] in GitHub with a better tool. This post outlines the problems with Boxen and requirements for
Strap and other tools used by GitHub: <https://mikemcquaid.com/2016/06/15/replacing-boxen/>

Mike transitioned the Strap project to a static site in 2024 in order to focus on  [Workbrew][workbrew], which among
other things, features its own bootstrapping tool.  UMass Transportation Services is maintaining a fork of the dynamic
version of Strap primarily for internal use.

## Features

- Enables `sudo` using TouchID
- Disables Java in Safari (for better security)
- Enables the macOS screensaver password immediately (for better security)
- Enables the macOS application firewall (for better security)
- Adds a `Found this computer?` message to the login screen (for machine recovery)
- Enables full-disk encryption and saves the FileVault Recovery Key to the Desktop (for better security)
- Installs the Xcode Command Line Tools (for compilers and Unix tools)
- Agree to the Xcode license (for using compilers without prompts)
- Installs [Homebrew][homebrew] (for installing command-line software)
- Installs [Homebrew Bundle][homebrew-bundle] (for `bundler`-like `Brewfile` support)
- Installs [Homebrew Services][homebrew-services] (for managing Homebrew-installed services)
- Installs [Homebrew Cask][homebrew-cask] (for installing graphical software)
- Installs the latest macOS software updates (for better security)
- Installs dotfiles from a user's `https://github.com/username/dotfiles` repository. If they exist and are executable:
  runs `script/setup` to configure the dotfiles and `script/strap-after-setup` after setting up everything else.
- Installs software from a user's `Brewfile` in their `https://github.com/username/homebrew-brewfile` repository or
  `.Brewfile` in their home directory.
- A simple web application to set Git's name, email and GitHub token (needs authorised on any organisations you wish to
  access)
- Idempotent

## Out of Scope Features

- Enabling any network services by default (instead enable them when needed)
- Installing Homebrew formulae by default for everyone in an organisation (install them with `Brewfile`s in project
  repositories instead of mandating formulae for the whole organisation), though we do 
  [cheat on this one a little][homebrew-umts-dev]
- Opting-out of any macOS updates (Apple's security updates and macOS updates are there for a reason)
- Disabling security features (these are a minimal set of best practises)
- Add phone number to security screen message (want to avoid prompting users for information on installation)

## Usage

Open <https://strap.umasstransit.it/> in your web browser.

Instead, to run Strap locally run:

```bash
git clone https://github.com/umts/strap
cd strap
bash bin/strap.sh # or bash bin/strap.sh --debug for more debugging output
```

Instead, to run the web application locally run:

```bash
git clone https://github.com/umts/strap
cd strap
./script/bootstrap
GITHUB_KEY="..." GITHUB_SECRET="..." ./script/server
```

## Web Application Configuration Environment Variables

- `GITHUB_KEY`: the GitHub.com Application Client ID.
- `GITHUB_SECRET`: the GitHub.com Application Client Secret.
- `SESSION_SECRET`: the secret used for cookie session storage.
- `WEB_CONCURRENCY`: the number of Puma (web server) threads to run (defaults to 3).
- `STRAP_ISSUES_URL`: the URL where users should file issues (defaults to no URL).
- `STRAP_BEFORE_INSTALL`: instructions displayed in the web application for users to follow before installing Strap
  (wrapped in `<li>` tags).
- `CUSTOM_HOMEBREW_TAP`: an optional Homebrew tap to install with `brew tap`. Specify multiple arguments to brew tap by
   separating values with spaces.
- `CUSTOM_BREW_COMMAND`: a single `brew` command that is run after all other stages have completed.

## Status

Work on this project is primarily for UMTS internal use. Pull requests _may_ be accepted, though.

## License

Licensed under the [MIT License][mit-license].
The full license text is available in [LICENSE.txt][license].

[boxen]: https://github.com/boxen/boxen
[workbrew]: https://workbrew.com/
[homebrew]: https://brew.sh
[homebrew-bundle]: https://github.com/Homebrew/homebrew-bundle
[homebrew-services]: https://github.com/Homebrew/homebrew-services
[homebrew-cask]: https://github.com/Homebrew/homebrew-cask
[homebrew-umts-dev]: https://github.com/umts/homebrew-umts-dev
[mit-license]: https://en.wikipedia.org/wiki/MIT_License
[license]: https://github.com/umts/strap/blob/main/LICENSE.txt
