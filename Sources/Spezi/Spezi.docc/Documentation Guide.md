# Documentation Guide

<!--

This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

Defines the documentation requirements for Spezi modules, including hints and examples on structuring the documentation your Spezi module, Swift Package, and repository.

The keywords "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

> Tip: This guide uses the terminology defined in the <doc:Spezi-Guide>.

The module MUST conform to this guide within two months after changes have been published to be considered in conformance with this guide.

The README and documentation of the [SpeziMockWebService module](https://github.com/StanfordSpezi/SpeziMockWebService) are good examples of how documentation can be structured and written.


## Code Documentation

Serves as general guidance for writing documentation.
All public interfaces of a Spezi module MUST be documented with non-trivial documentation that SHOULD guide a wide variety of users on how to use the application programming interface (API).

Text MUST be written in a neutral form in conformance to the [contribution guidelines](https://github.com/StanfordSpezi/.github/blob/main/CONTRIBUTING.md) and the [contributor covenant code of conduct](https://github.com/StanfordSpezi/.github/blob/main/CODE_OF_CONDUCT.md).
Abbreviations SHOULD be expanded the first time they are used.
Inline documentation SHOULD have real-world examples and links to relevant information outside of the Spezi ecosystem to read up on important concepts.

The documentation MUST use appropriate [GitHub markdown syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) and [DocC documentation formatting elements](https://www.swift.org/documentation/docc/formatting-your-documentation-content) to create documentation that is easy to understand and well structured. 

Related types within the module MUST be linked using [markdown links](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#links) or [DocC links](https://www.swift.org/documentation/docc/formatting-your-documentation-content#Link-to-Symbols-and-Other-Content).
Essential external types SHOULD be linked to, e.g., the Apple Documentation like the [`@State`](https://developer.apple.com/documentation/swiftui/state) property wrapper.

Code examples MUST use proper syntax highlighting, e.g.,:
````md
```swift
let name = "Paul"
```
````

Elements like [notes and other asides](https://www.swift.org/documentation/docc/documenting-a-swift-framework-or-package) SHOULD be used.
GitHub offers equal elements for README documents, e.g.:
```md
> [!IMPORTANT] 
> An important element ...
```
The same elements should be used for the equivalent DocC-based documentation:
```md
> Important: An important element ...
```

You SHOULD use [`@_documentation(visibility: ...)`](https://github.com/apple/swift/blob/main/docs/ReferenceGuides/UnderscoredAttributes.md#_documentationvisibility-) to hide elements from the documentation that should not appear in the public documentation.
It is RECOMMENDED to use `@_documentation(visibility: internal)` to an `@_exported import` statement to ensure that all public symbols of the imported module are not exposed in the documentation of the Spezi module.

You can learn more about DocC by reading the documentation or watching the DocC Apple World Wide Developer Conference (WWDC) videos:
- [swift.org - DocC Documentation](https://www.swift.org/documentation/docc/#)
- [WWDC 2023 - Create rich documentation with Swift-DocC](https://developer.apple.com/wwdc23/10244)
- [WWDC 2022 - Improve the discoverability of your Swift-DocC content](https://developer.apple.com/wwdc22/110369)


### Images

All images MUST be available in dark and light mode.
The document MUST be configured to automatically load the appropriate image, e.g., in markdown using
```md
![Example Image](https://raw.githubusercontent.com/StanfordSpezi/.github/main/Example.png#gh-light-mode-only)
![Example Image](https://raw.githubusercontent.com/StanfordSpezi/.github/main/Example~dark.png#gh-dark-mode-only)
```
and using the [DocC Image naming schemes](https://developer.apple.com/documentation/docc/image#Provide-Image-Variants).

User interface screenshots MUST include a device frame, e.g., using [ControlRoom](https://github.com/twostraws/ControlRoom) or other software solutions. The background of the images MUST be transparent to use the background color of the documentation document or README.


### Landing Page

The [landing page](https://www.swift.org/documentation/docc/documenting-a-swift-framework-or-package) of the documentation in DocC MUST contain an overview section.
The overview section MUST include a compact package description and its core functionality.
A developer MAY use bullet points, a table, or a textual description.

If the module provides significant user interface (UI) components, it SHOULD display them in the README to provide visual guidance.
The overview SHOULD include a graphical representation of the package's functionality, e.g., a UML diagram or some other visual guidance.

The landing page MAY also include a code example.
It MUST link to the main types relevant to the Spezi module and SHOULD provide some guidance to articles that guide the user to learn more about the module.


### Articles

More comprehensive module features SHOULD be explained in articles and extension files guiding developers on using the API and other functionality.
You can learn more about adding supplemental content to a documentation in the [swift.org - Adding Supplemental Content to a Documentation Catalog article](https://www.swift.org/documentation/docc/adding-supplemental-content-to-a-documentation-catalog).


## README

The README of a Spezi Module is an essential first point of contact.
It MUST include the following sections:
- Header
- Overview
- Example
- Footer
A README may include additional sections after the overview and before the Footer section.
The README SHOULD reuse the content of the landing page DocC documentation of the Spezi module. It MAY add context relevant to the GitHub repository compared to the automatically generated documentation.


### Header

The Header MUST display the most essential documentation for a Spezi Module, including:
- GitHub badge to a GitHub Action verifying the current build status
- CodeCov code coverage report
- One-line description of the module.

It is RECOMMENDED to include a:
- DOI for scientific citations, e.g., using [Zenodo.org](https://zenodo.org)
- Badges to the [Swift Package Index](https://swiftpackageindex.com) for Swift package-based Spezi modules to indicate the supported Swift version and operating systems.


### Overview

The overview section MUST be equivalent to the landing page overview section of the DocC documentation.
It MAY make slight modifications to adjust for the different formatting possibilities.
DocC links MUST be translated into links to the hosted documentation, e.g., on the [Swift Package Index](https://swiftpackageindex.com) using markdown links.


### Example

The example section MUST include one or more code examples or short guidance on using the Spezi Module.
The examples MAY be taken out of the inline documentation or articles in the DocC documentation.
It MUST provide some written guidance around the example.
The example MUST provide a link to more information about the place where the documentation is hosted, e.g., on the [Swift Package Index](https://swiftpackageindex.com).

E.g., a final sentence MAY look like this:
```md
For more information, please refer to the [API documentation](https://swiftpackageindex.com/StanfordSpezi/Spezi/documentation).
```

### Footer

The footer of all Spezi Modules MUST include a link to the contributing guidlines, code of conduct, and license information.
All Spezi modules hosted in the StanfordSpezi GitHub organization MUST include the footer below.
Other Spezi modules MAY use the same footer but MUST adjust it to link to their documents, e.g., contributing guidelines.
```md
## Contributing

Contributions to this project are welcome. Please make sure to read the [contribution guidelines](https://github.com/StanfordSpezi/.github/blob/main/CONTRIBUTING.md) and the [contributor covenant code of conduct](https://github.com/StanfordSpezi/.github/blob/main/CODE_OF_CONDUCT.md) first.


## License

This project is licensed under the MIT License. See [Licenses](https://github.com/StanfordSpezi/Spezi/tree/main/LICENSES) for more information.

![Spezi Footer](https://raw.githubusercontent.com/StanfordSpezi/.github/main/assets/Footer.png#gh-light-mode-only)
![Spezi Footer](https://raw.githubusercontent.com/StanfordSpezi/.github/main/assets/Footer~dark.png#gh-dark-mode-only)
```

## Further Details

GitHub repository SHOULD include the main description of the Spezi module and SHOULD link to the hosted documentation, e.g., at the [Swift Package Index](https://swiftpackageindex.com) in the sidebar of the GitHub repo.
GitHub tags like `Spezi` and others MAY be used to easily find the module on GitHub or the [Swift Package Index](https://swiftpackageindex.com).
