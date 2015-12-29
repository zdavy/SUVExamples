import PackageDescription

let package = Package(
    name: "SUVExamples",
    dependencies: [.Package(url: "../SUV", Version(0,0,5))],
    /* dependencies: [.Package(url: "https://github.com/zachmokahn/SUV.git", Version(0,0,5))], */
    targets: [Target(name: "EchoServer")]
)
