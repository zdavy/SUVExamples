import SUV

var count = 0

IdleHandle(Loop.defaultLoop).start { idle in
  guard (count < 10) else { idle.stop(); return }
  print(++count)
}

Loop.defaultLoop.run(.Default)
