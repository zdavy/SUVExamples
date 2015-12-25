import SUV

func cat(openRequest: FilesystemRequest, _ buffer: Buffer) {
  FS(openRequest.loop).read(openRequest.result, buffer, openRequest.result.size) { readRequest in
    guard(readRequest.result.size > 0) else {
      openRequest.close()
      return
    }

    FS(readRequest.loop).write(.STDOUT, buffer, readRequest.result.size) { writeRequest in
      writeRequest.cleanup()

      if(writeRequest.result.size >= 0) {
        cat(openRequest, buffer)
      } else {
        openRequest.close()
        return
      }
    }
  }
}

FS(Loop.defaultLoop).open("./Sources/Cat/test.txt", .ReadOnly, .Read(.User)) { openRequest in
  if(openRequest.result.size >= 0) {
    cat(openRequest, Buffer())
  }
}


Loop.defaultLoop.run(.Default)
