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


extension AsyncCompactMapSequence: TypedAsyncSequence {}
extension AsyncDropFirstSequence: TypedAsyncSequence {}
extension AsyncDropWhileSequence: TypedAsyncSequence {}
extension AsyncFilterSequence: TypedAsyncSequence {}
extension AsyncFlatMapSequence: TypedAsyncSequence {}
extension AsyncMapSequence: TypedAsyncSequence {}
extension AsyncPrefixSequence: TypedAsyncSequence {}
extension AsyncPrefixWhileSequence: TypedAsyncSequence {}

extension AsyncThrowingCompactMapSequence: TypedAsyncSequence {}
extension AsyncThrowingDropWhileSequence: TypedAsyncSequence {}
extension AsyncThrowingFilterSequence: TypedAsyncSequence {}
extension AsyncThrowingFlatMapSequence: TypedAsyncSequence {}
extension AsyncThrowingMapSequence: TypedAsyncSequence {}
extension AsyncThrowingPrefixWhileSequence: TypedAsyncSequence {}
