# Interactions with Application

Interact with the Application.

<!--

This source file is part of the Stanford Spezi open-source project

SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT

-->

## Overview

Spezi provides platform-agnostic mechanisms to interact with your application instance.
To access application properties or actions you can use the ``Module/Application`` property wrapper within your
``Module`` or ``Standard``.

> Tip: The <doc:Notifications> articles illustrates how you can easily manage user notifications within your Spezi application. 

## Topics

### Application Interaction

- ``Module/Application``

### Properties

- ``Spezi/logger``
- ``Spezi/launchOptions``

### Actions

- ``Spezi/registerRemoteNotifications``
- ``Spezi/unregisterRemoteNotifications``

### Platform-agnostic type-aliases

- ``ApplicationDelegateAdaptor``
- ``BackgroundFetchResult``
