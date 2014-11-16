## Data
x = [1, 2, 3, 3.1, 5.1, 6, 7, 8]
y = [1.8, 1.9, 1.7, 1.1, 1.1, 1.7, 1.4, 1.9]
## Results
s =  diff(y) ./ diff(x)
lsc = calibrate(x, y, LinearSpline())
true_coefficients = hcat(y[1:(end-1)], s)
## Test calibration
@test lsc.x == lsc.x
@test lsc.y == lsc.y
@test_approx_eq lsc.coefficients true_coefficients
## Test interpolation
## At a node
@test_approx_eq interpolate(2, lsc) 1.9
## At first / last node
@test_approx_eq interpolate(1, lsc) 1.8
@test_approx_eq interpolate(8, lsc) 1.9
## Before first / after last node
y_0 = lsc.coefficients[1, 1] + lsc.coefficients[1, 2] * (0 - 1)
y_N1 = lsc.coefficients[end, 1] + lsc.coefficients[end, 2] * (9 - 7)
@test_approx_eq interpolate(0, lsc) y_0
@test_approx_eq interpolate(9, lsc) y_N1
## Between nodes
y_12 = lsc.coefficients[1, 1] + lsc.coefficients[1, 2] * (1.2 - 1)
@test_approx_eq interpolate(1.2, lsc) y_12
## Test method without calibration
@test_approx_eq interpolate(1.2, x, y, LinearSpline()) y_12