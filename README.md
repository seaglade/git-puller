# `git-puller`

As one might expect, `git-puller` is a docker container that keeps a cloned git repo in sync with its origin by pulling on an interval. It can handle both public repositories and private ones that require a username and password. I threw it together to keep my Airflow DAGs synced with my personal Git repo. I had tried using [kubernetes/git-sync](https://github.com/kubernetes/git-sync), but with the way Airflow's Docker Compose configuration expects directories to be laid out and the fact that Docker does not update file mounts (even if they're links to directories), that didn't work out, so I hacked this together. You should probably also try `git-sync` first before resorting to this, because if it does work for you it's better in a lot of ways.

## Usage

First off, you must have already cloned the repo you want to keep in sync! `git-puller` does not perform the initial clone; as the name suggests, it just calls `git pull` on an interval. Assuming that the repo is publically accessible (i.e. no credentials needed), and is cloned into `./repo`, you can just run this command:

```sh
docker run -u 1000:1000 -v ./repo:/tmp/repo ghcr.io/seaglade/git-puller:latest
```

Please note the `-u` argument! Git expects the directory it is acting on to have user and group ownership matching the user running the `git pull` command. `1000:1000` is the default on many Linux systems, but check to see what the ownership status of the repo directory is and set the `-u` argument to match.

If you want `git-puller` to update your repository on some interval other than every 10 seconds (the default), pass `-e GIT_INTERVAL n` where `n` is the interval you want in seconds.

### Authentication

> [!CAUTION]
> It goes without saying that passing credentials in a command line is generally a _very_ bad idea, so you might want to use Docker Compose instead to keep your credentials out of your command history.

If your repo _does_ require authentication, like the one that motivated me to make this, `git-puller` still works! The command is slightly different:

```sh
docker run -u 1000:1000 -v ./repo:/tmp/repo -e GIT_USER=your_username -e GIT_PASS=your_password ghcr.io/seaglade/git-puller:latest
```

`git-puller` will automatically configure `git` to use those credentials when pulling the repo.

### Docker Compose

If you are using Docker Compose, you can paste one of the above commands into a site like [Composerize](https://www.composerize.com/) to get `yaml` configuration for your stack.
