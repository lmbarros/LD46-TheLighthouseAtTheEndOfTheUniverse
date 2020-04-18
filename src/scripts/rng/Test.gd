#
# Random Number Generation (RNG)
# StackedBoxes' GDScript Hodgepodge
#
# Copyright (c) 2019 Leandro Motta Barros
#

extends SceneTree

var RNG
var Assert
var Stats

const N := 10000 # standard number of iterations in each test

func _init():
	RNG = preload("res://RNG.gd")
	Assert = preload("res://Assert.gd")
	Stats = preload("res://Stats.gd")

	TestSameSeed()
	TestDifferentSeed()

	TestUniformDefault()
	TestUniform(0.0, 1.0)
	TestUniform(-1.0, 1.0)
	TestUniform(-2.0, -1.0)
	TestUniform(-1.33, 0.0)
	TestUniform(-1.2, -1.0)
	TestUniform(0.0, 100.0)

	TestUniformInt(1, 6)
	TestUniformInt(0, 4)
	TestUniformInt(-10, -2)
	TestUniformInt(-2, 4)
	TestUniformInt(-4, 0)
	TestUniformInt(3, 3)
	TestUniformInt(-7, -7)

	TestFlipCoin()

	TestBernoulli(0.5, 0.5)
	TestBernoulli(0.0, 0.0)
	TestBernoulli(0.2, 0.2)
	TestBernoulli(0.7, 0.7)
	TestBernoulli(1.0, 1.0)
	TestBernoulli(-1.1, 0.0)
	TestBernoulli(-100.0, 0.0)
	TestBernoulli(1.1, 1.0)
	TestBernoulli(100.0, 1.0)

	TestExponential(1.0)
	TestExponential(2.0)
	TestExponential(33.3)
	TestExponential(-1.0)
	TestExponential(-0.1)
	TestExponential(0.0)

	TestNormal(0.1, 1.0)
	TestNormal(1.0, 0.1)
	TestNormal(10.0, 3.0)
	TestNormal(-5.0, 3.0)

	quit()


# Checks if two RNGs seeded with the same value generate the same sequence.
func TestSameSeed() -> void:
	var rng1 = RNG.new(1234)
	var rng2 = RNG.new(1234)

	for _i in range(N):
		Assert.isEqual(rng1.uniform(), rng2.uniform())


# Checks if two RNGs seeded with different values generate a different sequence.
func TestDifferentSeed() -> void:
	var rng1 = RNG.new(1234)
	var rng2 = RNG.new(4321)

	var allTheSame := true

	for _i in range(N):
		if rng1 != rng2:
			allTheSame = false
			break

	Assert.isFalse(allTheSame)


# Tests uniform() with the default parameters.
func TestUniformDefault() -> void:
	var rng = RNG.new()

	for _i in range(N):
		var u = rng.uniform()
		Assert.isGE(u, 0.0)
		Assert.isLT(u, 1.0)


# Tests uniform() with given parameters.
func TestUniform(a: float, b: float) -> void:
	var rng = RNG.new()

	for _i in range(N):
		var u = rng.uniform(a, b)
		Assert.isGE(u, a)
		Assert.isLT(u, b)


# Tests uniformInt() with given parameters. We just check if all numbers within
# the requested interval were generated at least once. No real check for
# uniformity, but better than nothing. (Will fail if (b - a) is not much smaller
# than N).
func TestUniformInt(a: int, b: int) -> void:
	var rng = RNG.new()

	var wasGenerated := { }

	for i in range(a, b+1):
		wasGenerated[i] = false

	for _i in range(N):
		var u = rng.uniformInt(a, b)
		Assert.isGE(u, a)
		Assert.isLE(u, b)
		wasGenerated[u] = true

	for i in range(a, b+1):
		Assert.isTrue(wasGenerated[i])


# Tests flipCoin().
func TestFlipCoin() -> void:
	var rng = RNG.new()

	var numTrues := 0

	for _i in range(N):
		if rng.flipCoin():
			numTrues += 1

	var actualP: float = float(numTrues) / N
	Assert.isSmall(abs(actualP - 0.5), 0.05)



# Tests bernoulli() with a given p. The other parameter, expectedP is the
# expected proportion of trues; it should normally be equal to p itself --
# except when p is not in [0.0, 1.0]
func TestBernoulli(p: float, expectedP: float) -> void:
	var rng = RNG.new()

	var numTrues := 0

	for _i in range(N):
		if rng.bernoulli(p):
			numTrues += 1

	var actualP: float = float(numTrues) / N
	Assert.isSmall(abs(actualP - expectedP), 0.05)


# Tests exponential() with a given mean -- er, kinda. I don't make any effort to
# ensure that the numbers are really drawn from an exponential distribution.
func TestExponential(mean: float) -> void:
	var rng = RNG.new()
	var vals = [ ]

	for _i in range(N):
		vals.append(rng.exponential(mean))

	var actualMean = Stats.mean(vals)

	var v : = abs(mean - actualMean)
	if mean > 0.0:
		v /= mean

	Assert.isSmall(v, 0.05)


# Tests normal() with given mean and standard deviation. Again, I don't make any
# effort to ensure that the numbers are really drawn from a normal distribution.
func TestNormal(mean: float, stdDev: float) -> void:
	var N := 250000 # override global N
	var rng = RNG.new()
	var vals = [ ]

	for _i in range(N):
		vals.append(rng.normal(mean, stdDev))

	var actualMean = Stats.mean(vals)
	Assert.isClose(mean, actualMean, 0.075)

	var actualStdDev = Stats.standardDeviation(vals, actualMean)
	Assert.isClose(stdDev, actualStdDev, 0.075)
