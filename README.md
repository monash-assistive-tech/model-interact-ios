<div align="center">
  <img src="beesly_splash.png" width="100">
</div>

# Beesly

An iOS application for audibly recognising commands and providing text-to-speech feedback based on object recognition using the device's camera.

## Demos

Main Demo: [YOUTUBE LINK](https://youtu.be/TjlqPy4F1xg)

Debug Demo: [YOUTUBE LINK](https://youtube.com/watch?v=f7iVb2a4-H8?feature=share)

Main Demo (Version 1.0.1): [YOUTUBE LINK](https://youtu.be/MiDen_XEZX8)

## Commands

* **"Name"** *(States the name of the insect part you're holding + sound effect)*
* **"Information"** *(Provides information on the insect part you're holding; let go to stop listening)*
* **"What does this connect to?"** *(Provides information on what part of the insect you're holding connects to; let go to stop listening)*
* **"Completed?"** *(States whether the insect is complete or not + sound effect)*
* **"Quiz Me"** *(Begins a quiz question)*
* **"Add Label"** *(Begins recording an audio label for the insect part you're holding, sound effect indicates start and end; let go to stop recording, or wait for 10 second timeout)*
* **"Label"** *(Plays back the label you recorded for the insect part you're holding)*

## Feature Set

The application is currently capable of:

* Object detection (insect tagmata)
* Completion detection (completing when the insect is complete)
* Hold detection (detecting when you're holding part of the insect)
* Multi-hand detection (notifying you if you're using more than one hand to hold more than one part of the insect)
* Let go detection (detecting when you've let go of a specific piece and stopping any ongoing audio description of the piece being described if you do let go)
* Receiving commands via speech-to-text (speech recognition)
* Giving feedback via text-to-speech (speech synthesis)
* Hand detection (detecting the joints of any hands in frame)
* Hand pose detection (detecting when your hand performs a certain pose)
* Audio on-device recording (recording audio labels for the insect parts)
* Audio playback (local files and on-device recorded audio) 
* Speaker and VOIP audio modes (standard audio modes you find in all voice-chat apps) 
* Camera stream input (both front and back facing cameras)
* Question-and-response quiz mode that supports both auditory and visual answers

## Technology Stack

This is a native iOS/iPadOS application.

| Technology                      | What's Used                                                  |
| ------------------------------- | ------------------------------------------------------------ |
| Language                        | [Swift](https://developer.apple.com/documentation/swift)     |
| UI Framework                    | [UIKit](https://developer.apple.com/documentation/uikit)     |
| Video and Camera Framework      | [AVFoundation](https://developer.apple.com/documentation/avfoundation/) |
| Audio (including TTS) Framework | [AVFoundation](https://developer.apple.com/documentation/avfoundation/) |
| Speech-to-Text Framework        | [Speech](https://developer.apple.com/documentation/speech/)  |
| Machine Learning Framework      | [Create ML](https://developer.apple.com/documentation/createml) |
| Hand Recognition Framework      | [Vision](https://developer.apple.com/documentation/vision/)  |

The application is broken down into these fundamental layers, each of which are within the application's root directory:

* **`Lemon/Strings`**: The application's string resources.
* **`Lemon/Core`**: Convenience/utility classes used anywhere.
* **`Lemon/Swift`**: Extensions to the Swift language.
* **`Lemon/App`**: Classes that manage the app's lifecycle. Also includes any app-level files and certificates such as `Info.plist`.
* **`Lemon/Model Layer`**: The Model layer of MVC. Contains all application logic and data structures.
* **`Lemon/View Layer`**: The View-Controller layer of MVC. Contains all interaction logic, UI, rendering, assets, and styling classes.
