import PackageDescription

let package = Package(
    name: "TodoList",
    targets: [
        Target(
            name: "Deploy",
            dependencies: [.Target(name: "TodoList")]
        ),
        Target(
            name: "TodoList"
        )
    ],
    dependencies: [
         .Package(url: "https://github.com/IBM-Swift/Swift-cfenv.git", majorVersion: 1, minor: 6),
         .Package(url: "https://github.com/IBM-Swift/Kitura.git",majorVersion: 0, minor: 28),
         .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git",majorVersion: 0, minor: 15),
         .Package(url: "https://github.com/IBM-Swift/todolist-web.git", majorVersion: 0, minor: 6),
         .Package(url: "https://github.com/rfdickerson/sqlite.git",majorVersion: 0, minor: 3)
    ]
)
