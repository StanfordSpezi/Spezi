//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 CardinalKit and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


public protocol TypedAsyncSequence<Element>: Sendable, AsyncSequence { }

extension AsyncStream: TypedAsyncSequence {}
extension AsyncThrowingStream: TypedAsyncSequence {}
