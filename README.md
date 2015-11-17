# Ghost Docker Configuration

## Overview
This repo contains a biased Docker configuration for the current version of
[Ghost](https://ghost.com) - the lightweight, clean, minimalistic, NodeJS-based
blogging platform. This configuration is based on a combination of the
[official Docker configuration for Ghost](https://github.com/docker-library/ghost)
as well as a modified version of
[this guide](http://0v.org/installing-ghost-on-ubuntu-nginx-and-mysql/), but
aims to be more configurable than both, and only runs the **production** version
of Ghost.

**Note**: At present, this configuration only supports HTTP, and not HTTPS,
and we have only built support for version 0.7.1 of Ghost.

## Architecture
A running container spawned from this configuration will contain the following
components:

* An instance of Ghost running at http://127.0.0.1:2368 within the container.
* An instance of [nginx](http://nginx.org) bound to 0.0.0.0:80 within the
  container. This nginx instance provides some local caching of the content
  served up by the Ghost instance.
* The Ghost ``content`` directory (which includes uploaded images, themes, etc.)
  exposed as a volume from ``/var/lib/ghost`` within the container.

One can either use SQLite or MySQL as backends for this configuration. See the
``GHOST_STORAGE`` environment variable below for details.

## Environment Variables
Once your Docker image is built, you can make use of the following environment
variables to control how your Ghost instance runs.

* ``GHOST_HOST``: The base host that will be serving your blog, e.g.
  ``my-blog.com``. Default: ``localhost``.
* ``GHOST_STORAGE``: The storage mechanism to use for Ghost's content. At
  present, this can either be ``sqlite3`` or ``mysql``. If ``sqlite3`` is
  chosen, the SQLite database will be stored in the exposed volume from the
  ``/var/lib/ghost`` folder within the container. If ``mysql`` is chosen, one
  must configure the MySQL database environment variables specified by
  ``GHOST_MYSQL_*`` below. Default: ``sqlite3``.
* ``GHOST_MYSQL_HOST``: The host address of the MySQL server to use.
  Default: ``localhost``.
* ``GHOST_MYSQL_PORT``: The port to use to access the MySQL server.
  Default: ``3306``,
* ``GHOST_MYSQL_DATABASE``: The name of the MySQL database to use for your
  blog. Default: ``ghost``.
* ``GHOST_MYSQL_USER``: The MySQL user through which the database is to be
  accessed. Default: ``ghost``.
* ``GHOST_MYSQL_PASSWORD``: The password to use when accessing the MySQL
  database. Default: ``ghost``.

## Suggestions and Recommendations
Feel free to send through your suggestions and recommendations as to how to
improve this configuration.
