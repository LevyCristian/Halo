# **Halo**

A implementation of a TV series app, using the API provided by the TVMaze
[TVMaze Api](https://www.tvmaze.com/api) website, written in Swift 5 using Dependency Injection, MVVM, Repository, Some aspects of Clean Architecture, ViewCode patterns, SwiftLint and Travis.

<p float="left">
<img src="./images/1.PNG" width=200>
<img src="./images/2.PNG" width=200>
<img src="./images/3.PNG" width=200>
<img src="./images/4.PNG" width=200>
<img src="./images/5.PNG" width=200>
</p>


## **How to run**

### Requirements

1. Xcode 11.0+
2. iOS 13.0+ (n-2 Pattern, based on iOS 15)
3. SwiftLint installed in your Mac (Opitional if you're not developing)

### **Getting started**

1. Open the Terminal app and run.

```
brew install swiftlint
```
*Note: See [SwiftLint page](https://github.com/realm/SwiftLint) for more informations

2. Open the project file and you are ready to go.
*Note: you can run the tests either using `CMD+U` on Xcode.

## **Essential Topics**

### **Apps Features**

1. List all of the series contained in the API used by the paging scheme provided by the
API.
2. Allow users to search series by name.
3. After clicking on a series, the application should show the details of the series.
4. After clicking on an episode, the application should show the episode’s information.
 
### **Architecture** 

I decided to implement this app using MVVM pattern. Each component: View, View model, and Model have only one job to do, keeping a good single responsibility. I also designed each component to work with Dependency Injection, different parts of this code should not depend on concrete classes. They don’t need that knowledge. This encourages the use of protocols instead of using concrete classes to connect parts of this app. Besides that, the project was structured on the Clean architecture pattern. So, if you're familiar with it, you would understand some components jobs faster.


### **UI Design Pattern**

For this example, I followed with the ViewCode pattern that allows a good separated way to implement the UI and make it reusable. So, you'll see a good example of how to structure an app with ViewCode and a couple of extensions developed by me that can make your work easier.


### **Network Layer**

The app's network layer was made to be reusable in a way to handle generic types allowing a decode of any time for any endpoint available. This implementation allows the minimal change in the app provider to add new endpoints. Along with that, I used the Repository pattern as a layer to create a component to handle only with conection with the app's network infrastructure.


### **Code Quality and Documentation**

To ensure the code design quality, Swiftlint was used to guide the development of this code. I also documented the whole network layer to make sure that each complex component was propely explained to make the understadment of it easier.


### **CI Pipeline**

Travis was used in this app to make sure that everything was working before merged, so I ran tests for each pull request through Travis. 


### **Tests**

The app's coverage is about 50%. The network layer is fully tested and each network test was implemented mocking the HTTPURLProtocol. The dependency injection created a easy way to test each component.


## **Third-party libraries**

### **Nimble (https://github.com/Quick/Nimble)**

Use Nimble to express the expected outcomes of Swift or Objective-C expressions. In the app, it is used during the tests to help written good and readable outputs.

### **Quick (https://github.com/Quick/Quick)**

Quick is a behavior-driven development framework for Swift and Objective-C. In the app, it is used to write each test to be more readable with nimble.

## **Author**

Levy Anjos
