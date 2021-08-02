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

You must have previously setup PGP on your system for this example to work.
