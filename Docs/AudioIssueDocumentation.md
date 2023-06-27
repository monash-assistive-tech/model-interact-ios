# Audio Issue Documentation

## Voice Control

#### Pros

It works.

#### Cons

It requires setup:

1. Go to Settings
2. Open Voice Control
3. Enable Voice Control
4. Select Customise Commands
5. Select Basic Navigation
6. Select "Tap \<item name>"
7. Enable it

It also is slow. And sometimes (or rather often) it doesn't hear you because of interference with the text to speech.

## DefaultToSpeaker

#### Pros

Allows both text-to-speech and speech-to-text simultaneously.

#### Cons

It works poorly simultaneously. It's often hard to have the keyword recognised because the text-to-speech is interfering with it (assuming loud volume).

Also, it always routes output to the speaker, meaning headphones and speakers are out of the question.

## DuckOthers

Works great if you've got a bluetooth device connected. Flawless. (Note that you have to use `.allowBluetoothA2DP`)

```swift
try self.audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .allowBluetoothA2DP])
```

#### Cons

If you don't have a bluetooth device connected, it automatically routes audio to the earpiece speaker. Also can suffer from interference.