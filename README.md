# Animated Beam

The beams are animated with a gradient that moves along a curved path.

## Features

- Animated Beam Effect: Smoothly animated beams with gradient colors.
- Customizable: Adjust curvature, colors, duration, and more.
- Dynamic Positioning: Beams are drawn between dynamically positioned icons.

## Usage

### AnimatedBeam Widget

The `AnimatedBeam` widget is used to draw an animated beam between two points. It supports the following parameters:

| Parameter            | Description                                                    |
| -------------------- | -------------------------------------------------------------- |
| `fromOffset`         | The starting point of the beam (e.g., the user icon position). |
| `toOffset`           | The ending point of the beam (e.g., the target icon position). |
| `pathColor`          | The base color of the beam path.                               |
| `gradientStartColor` | The starting color of the gradient animation.                  |
| `gradientStopColor`  | The ending color of the gradient animation.                    |
| `curvature`          | The curvature of the beam path.                                |
| `duration`           | The duration of the animation.                                 |
| `reverse`            | Whether to reverse the direction of the gradient animation.    |
