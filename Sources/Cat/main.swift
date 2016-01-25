import SUV

func cat(openRequest: FSRequest, _ buffer: Buffer) {
  FS(openRequest.loop).read(.File(openRequest.result), buffer, Int(openRequest.result)) { readRequest in
    guard(readRequest.result > 0) else {
      openRequest.close()
      return
    }

    FS(readRequest.loop).write(.Out, buffer, Int(readRequest.result)) { writeRequest in
      writeRequest.cleanup()

      if(writeRequest.result >= 0) {
        cat(openRequest, buffer)
      } else {
        openRequest.close()
        return
      }
    }
  }
}

FS(Loop.defaultLoop).open(Process.arguments[1], .ReadOnly, .Read(.User)) { openRequest in
  if(openRequest.result >= 0) {
    cat(openRequest, Buffer())
  }
}

Loop.defaultLoop.run(.Default)
