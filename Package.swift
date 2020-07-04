// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftVG",
     platforms: [
              .macOS(.v10_13),
              .iOS(.v13),
              .watchOS(.v5)
         ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftVG",
            targets: ["SwiftVG"]),
    ],
    dependencies: [
		  .package(url: "https://github.com/bengottlieb/Suite.git", from: "0.9.50"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "SwiftVG", dependencies: ["Suite"]),
        
 //       .testTarget(name: "SwiftVGTests", dependencies: ["SwiftVG"]),
    ]
)
