# Robots\_2020

This dataset represents robot tasks. Each file consists of an example with an input state and an output state.
The world is an `n x n` grid, with a robot and a ball.
The first value in the problem name represents the value `n`.
The state consists of 6 values:

- `:robot_x`: `x`-coordinate of the robot
- `:robot_y`: `y`-coordinate of the robot
- `:ball_x`: `x`-coordinate of the ball
- `:ball_y`: `y`-coordinate of the ball
- `:holds_ball`: A boolean value that determines if the robot is holding the ball, can be either 0,1
- `:size`: The size of the grid, `n`

See
> Cropper, Andrew, and Sebastijan Dumančić. "Learning large logic programs by going beyond entailment." arXiv preprint arXiv:2004.09855 (2020).
