# Interview exercise for ChemAxon

Implements the "clock mirror image" problem.
The binary creates an HTTP server with a single HTTP endpoint: `getTimeFromMirrorImage`.
It expects its input via query string parameters:

- `hours`
- `minutes`

The binary is packaged as a docker image and the build is handled by `make`.
The build process itself takes place in a docker container (official golang image) to make sure the build environment is always the same. The compiled binary is then added to an ubuntu docker image without the build tools.
To build the docker image, run:
```
make docker-build
```

The web server listens on the fixed TCP port 61023.

Example call to the HTTP endpoint:
```
curl "localhost:61023/getTimeFromMirrorImage?hours=12&minutes=03"
```
