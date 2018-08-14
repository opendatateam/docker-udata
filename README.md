# udata all-in-one Docker image

[![](https://images.microbadger.com/badges/image/udata/udata:2-alpine.svg)](https://microbadger.com/images/udata/udata:2-alpine "Docker image details")

## Quick start

```bash
cd docker-udata
docker-compose up
```
Check that [`localhost:7000`](http://localhost:7000) is available in a browser.


## Details

This Docker image provide udata as well as all known plugins and themes.

It is packaged to run within uwsgi with gevent support.

By default, it exposes the frontend on the port **7000** and expect the following services:

* **MongoDB** on `mongodb:27017`
* **Elasticsearch** on `elasticsearch:9200`
* **Redis** on `redis:6379`

and use the following paths:

* `/udata/udata.cfg` for udata configuration
* `/udata/fs` for storage root (as a volume by default)
* `/udata/public` for public assets root
* `/udata/uwsgi/*.ini` for uwsgi configuration files
* `/src/*/setup.py` for extra development packages to install

You can customize configuration by providing a custom `udata.cfg` or custom uwsgi `ini` file.

A [sample docker-compose.yml file](https://github.com/opendatateam/docker-udata/blob/master/docker-compose.yml)
is also available in the repository.

## Running docker image service

Fetch the latest Docker image version

```bash
docker pull udata/udata
```

Then you can run the container with different configurations:

* a custom udata configuration mounted (here a local `udata.cfg`):

    ```bash
    docker run -v /absolute/path/to/udata.cfg:/udata/udata.cfg udata/udata
    ```

* with custom uwsgi configurations (here contained in the `uwsgi` directory):

    ```bash
    docker run -v `$PWD`/uwsgi:/udata/uwsgi udata/udata
    ```

* with file storage as local volume binding:

    ```bash
    docker run -v /path/to/storage:/udata/fs udata/udata
    ```

# Running standalone instance

You can run standalone (front/worker/beat) instance with the `front`, `worker` and `beat` commands:

```bash
docker run udata/udata front
docker run udata/udata worker
docker run udata/udata beat
```

## Running udata commands

You can also execute `udata` commands with:

```bash
docker run [DOCKER OPTIONS] udata/udata [UDATA COMMAND]
```

By example, to initialise the database with fixtures and initialize the search index:

```bash
docker run -it --rm udata/udata init
```

List all commands with:

```bash
docker run -it --rm udata/udata --help
```

**Note:** Some commands requires either MongoDB, Redis or Elasticsearch to be up and ready.

## Running celery commands

You are also able to run `celery` commands with:

```bash
docker run -it --rm udata/udata celery status
```

## Running bash

For debugging purpose you can acces a bash prompt with:

```bash
docker run [DOCKER OPTIONS] udata/udata bash
```

## Installing extra sources

You can install extra sources by mounting directories as subdirectories of `/src/`.

Given you have a udata theme `awesome-theme` in `my-theme` directory
and you want to use docker to hack on it with live reload,
you need to have the following line in your `udata.cfg`:

```python
THEME = 'awesome-theme'
```

Then you can run the udata Development server with:

```bash
docker run -it -v `$PWD`/my-theme:/src/my-theme -v `$PWD`/udata.cfg:/udata/udata.cfg --rm udata/udata serve
```
Your theme will be installed and activated.

See the `sample/theme` directory to see a full theme development using `docker-compose`.

# Examples

You can see some docker-compose configuration examples in the `sample` directory of this repository.
