## SUV Examples

A set of examples displaying what's possible with the SUV library's API at the
moment.

### Building the Project:

Right now the [SwiftPM](https://github.com/apple/swift-package-manager) is
acting a little funky while linking an executable in the
[Swiftest](https://github.com/bppr/Swiftest) package (I assume it's a general
executable-linking problem but I haven't gotten around to exploring it yet).

Eventual it will be as easy as `> swift build`, but for now use the workaround.

#### _workaround_:

* Attempt to build the project.

  ```bash
    > swift build
  ```

* You should get this output:

  ```bash
    Cloning Packages/SUV
    Cloning Packages/libUV
    Cloning Packages/Swiftest
    Cloning Packages/OS
    Compiling Swift Module 'OS' (1 sources)
    Linking Library:  .build/debug/OS.a
    Compiling Swift Module 'Swiftest' (27 sources)
    Linking Library:  .build/debug/Swiftest.a
    Compiling Swift Module 'Example' (8 sources)
    Linking Executable:  .build/debug/Example
    /usr/bin/ld: cannot find /path/to/SUVExamples/.build/debug/SUV.a: No such file or directory
  ```

* That's not a very descriptive output, and doesn't relay anything about the
  linking issues, but I promise it is a linking problem (I think). To resolve
  it, delete the Example directory in the Swiftest Package that is cloned.

  ```bash
    > rm -r Packages/Swiftest-0.1.4/src/Example
  ```

* Now if you build the projects again:

  ```bash
    > swift build
  ```

* You should get the final bit of output:

  ```bash
    Compiling Swift Module 'SUV' (35 sources)
    Linking Library:  .build/debug/SUV.a
    Compiling Swift Module 'Spec' (17 sources)
    Linking Executable:  .build/debug/Spec
    Compiling Swift Module 'EchoServer' (1 sources)
  ```

* Now you're read to use the examples


### Examples:

#### Echo Server
Spins up a server that echos the requests made on `http://localhost:8000`.

* Start the server

  ```bash
  > ./.build/debug/EchoServer
  ```

* Make requests from another terminal

  ```bash
  > curl localhost:8000

  GET / HTTP/1.1
  User-Agent: curl/7.35.0
  Host: localhost:8000
  Accept: */*
  ```
