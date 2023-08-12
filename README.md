<br>
<h3 align="center">
  <img src="https://github.com/swiftyfinch/Fish/assets/64660122/bf12977c-b864-4f71-9e21-153136062ebc" />
  <br>
  Fish
  <br>
</h3>

# Motivation

I used the [Files](https://github.com/JohnSundell/Files) in [the first Rugby version](https://github.com/swiftyfinch/Rugby/blob/1.23.0/Package.swift#L15).
But this library has some drawbacks:\
`-` There are some issues with files enumeration;\
`-` It has limited testability;\
`-` Now it looks like a public archive. The last request was merged in 2022.

## Description

`Fish` is a small library that was developed to solve the above problems.\
It providing convenient wrappers for interacting with the file system.\
Under the hood it uses [`FileManager`](https://developer.apple.com/documentation/foundation/filemanager) and other parts of [`Foundation`](https://developer.apple.com/documentation/foundation).

This library was a part of 🏈 [Rugby 2.x](https://github.com/swiftyfinch/Rugby).

<br>

# How to install 📦

Add it to the dependencies for your package. More info [here](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app).
```swift
.package(url: "https://github.com/swiftyfinch/Fish", from: "0.1.0")
```

## How to use 🚀

```swift
let file = try Folder.current.createFile(
    named: "example.txt",
    contents: "Hello world!"
)
try file.append("You can find more info in docs.")
try file.delete()
```
