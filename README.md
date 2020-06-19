# Interview exercise for ChemAxon

Implements the "clock mirror image" problem.
The binary creates an HTTP server with a single HTTP endpoint: `getTimeFromMirrorImage`.
It expects its input via query string parameters:

- `hours`
- `minutes`

Example call to the HTTP endpoint:
```
curl "localhost:61023/getTimeFromMirrorImage?hours=12&minutes=03"
```
