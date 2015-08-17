# ValidationKit

ValidationKit is a framework for checking data input on various constrainsts

## ValidationKit contents diagram

![alt tag](https://github.com/Streetmage/ValidationKit/blob/master/validation_kit_diagram.png)

## Podfile

```ruby
platform :ios, '7.0'
pod "ValidationKit", "0.0.3"
```

## Adding as subproject

1. In the project target settings under "Build Settings" tab search for "Header Search Paths" field and add path to the ValidationKit project directory. Also enable "recursive" search option to the right of the path you have entered.

2. In the project target under "Build Settings" tab search for "Other Linker Flags" field and add "-ObjC" flag.

3. In the project target under "Build Phases" search for "Target Dependecies" list and add "libValidationKit.a" static library.

4. In the project target under "Build Phases" search for "Link Binary With Libraries" list and add "libValidationKit.a" static library.

5. Place "#import <ValidationKit/ValidationKit.h>" where you would like to use it.