//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


#if os(iOS) || os(visionOS) || os(tvOS)
public import enum UIKit.UIBackgroundFetchResult
/// Platform-agnostic `BackgroundFetchResult`.
///
/// Refer to [`UIBackgroundFetchResult`](https://developer.apple.com/documentation/uikit/uibackgroundfetchresult).
public typealias BackgroundFetchResult = UIBackgroundFetchResult // swiftlint:disable:this file_types_order
#elseif os(watchOS)
public import enum WatchKit.WKBackgroundFetchResult
/// Platform-agnostic `BackgroundFetchResult`.
///
/// Refer to [`WKBackgroundFetchResult`](https://developer.apple.com/documentation/watchkit/wkbackgroundfetchresult).
public typealias BackgroundFetchResult = WKBackgroundFetchResult
#endif
