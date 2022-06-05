# PhotoGallery

This iOS Application is used for fetching image from API. User can tap a specific photo and show in full screen. The selected photo can share and save in photos. 

## Requirements

- iOS 12.0+
- Xcode 12.4+
- Swift 5.3+

## Installation
Clone or download directly the repository and run PhotoGallery.xcworkspace. 

# Usage

HomeViewController is root view controller. 

class HomeViewController: UIViewController {
  /// 
}

# Architecture of HomeViewController
In HomeViewController call the API for fetching data. After callback ImageUrlViewModel notify the model for grabing the propertise thet are should to show user. 

# Which architecture is used

- MVVM
- Singleton 

