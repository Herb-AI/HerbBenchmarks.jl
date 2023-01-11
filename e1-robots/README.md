# Robots

This dataset represents robot tasks. Each file consists of an example with an input state and an output state.
The world is an `n x n` grid, with a robot and a ball.
The first value in the filename represents the value `n`.
The state consists of 6 values:

- `x`-coordinate of the robot
- `y`-coordinate of the robot
- `x`-coordinate of the ball
- `y`-coordinate of the ball
- A boolean value that determines if the robot is holding the ball
- The size of the grid, `n`

See
> Cropper, Andrew, and Sebastijan Dumančić. "Learning large logic programs by going beyond entailment." arXiv preprint arXiv:2004.09855 (2020).
