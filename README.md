# LocalServer

[![Build Status](https://travis-ci.org/db-in/LocalServer.svg?branch=master)](https://travis-ci.org/db-in/LocalServer)
[![codecov](https://codecov.io/gh/db-in/LocalServer/branch/master/graph/badge.svg)](https://codecov.io/gh/db-in/LocalServer)
[![codebeat badge](https://codebeat.co/badges/5563135f-7e49-4e66-aa44-b4f6fbb9b331)](https://codebeat.co/projects/github-com-db-in-localserver-master)
![Version](https://img.shields.io/badge/swift-4.2-red.svg)
[![Platform](https://img.shields.io/cocoapods/p/LocalServer.svg?style=flat)](https://db-in.github.io/LocalServer)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/LocalServer.svg)](https://img.shields.io/cocoapods/v/LocalServer.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Description
**LocalServer** is a framework that provides various options to create a Swift Stub Local Server right into the code, that can independently run on simulators and devices, supporting Xcode Parallel Testing. It's made in Swift to create Stub Servers, UITest Servers and providing an easy way to Mock capabilities to create Testing doubles (fakes, stubs, spies and mocks). It supports all Apple platform iOS, MacOS, WatchOS and TVOS.

It's also fully compatible with most the Networking libraries like Alamofire, Moya, AFNetworking or the native URLSession and NSURLConnection. Check the **Programming Guide** section for examples.

**Features**

- [x] Create Stub servers without changing or injecting any of your existing URLSession code
- [x] Create Stub versions for WKWebView
- [x] Supports Xcode Parallel Testing in simulators and devices
- [x] Stub Server for Unit Testing
- [x] UITest Stub Server for UI Testing

|Running App|UITest with Local Server|
|:---------:|:----------------------:|
|Random Users are generated|Only the mocked users are generated|
|![Sample App](./Resources/Sample.gif)|![Sample App](./Resources/SampleUITest.gif)|


## Installation

You can use LocalServer straight into your Unit Testing target, without any extra code to your main target. Once the Unit Test runs within the main target.

Only for UI Testing targets, it's required some extra code in the main target.

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
        .package(url: "https://github.com/db-in/LocalServer"),
    ],
    targets: [
        .target(
            name: "myproject",
            dependencies: ["LocalServer"]),
    ]
)
```

## Programming Guide
The features provided are:

- Third party Networking Libraries
- Stub Server
- UITest Server

#### Third party Networking Libraries (Alamofire, Moya, and others)

Mocking your **Unit Test Target** without modifying a single line of code in yourmain target! You don't need to polute your production code with testing libraries or create any architecture specifically for allowing testability.

Keep your production networking code the way you prefer and just to your **Unit Test Target** you add:

```swift
import LocalServer

...

StubResponse(json: ["param" : "value"])
    .withStatusCode(200)
    .send(to: "apple")
```

This code above is enough to mock any calls matching anything containing `"apple"` in the URL and returning 200 HTTP status code with the JSON mock defined above.

#### Stub Server
The Stub Server is the base for the Local Server. It can intercept any network call made with the URLSession.

![Stub Server](./Resources/StubServer.png)

These are some of the handful functions for creating `StubResponse`:

```swift
StubResponse(string: "UTF8 string to become body")
StubResponse(json: ["param" : "value", "number": 1])
StubResponse(filename: "file", ofType: "html")
StubResponse(filename: "file", ofType: "json", bundle: myBundle)
StubResponse(data: myBodyData)
```

For a more granular and specific approach, defining a different response for each HTTP:

```swift
import LocalServer

...

func startMyLocalServer() {
    let server = StubServer()
		
	server.route([.GET], url: "https://apple.com") { (request, parameters) -> StubResponse in
		return StubResponse().withStatusCode(204)
	}
	
	server.route([.POST], url: "https://apple.com") { _,_ in
		return StubResponse().withStatusCode(206)
	}
		
	StubServer.instance = server
}
```

You can also test Network errors:

```swift
StubResponse()
    .withError(MyMockNetworkError.noInternet)
    .send(to: "https://apple.com")
```

IMPORTANT: When defining the mock URL for the same HTTP method, remember that the URL uses **regex** to evaluate, which means regexes may override each other mistakenly and cause wrong behaviors.
Also the `send(to:)` is a convenient method and thus uses a shared server under the hood. It's reset everytime you set the `StubServer.instance` to `nil`. 

Once the `StubServer.instance` is defined as non-nil, it will spin the Local Server. To stop the Local Server just set it back to `nil`, which is the default value.

#### UITest Server
As per Apple design, the UITest target runs on a separated application, which means it can't have access to the code in the main application or perform any programaticaly action. The UITest Server used the `ProcessInfo` bridge to send data from the UITest target to the main application on every launch.

As per Testing best practices, every UITest case should restart the main Application.

![UITest Server](./Resources/UITestServer.png)

Project Structure

```swift
// UITest Target
 |-- LocalServer
 |-- JsonFile1.json
 |-- JsonFile2.json
 |-- JsonFile2.json
 
// Main Target
 |-- LocalServer
```

Required Code

```swift
// UITest Target
UITestResponse()
    .withStatusCode(201)
    .send(to: "google.com")

// Main Target
UITestServer.start() 
```

## FAQ
> Can I ship LocalServer to production (App Store)?

- Yes, absolutely. The main goal is to provide Mock and Stub capabilities, but nothing stops you to use it in production if required.

> If I'm only using it for Debug purpose, shall I use `#if DEBUG`?

- As a dynamic Swift framework, LocalServer will only be loaded in runtime at the moment it's first called. So if your production code never makes use of any LocalServer API, it will not even be loaded. `#if DEBUG` can be used, but as per UITest Standards, you can also consider the usage of something like `XCUIApplication().launchArguments` + `if ProcessInfo().arguments.contains("-UITests") { ... }`
- [UI Testing Quick Guide/](https://useyourloaf.com/blog/ui-testing-quick-guide)
- [Getting Started With Xcode UI Testing In Swift](https://www.swiftbysundell.com/posts/getting-started-with-xcode-ui-testing-in-swift)

> Can I simulate a slow network response?

- Yes, you can use the `delay` property in any response object to simulate that.
