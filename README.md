# Managing secrets in containers

A presentation and sample application about managing secrets securely in containers environments using Hashicorp Vault.

## Disclaimer

**DO NOT USE ANY OF THIS CODE IN A PRODUCTION SETUP**

Especially the Vault configuration is meant to demonstrate what Vault can do, not how to run it securely. Instead, [read up on how to install and configure Vault at their website](https://www.vaultproject.io/docs/index.html).

## Presentation

The presentation is written using [RemarkJS](https://github.com/gnab/remark). It's a fantastic framework which lets you write slick and beautiful presentations using nothing but Markdown and some CSS/HTML.

I'm also using [embedmd](https://github.com/campoy/embedmd), which is a convenient tool for embedding snippets of code or anything else coming out of other files inside your Markdown text.

### Building the presentation

Simply run

```sh
$ ./go build_md
```

and then

```sh
$ ./python_webserver.sh
```

to start a simple webserver which you can access at [http://localhost:8000](http://localhost:8000). Any webserver will do, I've added the script for convenience.


## Sample container app

I've included a sample container app to demonstrate the way people can make use of Vault in combination with [consul-template](https://github.com/hashicorp/consul-template).

### Prerequisites

The app is using [Docker](https://www.docker.com) and [docker-compose](https://github.com/docker/compose/) as well as the [Vault](https://www.vaultproject.io) binary. You should have all three installed before proceeding to try it out.

### Setup

Run

```sh
$ ./go build
```

### Running

Run

```sh
$ ./go run
```

The webserver, including the `index.html` composed dynamically by `consul-template` will now be accessible at [http://localhost:2015/](http://localhost:2015/). You can change the value the `index.html` thinks is its secret by running

```sh
$ VAULT_TOKEN=token VAULT_ADDR="http://localhost:18200" vault write /secret/some/secret output=<your-new-value>`
```

`consul-template` should pick up on these changes after roughly 30 - 60 seconds and restart the webserver inside the container, which then should serve the new `index.html`, including your new "secret" value.

# License

All of the content in `images/` is not subject to the overall license this project is under (MIT). I do not claim ownership nor mean to misappropriate content in any way. The rights remain with their respective owners and creators.

I have put references inside my presentation where appropriate and necessary.
