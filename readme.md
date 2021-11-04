# docker-compose context problem

Repo to demo/recreate issue repotered: https://github.com/docker/compose/issues/8877

---

With the following naive structure:
```
$ tree -L 2
.
├── Makefile
├── docker-compose.yaml
├── readme.md
├── service-bar
│   ├── Cargo.lock
│   ├── Cargo.toml
│   ├── Dockerfile
│   ├── Makefile
│   ├── Rocket.toml
│   ├── src
│   └── target
└── service-foo
    ├── Cargo.lock
    ├── Cargo.toml
    ├── Dockerfile
    ├── Makefile
    ├── Rocket.toml
    ├── src
    └── target

6 directories, 13 files
```

If we go into either child directory, we can validate that the `Dockerfile` is independently valid and buildable
```
$ cd service-foo
$ docker build --tag service-foo:latest .
$ docker run --rm -it -p 8080:8080 service-foo:latest
```

It is currently not possible to build with correct context relative to the parent directory. The `docker-compose.yaml` contains the following content

#### docker-compose.yaml
```yaml
---
version: "3"
services:
  service-bar:
    build:
      dockerfile: "service-bar/Dockerfile"
      context: "service-bar"
    expose:
      - 8080
  service-foo:
    build:
      dockerfile: "service-foo/Dockerfile"
      context: "."
    expose:
      - 8080
```

If you try to build `service-bar`, you get an error stating that the directory relative to the dockerfile "service-bar" does not exist:

```bash
$ docker compose up service-bar
>
[+] Building 0.0s (0/0)
could not find /docker-compose-context-problem/service-bar/service-bar: stat /docker-compose-context-problem/service-bar/service-bar: no such file or directory
```

This would indicate that the context is relative to the dockerfile, which leads to the logical assumption that `.` is the correct directory to denote, as seen in `service-foo`. However attempting to run `service-foo` instead does not work either.

```
$ docker compose up service-foo
 => ERROR [main 4/4] COPY Rocket.toml Rocket.toml
------
 > [main 4/4] COPY Rocket.toml Rocket.toml:
 ```

this is because the context is now the project root directory where the `docker-compose.yaml` file is located. This can be verified by changing the instruction to `COPY service-foo/Rocket.toml Rocket.toml`.

Thus there is no way to build independant `Dockerfile`s in discrete context with a parent `docker-compose.yaml` in a separate directory.
