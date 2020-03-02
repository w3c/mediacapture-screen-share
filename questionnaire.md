# Security and Privacy Questionnaire for Screen Capture

## Questions to Consider

### 2.1. What information might this feature expose to Web sites or other parties, and for what purposes is that exposure necessary?

With a user’s permission, it exposes to a website a live video stream of the user’s desktop, or a window of their choosing, optionally with accompanying audio, if available and consented to.
The user may choose a **physical** or **virtual monitor**, a **window**, an **application**, or a **browser**. All information visible on the chosen surface is shared. Audible information may also be shared. In addition, depending on the surface, information that’s not currently visible may also be shared. For example: an entire window including parts presently offscreen or obscured by other windows.
The purpose of the feature is to allow people to share their screen, if they so choose, with others, typically in an online video conference or one-on-one call. A presenter may wish to share the window of their presentation program. Friends and relatives may wish to spontaneously share what they’re looking at on their computer or device to aid or complement a conversation.
See [explainer](explainer.md) for more.

### 2.2. Is this specification exposing the minimum amount of information necessary to power the feature?

The decision of what to share (or whether to share anything at all) rests entirely with the end-user. Websites cannot influence this choice in any way, or demand audio be included. A user gesture is required to request, and users may reject or even block all requests. Defining the pool of available sources is left to user agents, as well as decisions about whether to share obscured parts. The spec requires user agents to implement prominent indicators warning users when sharing is live.

### 2.3. How does this specification deal with personal information or personally-identifiable information or information derived thereof?

Nothing is shared without a user’s explicit choice. The spec uses the permissions [[PERMISSIONS]](https://www.w3.org/TR/security-privacy-questionnaire/#biblio-permissions) spec to persist denied permissions, and mandates an explicit per-use in-browser chooser prompt. By choosing a surface to share, the end user permits a website one-time access to continuous video (optionally with audio) of that surface, until the website stops the video and/or audio track, the page navigates away, or the user revokes the permission, whichever is sooner. A name (label) of the surface is also shared (e.g. the title of a window) with the track.

This is a powerful feature, restricted to secure contexts. No attempt is made to mandate that personal information, sensitive information or cross-origin content be detected and blacked out. To some extent, this is a feature.

### 2.4. How does this specification deal with sensitive information?

Per above, nothing prevents a user from sharing a surface that contains sensitive information.
But additionally, the spec strongly advises user agents require [elevated permissions](https://w3c.github.io/mediacapture-screen-share/#elevated-permissions) to share **browser surfaces** or **monitors** with browsers visible. These sources carry **significant risk**, as sensitive information may be leaked through **active attacks on the same-origin policy**. For details, see [Share browser windows and entire screen only with sites you trust](https://blog.mozilla.org/webrtc/share-browser-windows-entire-screen-sites-trust/).

### 2.5. Does this specification introduce new state for an origin that persists across browsing sessions?

Nothing is revealed without permission, and grants cannot be persisted. Permission blocking follows feature-policy. See next question.

### 2.6. What information from the underlying platform, e.g. configuration data, is exposed by this specification to an origin?

Depending on what a user chooses to share, a website may learn physical properties of their system, such as the size and appearance of their desktop, and any information displayed, e.g. possibly their local time and location (weather) if the user has configured such display on their desktop. This can be correlated to other origins that are using the same API, if  the user shares the same surface there.

### 2.7. Does this specification allow an origin access to sensors on a user’s device

Results from sensors may be exposed. While screen-capture is live, the origin may record the result of the user's activity on the system, including, for instance, cursor movements in response to mouse movements.

Also, no attempt is made to mandate that camera and microphone sourced playback be excluded from capture. Same with a location shown on a map (from GPS sensors). Users might perceive such mitigations as bugs.

### 2.8. What data does this specification expose to an origin? Please also document what data is identical to data exposed by other features, in the same or different contexts.

(This question’s template mentions [same-origin policy](https://www.w3.org/TR/security-privacy-questionnaire/#same-origin-policy) so following that lead) As mentioned earlier, **browser** and **monitor** surfaces may be exploited to circumvent the [same-origin policy](https://www.w3.org/TR/security-privacy-questionnaire/#same-origin-policy), exposing details about another origin’s state in graphical or audible form, which if extracted may be used in POST or GET requests to another origin, potentially carrying severe consequences.

A mitigation “strongly advised” by the spec for this is to require [elevated permissions](https://w3c.github.io/mediacapture-screen-share/#elevated-permissions) that “determine that the user exhibits an elevated level of trust in the application that is being granted access” to **browser** and **monitor** sources. At least [one browser attempts to implement](https://support.mozilla.org/en-US/kb/screenshare-safety) this mitigation.

### 2.9. Does this specification enable new script execution/loading mechanisms?

No.

### 2.10. Does this specification allow an origin to access other devices?

No direct access to other networked devices. All surfaces shared are local (even though this spec inherited the term “device” from the MediaCapture-main specification).

No attempt is made to mandate that e.g. a user’s VNC or remote desktop client window be excluded from capture. Users might perceive such mitigations as bugs.

### 2.11. Does this specification allow an origin some measure of control over a user agent’s native UI?

In combination with full screen mode, **monitor** surface capture increases a website’s ability to reconstruct a user’s native UI faithfully, in order to fool users or obscure security / privacy controls. However, since the nature of the threat remains unchanged, full screen mode’s existing mitigations should suffice.

### 2.12. What temporary identifiers might this specification create or expose to the web?

No temporary identifiers (e.g. deviceIds) are exposed.

### 2.13. How does this specification distinguish between behavior in first-party and third-party contexts?

It defines the feature policy “display-capture”. It is off by default in iframes.

### 2.14. How does this specification work in the context of a user agent’s Private Browsing or "incognito" mode?

Assuming a user agent allows the same sources in both modes, the same risks of correlation mentioned earlier across origins apply here. Whether the permission is blocked or not also carries some information across, depending on the user agent.

### 2.15. Does this specification have a "Security Considerations" and "Privacy Considerations" section?

Yes, see [§8 Security & Permissions](https://w3c.github.io/mediacapture-screen-share/#security-and-permissions) and [§7 Privacy Indicator Requirements](https://w3c.github.io/mediacapture-screen-share/#privacy-indicator-requirements). 

### 2.16. Does this specification allow downgrading default security characteristics?

Only permission delegation of this powerful feature to iframes through feature policy, to the extent a site is more secure without this feature.

Sharing this feature with an embedded iframe exposes the top-level site to the risks of the same-origin vulnerabilities discussed earlier.

### 2.17. What should this questionnaire have asked?

Seems thorough. It wasn’t always clear whether the word “device” referred to a user’s system, other networked systems, or peripherals like camera and microphone, or all of the above. This may stem from a terminology conflict with our WG. What we call “devices”, you seem to call “sensors”.
