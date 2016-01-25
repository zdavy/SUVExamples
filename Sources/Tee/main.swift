import SUV

let stdin = PipeHandle(Loop.defaultLoop)
stdin.open(.In)

let stdout = PipeHandle(Loop.defaultLoop)
stdout.open(.Out)

let fd = FS(Loop.defaultLoop).open(Process.arguments[1], .Or([.Create, .ReadWrite]), .Or([.MODE(S_IRWXU), .MODE(S_IRWXG), .MODE(S_IRWXO)]))
let file = PipeHandle(Loop.defaultLoop)
file.open(fd)

StreamHandle(stdin).read { stream, nread, buffer in
  if nread < 0 {
    if (nread == UVEOF) {
      stdin.close()
      stdout.close()
      file.close()
    }
  } else {
    for pipe in [stdout, file] {
      let buffer = Buffer(buffer, nread)
      WriteRequest().write(StreamHandle(pipe), buffer) { request, _ in
        cFree(buffer.pointer.memory.base)
        cFree(request.pointer)
      }
    }
  }

  if buffer.pointer.memory.base != nil {
    cFree(buffer.pointer.memory.base)
  }
}

Loop.defaultLoop.run(.Default)
