import SUV
import Glibc
/*  */
public extension Buffer {
  public convenience init(_ original: Buffer, _ size: Int) {
    self.init(size: UInt32(size))
    memcpy(self.pointer.memory.base, original.pointer.memory.base, size)
  }

  public func free() {
    Glibc.free(self.pointer.memory.base)
  }
}
/*  */
import libUV

public typealias UVPipeType = uv_pipe_t
/*  */
public typealias PipeInit = (UnsafeMutablePointer<UVLoopType>, UnsafeMutablePointer<UVPipeType>, Int32) -> Int32
/*  */
import libUV

public let UVPipeInit = uv_pipe_init
/*  */
public typealias PipeOpen = (UnsafeMutablePointer<UVPipeType>, UVFile) -> Int32
/*  */
import libUV

public let UVPipeOpen = uv_pipe_open
/*  */
public class PipeHandle: HandleType {
  public typealias Pointer = UnsafeMutablePointer<UVPipeType>

  public let pointer: Pointer
  public let loop: Loop

  public init(_ loop: Loop, uv_pipe_init: PipeInit = UVPipeInit, named: Int32 = 0) {
    self.loop = loop
    self.pointer = Pointer.alloc(sizeof(UVPipeType))

    uv_pipe_init(self.loop.pointer, self.pointer, named)
  }

  public func open(fd: FileDescriptor, uv_pipe_open: PipeOpen = UVPipeOpen) {
    uv_pipe_open(self.pointer, fd.flag)
  }

  public func close(uv_close uv_close: Close = UVClose, _ callback: (Handle -> Void)) {
    Handle(self).close(uv_close: uv_close) { callback($0) }
  }
}
/*  */
import SUV

let inputPipe = PipeHandle(Loop.defaultLoop)
let outputPipe = PipeHandle(Loop.defaultLoop)
let filePipe = PipeHandle(Loop.defaultLoop)

FS(Loop.defaultLoop).open("./Sources/Tee/test.txt", .Or(.Create, .ReadWrite), .MODE(0644)) { openRequest in
  inputPipe.open(.STDIN)
  outputPipe.open(.STDOUT)
  filePipe.open(.FILE(openRequest.result))

  print(openRequest.result.ref)
  print(String.fromCString(uv_strerror(openRequest.result.ref)))

  StreamHandle(inputPipe).read { stream, size, buffer in
    if size < 0 {
      inputPipe.close() { _ in }
      outputPipe.close() { _ in }
      filePipe.close() { _ in }
    } else if size > 0 {
      for pipe in [outputPipe, filePipe] {
        let buffer = Buffer(buffer, size)

        print(pipe)

        WriteRequest().write(StreamHandle(pipe), buffer) { request,_ in
          buffer.free()
          request.free()
        }
      }
    }

    buffer.free()
  }
}

Loop.defaultLoop.run(.Default)
