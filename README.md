# How to setup

First, install cocoapods
  ``` 
  brew install cocoapods 
  ```
Then, clone the project, using Xcode or using terminal 
  ``` 
  git clone https://github.com/bigbowl-sem/bigbowl-iOS.git
  ```
In your terminal, run the follow command in the root directory (/bigbowl-iOS)

```
pod install
```
When launching in Xcode, OPEN bigbowl-iOS.xcworkspace <b>(NOT bigbowl-iOS.xcodeproj)</b>, otherwise things will not work with cocoa dependencies

# About

Cocoapods is a dependency manager, and we use it to make use of the Stripe SDK

