#
# Random Number Generation (RNG)
# StackedBoxes' GDScript Hodgepodge
#
# Copyright (c) 2019 Leandro Motta Barros
#

extends Node
class_name SbxsRNG

# The underlying random number generator. While technically part of the public
# interface, you better avoid accessing it directly. Instead, rely on the
# methods defined below.
#
# The reason this is public is to allow you to more easily create libraries in
# which you can use a SbxsRNG optionally, falling back to the standard Godot RNG
# classes and functions if you don't want the extra dependency.
var rng: RandomNumberGenerator

# The maximum value rng.randi() can possibly return.
const RAND_MAX := 4294967295 # 2^32 - 1


# Initializes the RNG. You can pass a seed to initialize it. Using the default
# seed value, -1, causes the RNG to be randomized (using the standard
# randomize() method, which uses the current time to seed the RNG).
func _init(theSeed: int = -1):
	rng = RandomNumberGenerator.new()
	if theSeed == -1:
		rng.randomize()
	else:
		rng.set_seed(theSeed)


# Returns a floating random number in the [a, b) interval, drawn from a uniform
# distribution. The default interval is [0, 1).
#
# Note that `a` cannot be equal to `b`, because [x, x) is an empty interval,
# from which no numbers can be drawn.
#
# Why a half empty interval? Most applications shouldn't really care if the
# right end is open or closed, but if you are working with a longer real
# interval partitioned into smaller segments, you'll want half-open intervals.
func uniform(a: float = 0.0, b: float = 1.0) -> float:
	assert(a < b)
	return (rng.randi() / float(RAND_MAX + 1)) * (b - a) + a


# Returns an integer value in the [a, b] interval, drawn from a uniform
# distribution.
#
# Note that, unlike its floating-point counterpart uniform(), here the interval
# is closed at both ends. Why the difference? Because calling uniformInt(1, 6)
# just feels like the right way to simulate a six-sided die. Also, for integers
# it is easy to adjust the parameters to any interval you need.
#
# This implementation the usual (and naïve) logic based on the modulus operator.
# Therefore, it only produces a reasonably uniform distribution if `abs(b - a)`
# is much smaller than the maximum number that the underlying random number
# generator can produce (4294967295). In other words, this is OK to simulate
# rolls of dice, but will generate skewed distributions if used to generate
# random numbers in a large interval like, perhaps, 0 to 1000000. If you need
# uniformly distributed random numbers taken form a large interval, implement
# something like described here: http://stackoverflow.com/a/6852396.
func uniformInt(a: int, b: int) -> int:
	assert(a <= b)
	var r := rng.randi() % (b - a + 1)
	return a + r


# Returns a Boolean random value, which has a probability 0.5 of being true,
# like the idealized act of tossing a fair coin (real coins actually tend to be
# slightly biased).
#
# Just a convenience function -- maybe a bit more so than everything else here.
func flipCoin() -> bool:
	return rng.randi() < RAND_MAX * 0.5


# Returns a Boolean random value, which has a probability p of being true (a
# Bernoulli distribution).
#
# For p <= 0, false is always returned. For p >= 1, true is always returned.
func bernoulli(p: float) -> bool:
	return rng.randi() < RAND_MAX * p


# Returns a random floating point number drawn from an exponential distribution
# with a given mean.
func exponential(mean: float) -> float:
	var r01 := float(rng.randi()) / RAND_MAX
	return -mean * log(r01)


# Returns a random floating point number drawn from a normal (Gaussian)
# distribution with a given mean and standard deviation.
#
# By default, the mean is 0.0 and the standard deviation is 1.0.
#
# This implements an algorithm by Peter John Acklam for computing an
# approximation of the inverse normal cumulative distribution function, which
# is pretty accurate. More details about this algorithm at
# https://stackedboxes.org/2017/05/01/acklams-normal-quantile-function/
#
# This specific implementation always draws one (and only one) number from the
# underlying random number generator (in exchange of a miserably tiny increment
# of the chance of generate exactly the mean value).
func normal(mean: float = 0.0, stdDev: float = 1.0) -> float:
	assert(stdDev >= 0)

	# Coefficients in rational approximations
	var a1 := -3.969683028665376e+01
	var a2 :=  2.209460984245205e+02
	var a3 := -2.759285104469687e+02
	var a4 :=  1.383577518672690e+02
	var a5 := -3.066479806614716e+01
	var a6 :=  2.506628277459239e+00

	var b1 := -5.447609879822406e+01
	var b2 :=  1.615858368580409e+02
	var b3 := -1.556989798598866e+02
	var b4 :=  6.680131188771972e+01
	var b5 := -1.328068155288572e+01

	var c1 := -7.784894002430293e-03
	var c2 := -3.223964580411365e-01
	var c3 := -2.400758277161838e+00
	var c4 := -2.549732539343734e+00
	var c5 :=  4.374664141464968e+00
	var c6 :=  2.938163982698783e+00

	var d1 :=  7.784695709041462e-03
	var d2 :=  3.224671290700398e-01
	var d3 :=  2.445134137142996e+00
	var d4 :=  3.754408661907416e+00

	# Break-points
	var pLow := 0.02425
	var pHigh := 1 - pLow

	# Input and output variables; here we skew the distribution a miserably tiny
	# bit in order to guarantee that we draw one single random number from the
	# underlying generator.
	var p := float(rng.randi()) / RAND_MAX
	if p <= 0.0 || p >= 1.0:
		return mean

	assert(p > 0.0 && p < 1.0)

	var x: float

	# Rational approximation for lower region
	if p < pLow:
		var q := sqrt(-2.0 * log(p))
		x = ( (((((c1 * q + c2) * q + c3) * q + c4) * q + c5) * q + c6) /
			((((d1 * q + d2) * q + d3) * q + d4) * q + 1) )

	# Rational approximation for central region
	elif p <= pHigh:
		var q := p - 0.5
		var r := q * q
		x = ( (((((a1 * r + a2) * r + a3) * r + a4) * r + a5) * r + a6) * q /
			(((((b1 * r + b2) * r + b3) * r + b4) * r + b5) * r + 1) )

	# Rational approximation for upper region
	else:
		assert(p > pHigh)
		var q := sqrt(-2.0 * log(1-p))
		x = ( -(((((c1 * q + c2) * q + c3) * q + c4) * q + c5) * q + c6) /
			((((d1 * q + d2) * q + d3) * q + d4) * q + 1) )

	# There we are
	return x * stdDev + mean
