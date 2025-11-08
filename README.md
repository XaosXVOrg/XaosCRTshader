# Xaos CRT shader
\
This a GLSL shader to be applied to get simulated CRT TV effects on the Dolphin emulator. The shader applies as cheaply as possible a set of layered effects to the rendered image:
- Lens like distortion: to simulate curvature on CRT TVs
- Bloom: To simulate the color bleeding that CRT get specially on bright areas of the image
- Increased Saturation and Contrast: To try to emulate the perceptual color ranges in CRT TVs
- Vignette: Adds to the CRT effect
- Pixels and Scanlines: Main CRT features
\
\
\
**Example screenshot of the postprocess shader being applied in Dolphin 2509 in The Legend of Zelda Twilight Princess** <img width="1966" height="1439" alt="Screenshot 2025-11-08 204750" src="https://github.com/user-attachments/assets/a7837403-166e-42a3-9326-af12b9b67c98" />
\
\
**Example screenshot without any postprocess shader** <img width="1969" height="1439" alt="Screenshot 2025-11-08 204900" src="https://github.com/user-attachments/assets/59cf6a7e-7825-43d1-b3dd-5ccad16b4e62" />



## Disclaimer
I DO NOT condone, promote, or distribute pirated software, including unauthorized copies of games (ROMs or ISOs). Users of emulators are solely responsible for obtaining game files legally, which generally means creating backup copies from physical media that they legitimately own.
