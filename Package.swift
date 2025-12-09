// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "MetaWear",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
    ],
    products: [
        .library(name: "MetaWear", targets: ["MetaWearCpp", "MetaWearCore", "MetaWearAsyncUtils", "MetaWearDFU", "MetaWearUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/BoltsFramework/Bolts-Swift.git", from: "1.5.0"),
        .package(url: "https://github.com/NordicSemiconductor/IOS-DFU-Library.git", from: "4.15.0"),
    ],
    targets: [
        .target(
            name: "MetaWearCpp",
            path: "MetaWear/MetaWear-SDK-Cpp",
            sources: [
                "src/metawear/core",
                "src/metawear/dfu",
                "src/metawear/impl",
                "src/metawear/peripheral",
                "src/metawear/platform",
                "src/metawear/processor",
                "src/metawear/sensor",
            ],
            publicHeadersPath: "src",
            cxxSettings: [
                .headerSearchPath("src")
            ]
        ),
        .target(
            name: "MetaWearCore",
            dependencies: [
                "MetaWearCpp",
                .product(name: "BoltsSwift", package: "Bolts-Swift")
            ],
            path: "MetaWear",
            exclude: ["Tests"],
            sources: [
                "Core",
                "MetaWear-SDK-Cpp/bindings/swift"
            ],
            linkerSettings: [
                .linkedFramework("CoreBluetooth")
            ]
        ),
        .target(
            name: "MetaWearAsyncUtils",
            dependencies: ["MetaWearCpp", "MetaWearCore"],
            path: "MetaWear/AsyncUtils"
        ),
        .target(
            name: "MetaWearUI",
            dependencies: [
                "MetaWearCpp",
                "MetaWearCore",
                "MetaWearAsyncUtils"
            ],
            path: "MetaWear/UI"
        ),
        .target(
            name: "MetaWearDFU",
            dependencies: [
                "MetaWearCpp",
                "MetaWearCore",
                .product(name: "NordicDFU", package: "IOS-DFU-Library")
            ],
            path: "MetaWear/DFU"
        )
    ]
)