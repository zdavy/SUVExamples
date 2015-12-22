import PackageDescription

let package = Package(
    name: "SUVExamples",
    dependencies: [.Package(url: "https://github.com/zachmokahn/SUV.git", Version(0,0,3))],
    targets: [Target(name: "EchoServer")]
)
