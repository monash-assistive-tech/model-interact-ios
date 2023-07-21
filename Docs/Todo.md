# Lemon Todo

* Try out continuous compiling, so instead of compiling, say, 10 predictions then compiling then removing all the predictions, constantly keep the last 10 predictions and constantly have new results ready based of the last 10 predictions
* Refactor overlay views to be in an array with a protocol `OverlayView`, also clean them up in general
* Add a mega toggle which toggles everything on the screen (like a FAB)





TODO:

* Make it so when the user lets go, it stops speaking
* ~~Polish audio~~
* ~~Get it working on iPad~~
* ~~Get it working if the screen rotates~~
* ~~Fix the fact that the camera initially freezes~~
* ~~Make it more lenient with the wings~~
* ~~Make it so it compiles the result continuously ("continuous compiling" above)~~
    * ~~Actually this may not be advantageous - if the user shows the insect and asks "complete?" immediately the answer will be "no" because of the last 10 frames, only the most recent will have shown the insect~~
    * ~~Actually I may consider adding a `clear` function to the compiled results thing so that when a new command is entered before the command is assigned I clear the compiled results so it can't answer too quickly~~
* Try out depth for detecting which the user is holding
* Try out improved algorithms for which piece the user is holding
* ~~Refactor `merged` and `mergeAll` to `unison` and `unisonAll`~~
* Add "wings are in the wrong place" to compiled results
* ~~Polish commands~~
* ~~Optimise models so it only detects when there's a command loaded~~
* Remove hand pose classification model if no longer necessary
