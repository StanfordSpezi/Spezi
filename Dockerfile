#
# This source file is part of the Stanford Spezi open-source project
#
# SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
#
# SPDX-License-Identifier: MIT
#

FROM swift:latest AS build

WORKDIR /build
COPY ./Package.* ./
COPY . .

RUN swift package resolve

# Run Tests
RUN swift test