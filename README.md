# [SUV](https://github.com/zachmokahn/SUV) Examples

_depends on libuv version 1.8.0-r1, install it according to the [repo](https://github.com/libuv/libuv/commit/5467299450ecf61635657557b6e01aaaf6c3fdf4) documentation_

### Building the Project with [SwiftPM](https://github.com/apple/swift-package-manager):

##### using toolchain _Swift 2.2 Snapshot - December 22, 2015_ or later

  ```bash
    > swift build
  ```


##### using toolchain earlier than _Swift 2.2 Snapshot - December 22, 2015_

When using aversion ealier than the snapshot on December 22,2015 the SwiftPM will
act a little funky when linking executables from a dependency. The dependency with
the issue in this project is [Swiftest](https://github.com/bppr/Swiftest). There is
a workaround for this linking issues.

__workaround__:

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
    Compiling Swift Module 'SUV' (86 sources)
    Linking Library:  .build/debug/SUV.a
    Compiling Swift Module 'Spec' (23 sources)
    Linking Executable:  .build/debug/Spec
    Compiling Swift Module 'Cat' (1 sources)
    Compiling Swift Module 'EchoServer' (1 sources)
    Linking Executable:  .build/debug/Cat
    Linking Executable:  .build/debug/EchoServer
  ```


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

### CAT
Reads the file `./Sources/Cat/test.txt` and prints it to standard out

* execute the command

  ```bash
  > ./.build/debug/Cat

      ,';,               ,';,
     ,' , :;             ; ,,.;
     | |:; :;           ; ;:|.|
     | |::; ';,,,,,,,,,'  ;:|.|    ,,,;;;;;;;;,,,
     ; |''  ___      ___   ';.;,,''             ''';,,,
     ',:   /   \    /   \    .;.                      '';,
     ;    /    |    |    \     ;,                        ';,
    ;    |    /|    |\    |    :|                          ';,
    |    |    \|    |/    |    :|     ,,,,,,,               ';,
    |     \____| __ |____/     :;  ,''                        ;,
    ;           /  \          :; ,'                           :;
     ',        `----'        :; |'                            :|
       ',,  `----------'  ..;',|'                             :|
      ,'  ',,,,,,,,,,,;;;;''  |'                              :;
    ,'  ,,,,                  |,                              :;
    | ,'   :;, ,,''''''''''   '|.   ...........                ';,
    ;       :;|               ,,';;;''''''                      ';,
     ',,,,,;;;|.............,'                          ....      ;,
               ''''''''''''|        .............;;;;;;;''''',    ':;
                           |;;;;;;;;'''''''''''''             ;    :|
                                                          ,,,'     :;
                                              ,,,,,,,,,,''       .;'
                                             |              .;;;;'
                                             ';;;;;;;;;;;;;;'
  ```
