# ``Account``

<!--
                  
This source file is part of the CardinalKit open-source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->

The ``Account/Account`` module provides convenient ways to display account-related functionalty including login, sign up, and reset password flows.


## Overview

TODO: How to setup the ``Account/Account`` module in the Delegate.
TODO: How to use the views in some parts of the application (SignUp and Login)


## Topics

### Account Services

- <doc:CreateAnAccountService>
- ``Account/AccountService``

### Views

The ``Account/Account`` module provides several views that can be used to provide login, sign up, and reset password flows using the defined ``Account/AccountService``s.

- ``Account/SignUp``
- ``Account/Login``

### Username And Password Account Service

TODO: Short Description of UsernamePasswordAccountService.

- ``UsernamePasswordAccountService``
- ``UsernamePasswordSignUpView``
- ``UsernamePasswordLoginView``
- ``UsernamePasswordResetPasswordView``

### Email And Password Account Service

The ``EmailPasswordAccountService`` is a ``UsernamePasswordAccountService`` subclass providing email related validation rules and 
customized view buttons enabeling the creation of an email and password-based ``AccountService``.

- ``EmailPasswordAccountService``
