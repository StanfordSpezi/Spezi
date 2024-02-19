# Contributing Guide

<!--

This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

Thank you for contributing to the Stanford Spezi open-source project; we value the time and effort you invest in the open-source project! This guide provides you with hints and guidance to contribute to a Swift-based Spezi repository.

> Important: This Contributing guide extens the [Contributing Guidelines](https://github.com/StanfordSpezi/.github/blob/main/CONTRIBUTING.md) with Swift-specific guidelines and hints. You MUST refer to the [Contributing Guidelines](https://github.com/StanfordSpezi/.github/blob/main/CONTRIBUTING.md) for more general information on how to contribute to the Stanford Spezi open-source project.

The keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

Spezi has a great collection of Swift Package-based modules: https://swiftpackageindex.com/StanfordSpezi.
All Swift-based Stanford Spezi repositories follow a similar setup and structure that is further described in this document.

> Tip: This guide uses the terminology defined in the <doc:Spezi-Guide> and refers to the <doc:Documentation-Guide>.

## Swift Packages

_"Swift packages are reusable components of Swift, Objective-C, Objective-C++, C, or C++ code that developers can use in their projects."_ [[Swift Packages - Apple Documentation](https://developer.apple.com/documentation/xcode/swift-packages)]. Contributing to Spezi requires a fundamental understanding of the structure of a Swift Package. Please take a look at the [Creating a standalone Swift package with Xcode article by Apple](https://developer.apple.com/documentation/xcode/creating-a-standalone-swift-package-with-xcode) detailing the structure of a Swift Package. Each Spezi Module contains a Swift Package, including the `Package.swift` file at the root of the repository.

You can open a Swift Package in Xcode by opening the Package.swift file with Xcode.
All Swift Packages are localized (learn more at [Localizing package resources - Apple Documentation](https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package)) and some Packages bundle resources such as JSON files and images ([Bundling resources with a Swift package - Apple Documentation](https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package)).
All contributions MUST use these localization features and MUST use the Swift Package Manager mechanism to bundle resources with a Swift Package.


## Testing

As noted in the [Contributing Guidelines](https://github.com/StanfordSpezi/.github/blob/main/CONTRIBUTING.md), all changes MUST be properly tested.
Therefore, all Swift Spezi Modules contain a testing setup; it is essential to test all the functionality and run those tests during the development process.
You can learn more about running tests in [Xcode: Running tests and interpreting results - Apple Documentation](https://developer.apple.com/documentation/xcode/running-tests-and-interpreting-results).

All Spezi Modules that contain user interface elements contain a UI (user interface) test application that allows us to write UI tests for the packages and test out user interfaces in a small example application.
You can find it in the `Tests/UITests` folder, and we RECOMMEND working on this project when developing a Spezi package that contains a user interface.
All user interface-related changes MUST be tested using UI tests.
The [WWDC 2020 session "Write tests to fail"](https://developer.apple.com/wwdc20/10091) is a great resource for learning more about UI testing.


## Documentation

The Swift-based Stanford Spezi modules contain a [DocC-based](https://github.com/apple/swift-docc) documentation merging inline documentation, dedicated articles, and tutorials within a single documentation bundle deployed to the Swift Package Index.
The DocC documentation archives are typically found in the Swift Package target's respective sources folder.
You can learn more about the documentation requirements for Swift-based Spezi Packages in the <doc:Documentation-Guide>.
