# CMake GPG sign binaries

Simple example of building and signing binaries and installing them to a user-defined location in CMake as a post-build action.
Works on Windows, MacOS, Linux, etc.

```sh
cmake -B build -DCMAKE_INSTALL_PREFIX=~/demo

cmake --build build

cmake --install build
```

creates:

* "~/demo/bin/hello" binary executable
* "~/demo/bin/hello.asc" plain-text GPG binary signature

You must have previously
[setup PGP](https://www.scivision.dev/github-pgp-signed-verified-commit/)
on your system for this example to work.

## Example

```sh
cmake -B build

cmake --build build

gpg --verify build/hello.asc build/hello
```

results in:

```
gpg: Signature made <when you signed>
gpg:                using RSA key <your key>
gpg: Good signature from "your PGP info" [ultimate]
...
```

This is done as a self-test by:

```sh
ctest --test-dir build
```

## Discussion

For projects that distribute one or a few binary files, this non-packaged approach may work.
For example, create a CI/CD worker with a GPG signature and then create signed releases with it.
The
[signature certifies](https://en.wikipedia.org/wiki/Pretty_Good_Privacy#Digital_signatures)
that the worker created the signed binaries.
As with any signing method, this does not certify you or the worker isn't corrupted in some way.

To make signed CPack packages, one way may be to make a frontend CMake script (or Bash, Python, etc.) that builds and packages and then creates a signature, with several CMake `execute_process` (or equivalent in other script languages) calls in the frontend script.
