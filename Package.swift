import PackageDescription

let package = Package(
    name: "SUVExamples",
    dependencies: [.Package(url: "https://github.com/zachmokahn/SUV.git", Version(0,0,4))],
    targets: [Target(name: "EchoServer")]
)
