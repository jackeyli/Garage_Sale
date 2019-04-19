# garage_sale

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.


## iOS part:

####	Install [Offical guideline](https://flutter.dev/docs/get-started/install/macos#deploy-to-ios-devices)

* Install Flutter SDK

* Deploy to iOS devices

	We use Xcode to connect MacOS and iPhone. It is necessary to sign in with a personal team and sign certificate as an iPhone developer as well.

* Firebase Configuration

	We want to use firebase to save item data, and the database should match with the bundle identifier in Runner file. Meanwhile, we update the GoogleService-Info.plist document to connect firebase with our app.

#### Run

* Run Xcode in order to connect iPhone to the computer

	```
	open ios/Runner.xcworkspace/
	
	```
	to run Xcode build.
	
* Run project

	```
	Flutter run
	
	```

#### Demo

* Welcome page

	When we run our project successfully, there is a welcome page to log in using your email address.
	
* Login page
