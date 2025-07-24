Docker Engine
=============
<!--
[comment]: # [![Build Status]()]()
-->

A role for installing:
  1. [docker](https://github.com/moby/moby)
  1. [docker-compose](https://github.com/docker/compose)

Requirements
------------

See [docker/meta/main.yml](docker/meta/main.yml)

See [docker_compose/meta/main.yml](docker_compose/meta/main.yml)


Role Variables
--------------

See [docker/defaults/main.yml](docker/defaults/main.yml)

See [docker_compose/defaults/main.yml](docker_compose/defaults/main.yml)


Dependencies
------------

See [docker/meta/main.yml](docker/meta/main.yml)

See [docker_compose/meta/main.yml](docker_compose/meta/main.yml)

Example Playbook
----------------

```yml
- hosts: servers
  roles:
    - role: docker-engine
      vars:
        docker: true
        docker_compose: true
```

License
-------

MIT

Author Information
------------------

Konstantin Toshchev [k_toshchev@wargaming.net](mailto:k_toshchev@wargaming.net)
