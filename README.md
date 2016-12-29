# ValidationKit

## Developed by <a href="http://www.inostudio.com/">INOSTUDIO</a> 

ValidationKit is a framework for checking data input on various constrainsts

## ValidationKit contents diagram

![alt tag](https://github.com/Streetmage/ValidationKit/blob/master/validation_kit_diagram.png)

## Podfile

```ruby
platform :ios, '7.0'
pod "ValidationKit", "0.0.5"
```

## Adding as subproject

1. Copy all ValidationKit files to your project's folder.

2. Add ValidationKit as subproject, press and hold ValidationKit.xcodeproj file and then drag it under your project in the navigator menu.

3. In the project target settings under "Build Settings" tab search for "Header Search Paths" field and add path to the ValidationKit project directory. Also enable "recursive" search option to the right of the path you have entered.

4. In the project target under "Build Settings" tab search for "Other Linker Flags" field and add "-ObjC" flag.

5. In the project target under "Build Phases" search for "Target Dependecies" list and add "libValidationKit.a" static library.

6. In the project target under "Build Phases" search for "Link Binary With Libraries" list and add "libValidationKit.a" static library.

7. Place "#import &lt;ValidationKit/ValidationKit.h&gt;" where you would like to use it.