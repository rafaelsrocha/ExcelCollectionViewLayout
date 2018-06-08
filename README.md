# ExcelCollectionViewLayout

[![Version](https://img.shields.io/cocoapods/v/ExcelCollectionViewLayout.svg?style=flat)](http://cocoapods.org/pods/ExcelCollectionViewLayout)
[![License](https://img.shields.io/cocoapods/l/ExcelCollectionViewLayout.svg?style=flat)](http://cocoapods.org/pods/ExcelCollectionViewLayout)
[![Platform](https://img.shields.io/cocoapods/p/ExcelCollectionViewLayout.svg?style=flat)](http://cocoapods.org/pods/ExcelCollectionViewLayout)
[![Language](https://img.shields.io/badge/swift-4.0-green.svg?style=flat)](https://developer.apple.com/swift)

Based on [Brightec’s solution](http://www.brightec.co.uk/ideas/uicollectionview-using-horizontal-and-vertical-scrolling-sticky-rows-and-columns) this pod will allow you to have an UIColletionView working like an Excel (PC) or Numbers’ (OS X) sheet. Plus, and not less important, you will have the total control about your UICollectionView's design and how it should look like!

This is the expected behavior in the implemented UICollectionView:

<p align="center">
    <img src="http://i.imgur.com/p1NNqOv.gif" alt="UICollectionView's expected behavior"/>
</p>

## Requirements

- iOS 8.0+
- Xcode 8.0+
- Swift 4.0

## Installation

### CocoaPods

ExcelCollectionViewLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ExcelCollectionViewLayout'
```

### Manually

Just drag and drop [ExcelCollectionViewLayout.swift](https://github.com/rafaelsrocha/ExcelCollectionViewLayout/tree/master/ExcelCollectionViewLayout/Classes/) inside your project.

## Usage

Set ExcelCollectionViewLayout as your UICollectionView's layout:

- Go to your UICollectionView's inspector
- Select `Custom` in the Layout selector
- Type `ExcelCollectionViewLayout` in the Class selector (it should autocomplete and/or appear in the dropdown list).

<p align="center">
    <img src="https://i.imgur.com/hPeEgzS.png" alt="UICollectionView's inspector" height="200" />
</p>

Set ExcelCollectionViewLayout's delegate, responsible for calculating each column's items' size:

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    if let collectionLayout = collectionView.collectionViewLayout as? ExcelCollectionViewLayout {
        collectionLayout.delegate = self
    }
}
```

After setting `ExcelCollectionViewLayoutDelegate`, you must implement the delegate's method which will allow you to calculate column's items' size or just set it arbitrarily:

```swift
func collectionViewLayout(_ collectionViewLayout: ExcelCollectionViewLayout, sizeForItemAtColumn columnIndex: Int) -> CGSize {
    return CGSize(width: 100, height: 50)
}
```
PS.: This pod's example has a good example of calculated items' size.

And we are all set up! As said before, you still have the total control about your UICollectionView's design and how it should be like, all it takes care of is the UICollectionView's cells arrangement!

Keep in mind: when setting UICollectionViewDataSource's methods the sections are the rows and rows are the columns.

<p align="center">
    <img src="http://i.imgur.com/BKINMqC.png" alt="Section-row relationship." />
</p>

## Example

To run the example project simply type `pod try ExcelCollectionViewLayout` on Terminal. Or clone the repo, and run `pod install` from the Example directory first.

## Author

Created, updated and maintained by [Rafael Rocha](https://github.com/rafaelsrocha).

## License

ExcelCollectionViewLayout is available under the MIT license. See the LICENSE file for more info.
