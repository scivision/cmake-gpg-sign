# CMake GPG sign binaries

Simple example of building and signing binaries and installing them to a user-defined location in CMake as a post-build action.
The
[signature certifies](https://en.wikipedia.org/wiki/Pretty_Good_Privacy#Digital_signatures)
that the worker created the signed binaries.
As with any signing method, this does not certify you or the worker isn't corrupted in some way.
This method works on every platform we've tried where GPG is available e.g. MacOS, Linux, Windows, ....

You must have previously
[setup PGP](https://www.scivision.dev/github-pgp-signed-verified-commit/)
on your system for this example to work.

## Build

```sh
cmake -B build -DCMAKE_INSTALL_PREFIX=~/demo

cmake --build build

cmake --install build
```

creates:

* "~/demo/bin/hello" binary executable
* "~/demo/bin/hello.asc" plain-text GPG binary signature

## CPack Package

Optionally, CPack can be used to package the GPG signature files alongside the source and/or binary package files.
After building, do:

```sh
cpack --config build/CPackConfig.cmake  # binary package

cpack --config build/CPackSourceConfig.cmake  # source package
```

Observe the files are created:

```
build/package/PGPdemo-<version>-Source.tar.zst
build/package/PGPdemo-<version>-Source.tar.zst.asc
build/package/PGPdemo-<version>-<platform>.tar.zst
build/package/PGPdemo-<version>-<platform>.tar.zst.asc
```

## Verify signature

```sh
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
