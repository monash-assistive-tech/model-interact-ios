# TestFlight Release Guide

## Versioning

As long as the application is in TestFlight, the version (Set in Xcode, also known as the `MARKETING_VERSION`) will **always** be 1.0.0. If the app is ever released to the App Store, it would be released as version 1.0.0. The next internal TestFlight version would then be incremented, whilst adhering to [semantic versioning](https://semver.org/). Every subsequent TestFlight version would use this version until the next App Store release, in which case the cycle continues.

> Why do we release the same version to TestFlight? Why can't test flight versions differ between App Store releases?

The motivating reason for this is Apple doesn't re-review builds with the same version. If you submit version 1.0.0, then make lots of new changes and updates, and release a new build also with version 1.0.0, Apple won't review it - it gets immediately approved. If you were to increment the version number and make those same changes, you'd have to wait for Apple reviewers to re-review the app. There are no drawbacks to keeping the version number the same between builds.

The different versions are still differentiable. Every time you release a new version to App Store Connect, it gets a build number, starting at (1). If you release another build with the same version, the build number increments. So 1.0.0 (1) would be followed by 1.0.0 (2). **This process is done automatically**, so don't change the build number via Xcode. The build number is visible to testers so testers will still be aware when they're testing a new version.

> How about the old version releases?

The app originated in a different repository. [That repository tracked releases all the way up to Release 1.1.1](https://github.com/Andre-Pham/LemonApp/releases). So are we just forgetting the version numbers for those releases? Yep. As of moving to the repository `kalin-stefanov-at/model-interact-ios`, all new releases should start at 1.0.0, and the previous releases from the previous repository should be dismissed.

## Review & Test Information

*This is the information that is passed onto the Apple Reviewers. I have been unable to find anywhere to provide assets (images, videos) for TestFlight reviews, so none have been provided.*

#### Beta App Description

An iOS application for audibly recognising commands and providing text-to-speech feedback based on object recognition using the device's camera. Requires "Beesly", a modular toy insect for the app to interact with.

Commands:

"Name" (States the name of the insect part you're holding + sound effect)

"Information" (Provides information on the insect part you're holding; let go to stop listening)

"What does this connect to?" (Provides information on what part of the insect you're holding connects to; let go to stop listening)

"Completed?" (States whether the insect is complete or not + sound effect)

"Quiz Me" (Begins a quiz question)

"Add Label" (Begins recording an audio label for the insect part you're holding, sound effect indicates start and end; let go to stop recording, or wait for 10 second timeout)

"Label" (Plays back the label you recorded for the insect part you're holding)

#### Review Notes

This application requires "Beesly", a modular toy insect for the app to interact with. Hence it cannot be tested the exact way it will be used, since any reviewer requires the physical 3D model insect to properly use the application. The application is designed for blind students in a classroom environment, hence there's no UI - the entire screen is a camera feed, since the app is intended to be launched, then the device set up on an overhead stand and interacted with fully by voice.

Here is a demo of the app in action: https://www.youtube.com/watch?v=TjlqPy4F1xg

HOW TO TEST WITHOUT THE MODEL INSECT:
The application can be "tricked" by showing a picture of the insect instead of the real thing. So if you open up the video provided (pause it), open up the app, show the video's paused frame to the app, and give a command (e.g. "name"), the app will recognise the picture and respond (though, it's not nearly as reliable as having the real object). There are some important notes to this:
- For many commands, the app will only respond if a hand is holding the piece in focus. So if you wish to know the name of the blue piece (the thorax), and it's showing on screen, but a hand isn't holding it, the app won't respond about it. You will either need to pause the video on a frame where the hand in the video is holding the piece, or you will need to hold your actual hand up to the screen in close enough proximity to the piece to trick the app into thinking you're holding it.
- Currently, if no audio activity (commands provided) occurs over a consecutive minute, Apple's speech-to-text technology idles out and stops using the microphone. The app then needs to be restarted. This will be addressed in a future version.