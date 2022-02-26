<p style="text-align: center"><img style="height: 60px" src="https://docs.dockr.in/logo/half.png" alt="Logo Laravel Sail"></p>
<p style="text-align: center">Local Development Environment for Laravel using Docker</p>

## Introduction

DockR is a script based package written on bash to provide you an interactive Laravel development environment using [Docker](https://www.docker.com/). Once `Docker` and `DockR` are installed on your machine, You are good to go. DockR's ease of use and features allow anyone to work with `Docker` with ease.
DockR has many features that you can't get it with any other packages.

### Compatability

DockR is compatible with almost all platforms such as `macOS`, `Linux` and `Windows (WSL)`.

We aren't planning for native `Windows` support (without WSL) as of now. But may be in the future releases.

### Installation

#### macOS

```bash
brew install sharanvelu/dockr/dockr
```

#### macOS, Linux or Windows(WSL)

```bash
sudo bash -c "$(curl -fsSL install.dockr.in)"
```

### Usage

Setup `DOCKR_PORT` and `DOCKR_PHP_VERSION` in your projects .env file.

Starting your App :

```bash
dockr up
```

Stopping your App :

```bash
dockr down
```

### Official Documentation

Full Documentation for `DockR` can be found on the [DockR Website](https://docs.dockr.in).

### License

DockR is open-sourced software licensed under the [MIT license](LICENSE).
