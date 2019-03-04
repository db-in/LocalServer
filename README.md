# LocalServer

[![Build Status](https://travis-ci.org/db-in/LocalServer.svg?branch=master)](https://travis-ci.org/db-in/LocalServer)
[![codecov](https://codecov.io/gh/db-in/LocalServer/branch/master/graph/badge.svg)](https://codecov.io/gh/db-in/LocalServer)
[![codebeat badge](https://codebeat.co/badges/5563135f-7e49-4e66-aa44-b4f6fbb9b331)](https://codebeat.co/projects/github-com-db-in-LocalServer-master)
![Version](https://img.shields.io/badge/swift-4.1-red.svg)
[![Platform](https://img.shields.io/cocoapods/p/LocalServer.svg?style=flat)](https://db-in.github.io/LocalServer)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/LocalServer.svg)](https://img.shields.io/cocoapods/v/LocalServer.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Description
**LocalServer** is a framework...

**Features**

- [x] Automatically creates Markov Chain based on a given sequence of transactions;
- [x] Allows manual matrix manipulation for mutating members;
- [x] Pretty printed matrix for debugging;

## Installation

### Using [CocoaPods](https://cocoapods.org)

Add to your **Podfile** file

```
pod 'LocalServer'
```

### Using [Carthage](https://github.com/Carthage/Carthage)

Add to your **Cartfile** or **Cartfile.private** file

```
github "db-in/LocalServer"
```

### Using [Swift Package Manager](https://swift.org/package-manager)

Add to your **Package.swift** file

```swift
let package = Package(
    name: "myproject",
    dependencies: [
        .package(url: "https://github.com/dineybomfim/LocalServer"),
    ],
    targets: [
        .target(
            name: "myproject",
            dependencies: ["LocalServer"]),
    ]
)
```

## Programming Guide
The features are:

- Initialization
- Feature-1
- Feature-2
- Feature-3

#### Initialization
Start by importing the package in the file you want to use it.

```swift
import LocalServer
```

#### Feature-1
Describe usage of Feature-1

```swift
// Some code for Feature-1
```

## FAQ
> Possible Question-1?

- Answer for Question-1
