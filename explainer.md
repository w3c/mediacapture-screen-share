# Screen Capture Explained

## What is it? What’s it for?

It’s an API to get a live video stream of your computer screen or a single window on it, optionally with sound.

It’s sometimes referred to as screen-sharing, even though only the capturing part is being defined (sharing is just the primary use case).

Have you ever been a presenter in an online video conference call? You probably shared your screen or the window of a presentation-program to do that. Have you ever presented in an online video conference call without this feature? You likely either had to gesticulate over printouts in front of your camera, or you had to carefully direct your audience to follow along in their own copy of previously-shared online documents, or both. This can lead to confusion as everyone can get a subtly different view. It’s a pretty key feature. This is that feature.

 * Not the networking part—that’s WebRTC’s [RTCPeerConnection](https://w3c.github.io/webrtc-pc/#interface-definition)
 * Not the camera and microphone part—that’s MediaCapture’s [getUserMedia](https://w3c.github.io/mediacapture-main/getusermedia.html#idl-def-mediadevices-partial-1)
 * **Just** the part that captures your computer's display. It’s called: [getDisplayMedia](https://w3c.github.io/mediacapture-screen-share/#mediadevices-additions)

Besides formal presentations, being able to spontaneously share what we're looking at on our computers in real-time can complement many online conversations. It's the conversational answer to "What are you looking at?"

Web sites may capture the screen for other reasons as well, but screen-sharing is the driving use-case.

## Non-goals

Some adjacent goals that are not in scope of this specification:
* Online document sharing
* Remote assistance temporarily "taking over" control of a system
* Co-browsing

## Alternatives

Alternatives to screen-sharing:
* Online document sharing using web technology.
* Browser plug-in (like Chrome's now-abandoned Screen Capture extension)

Both alternatives have adoption problems and limitations. In contrast, this spec is widely supported, and screen-sharing appears well-understood as a concept.

## Approach

The approach is heavily modeled on our [camera API](https://w3c.github.io/mediacapture-main/getusermedia.html#idl-def-mediadevices-partial-1), hence the name similarity. There’s a reason for that: both require user permission, and return a MediaStream object with a pair of highly privacy sensitive video and audio tracks—It’s just your screen instead of your face. The resulting MediaStream is a drop-in anywhere a MediaStream is accepted in the platform. Having obtained such a MediaStream, a website can trivially:

 * play the live stream of your screen locally in a video element,
 * send it over a peer connection to another client,
 * send it to a [MediaRecorder](https://w3c.github.io/mediacapture-record/MediaRecorder.html#mediarecorder-api), perhaps for subsequent upload to a server,
 * or all of the above (at once even).

This flexibility is thanks to the MediaCapture-main spec which already did the heavy lifting of:
 * defining [MediaStream](https://w3c.github.io/mediacapture-main/getusermedia.html#mediastream) and [MediaStreamTrack](https://w3c.github.io/mediacapture-main/getusermedia.html#dom-mediastreamtrack)
 * defining the constraints an application can apply to downscale and decimate frame-rates
 * defining a privacy-sensitive permission model

This leaves this spec to focus on the parts unique to acquiring display media, and its privacy challenges.

## Getting started

This is how to request a video MediaStream sourced by screen-capture:

```js
const stream = await navigator.mediaDevices.getDisplayMedia({video: true, audio: true});
```

Compare to a request for camera and microphone:

```js
const stream = await navigator.mediaDevices.getUserMedia({video: true, audio: true});
```
These streams can then be used interchangeably:

```js
videoElement.srcObject = stream; // self-view

new MediaRecorder(stream).start(); // record

for (const track of stream.getTracks()) peerConnnection.addTrack(track, stream); // present

await stream.getVideoTracks()[0].applyConstraints({height: 480}); // downscale

for (const track of stream.getTracks()) track.stop(); // stop capture & relinquish access
```

Some important differences and unique properties of screen capture:

 * The request is gated by user activation.
 * The end-user is always prompted each time with a picker to select what to share.
 * It is not possible to persist permission grants (only blocks).
 * Application-supplied constraints are applied after selection, and do not narrow the end-user’s choices (unlike with camera).
 * All choices are videos. Any accompanying audio is optional and requires consent and support.
 * Screen capture sources are never exposed in enumerateDevices().

## Security and privacy implications

Allowing a web page to capture and effectively record your screen carries significant privacy and security risks. The three main ones are, in increasing order of severity:

**Audio exposure and correlation.** When audio is captured alongside video (which requires specific end-user consent), it may expose additional information about system applications. It may contain system-wide audio in certain cases, which may include audible information from other domains.

**End-user oversharing of video.** The immediate and obvious risk is that users inadvertently share content that they did not wish to share, or might not have realized would be shared. This can happen from trivial-seeming actions like scrolling, document flipping, even tab headers, anything that’s visible if just for a split second.

**Capturing a web surface defeats same-origin protections.** Capturing a browser window or the desktop when a browser window is visible on it, poses a unique privacy and security risk that is unobvious and significant. If a captured browser window is displaying a page that is under the control of a malicious application, even indirectly, it can allow the malicious application to induce presentation of information that would otherwise be secret from it. For details, see [Share browser windows and entire screen only with sites you trust](https://blog.mozilla.org/webrtc/share-browser-windows-entire-screen-sites-trust/).

## Security and Privacy Questionnaire

See [questionnaire.md](questionnaire.md).
