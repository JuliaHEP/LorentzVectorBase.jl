# # Implementing a New Coordinate System in `LorentzVectorBase.jl`
#
# In `LorentzVectorBase.jl`, **coordinate systems** are independent of any
# concrete four-vector type.
#
# This tutorial shows how to implement a **light-cone coordinate system**
# for four-momentum, so that *any* Lorentz vector type can use it — provided
# that type implements the coordinate-specific getter functions.
#
# ## Light-cone coordinates
#
# We'll define:
#
# - `plus_component`  = (t + z) / √2
# - `minus_component` = (t - z) / √2
# - `x`
# - `y`
#
# The **coordinate-specific getters** will be:
#
# ```julia
# LorentzVectorBase.plus_component(v)
# LorentzVectorBase.minus_component(v)
# LorentzVectorBase.x(v)
# LorentzVectorBase.y(v)
# ```
#
# All other kinematic quantities (`mass`, `pt`, `eta`, `phi`, etc.)
# will be defined *once* in the coordinate system and will work
# for any vector type implementing the coordinate getters.

using LorentzVectorBase

# ## 1. Define the coordinate system type
#
# Coordinate systems are [singletons](https://docs.julialang.org/en/v1/manual/types/#man-singleton-types) and must be subtypes of
# `AbstractCoordinateSystem`.

struct LightConeCoordinates <: LorentzVectorBase.AbstractCoordinateSystem end

# ## 2. Define the coordinate names
#
# `coordinate_names` returns the tuple of **getter function names**
# that *must* be implemented for any vector type using this coordinate system.

function LorentzVectorBase.coordinate_names(::LightConeCoordinates)
  return (:plus_component, :minus_component, :x, :y)
end

# ## 3. Implement the derived kinematic functions
#
# The coordinate system must implement all relevant getter functions listed in
# `FOURMOMENTUM_GETTER_FUNCTIONS`, except those returned by `coordinate_names`.
#
# These implementations are *type-generic* — they take a coordinate system
# instance and a `mom` (momentum object), and call only the coordinate-specific
# getters (`plus_component`, `minus_component`, `x`, `y`).

const SQRT2 = sqrt(2.0)

# Cartesian component accessors
function LorentzVectorBase.t(::LightConeCoordinates, mom)
  return (LorentzVectorBase.plus_component(mom) + LorentzVectorBase.minus_component(mom)) /
         SQRT2
end
function LorentzVectorBase.z(::LightConeCoordinates, mom)
  return (LorentzVectorBase.plus_component(mom) - LorentzVectorBase.minus_component(mom)) /
         SQRT2
end

# Momentum magnitudes
LorentzVectorBase.px(::LightConeCoordinates, mom) = LorentzVectorBase.x(mom)
LorentzVectorBase.py(::LightConeCoordinates, mom) = LorentzVectorBase.y(mom)
LorentzVectorBase.pz(::LightConeCoordinates, mom) = LorentzVectorBase.z(mom)
LorentzVectorBase.E(::LightConeCoordinates, mom) = LorentzVectorBase.t(mom)

function LorentzVectorBase.pt2(::LightConeCoordinates, mom)
  return LorentzVectorBase.x(mom)^2 + LorentzVectorBase.y(mom)^2
end
LorentzVectorBase.pt(::LightConeCoordinates, mom) = sqrt(LorentzVectorBase.pt2(mom))

function LorentzVectorBase.spatial_magnitude2(::LightConeCoordinates, mom)
  return LorentzVectorBase.pt2(mom) + LorentzVectorBase.pz(mom)^2
end
function LorentzVectorBase.spatial_magnitude(::LightConeCoordinates, mom)
  return sqrt(LorentzVectorBase.spatial_magnitude2(mom))
end

# Mass and energy-related
function LorentzVectorBase.mass2(::LightConeCoordinates, mom)
  return LorentzVectorBase.E(mom)^2 - LorentzVectorBase.spatial_magnitude2(mom)
end
function LorentzVectorBase.mass(::LightConeCoordinates, mom)
  return sqrt(LorentzVectorBase.mass2(mom))
end

function LorentzVectorBase.boost_beta(::LightConeCoordinates, mom)
  return LorentzVectorBase.spatial_magnitude(mom) / LorentzVectorBase.E(mom)
end
function LorentzVectorBase.boost_gamma(::LightConeCoordinates, mom)
  return 1 / sqrt(1 - LorentzVectorBase.boost_beta(mom)^2)
end

function LorentzVectorBase.mt2(::LightConeCoordinates, mom)
  return LorentzVectorBase.E(mom)^2 - LorentzVectorBase.pz(mom)^2
end
LorentzVectorBase.mt(::LightConeCoordinates, mom) = sqrt(LorentzVectorBase.mt2(mom))

# Angular coordinates
function LorentzVectorBase.rapidity(::LightConeCoordinates, mom)
  return 0.5 * log(
    (LorentzVectorBase.E(mom) + LorentzVectorBase.pz(mom)) /
    (LorentzVectorBase.E(mom) - LorentzVectorBase.pz(mom)),
  )
end

function LorentzVectorBase.polar_angle(::LightConeCoordinates, mom)
  return atan(LorentzVectorBase.pt(mom), LorentzVectorBase.pz(mom))
end

function LorentzVectorBase.cos_theta(::LightConeCoordinates, mom)
  return LorentzVectorBase.pz(mom) / LorentzVectorBase.spatial_magnitude(mom)
end

function LorentzVectorBase.phi(::LightConeCoordinates, mom)
  return atan(LorentzVectorBase.py(mom), LorentzVectorBase.px(mom))
end
function LorentzVectorBase.cos_phi(::LightConeCoordinates, mom)
  return LorentzVectorBase.px(mom) / LorentzVectorBase.pt(mom)
end
function LorentzVectorBase.sin_phi(::LightConeCoordinates, mom)
  return LorentzVectorBase.py(mom) / LorentzVectorBase.pt(mom)
end

# ## 4. Using the coordinate system
#
# To use `LightConeCoordinates`, a Lorentz vector type needs to:
#
# 1. Implement `coordinate_system(::MyVectorType) = LightConeCoordinates()`
# 2. Implement the four getters listed in `coordinate_names`:
#    `plus_component`, `minus_component`, `x`, `y`
#
# Once that’s done, **all** the functions we defined here
# will work automatically.

# For example, here is a simple four-vector type using light-cone coordinates:
struct MyLightConeVector
  plus::Float64
  minus::Float64
  x::Float64
  y::Float64
end

LorentzVectorBase.coordinate_system(::MyLightConeVector) = LightConeCoordinates()

LorentzVectorBase.plus_component(v::MyLightConeVector) = v.plus
LorentzVectorBase.minus_component(v::MyLightConeVector) = v.minus
LorentzVectorBase.x(v::MyLightConeVector) = v.x
LorentzVectorBase.y(v::MyLightConeVector) = v.y

LorentzVectorBase.E(MyLightConeVector(3.0, 1.0, 1.0, 2.0))  # works!

using Test  #src

const ATOL = 1e-12  #src

@testset "LightConeCoordinates basic relations" begin #src
  plus = 3.0 #src
  minus = 1.0 #src
  xval = 1.0 #src
  yval = 2.0 #src
  v = MyLightConeVector(plus, minus, xval, yval) #src

  @test coordinate_names(LightConeCoordinates()) == #src
    (:plus_component, :minus_component, :x, :y) #src

  @test LorentzVectorBase.plus_component(v) == plus #src
  @test LorentzVectorBase.minus_component(v) == minus #src
  @test LorentzVectorBase.x(v) == xval #src
  @test LorentzVectorBase.y(v) == yval #src

  @test LorentzVectorBase.t(v) ≈ (plus + minus) / sqrt(2.0) atol = ATOL #src
  @test LorentzVectorBase.z(v) ≈ (plus - minus) / sqrt(2.0) atol = ATOL #src
  @test LorentzVectorBase.E(v) ≈ (plus + minus) / sqrt(2.0) atol = ATOL #src
  @test LorentzVectorBase.pz(v) ≈ (plus - minus) / sqrt(2.0) atol = ATOL #src

  @test LorentzVectorBase.pt2(v) ≈ (xval^2 + yval^2) atol = ATOL #src
  @test LorentzVectorBase.pt(v) ≈ sqrt(xval^2 + yval^2) atol = ATOL #src
  @test LorentzVectorBase.spatial_magnitude2(v) ≈ #src
    (xval^2 + yval^2 + ((plus - minus) / sqrt(2.0))^2) atol = ATOL #src
  @test LorentzVectorBase.spatial_magnitude(v) ≈ #src
    sqrt(xval^2 + yval^2 + ((plus - minus) / sqrt(2.0))^2) atol = ATOL #src

  @test LorentzVectorBase.mass2(v) ≈ (2 * plus * minus - xval^2 - yval^2) atol = ATOL #src
  @test LorentzVectorBase.mass(v) ≈ sqrt(2 * plus * minus - xval^2 - yval^2) atol = ATOL #src

  @test LorentzVectorBase.mt2(v) ≈ #src
    (((plus + minus) / sqrt(2.0))^2 - ((plus - minus) / sqrt(2.0))^2) atol = ATOL #src
  @test LorentzVectorBase.mt(v) ≈ #src
    sqrt(((plus + minus) / sqrt(2.0))^2 - ((plus - minus) / sqrt(2.0))^2) atol = ATOL #src

  beta = LorentzVectorBase.boost_beta(v) #src
  gamma = LorentzVectorBase.boost_gamma(v) #src
  @test beta ≈ #src
    sqrt(xval^2 + yval^2 + ((plus - minus) / sqrt(2.0))^2) / #src
        ((plus + minus) / sqrt(2.0)) atol = ATOL #src
  @test gamma ≈ 1 / sqrt(1 - beta^2) atol = ATOL #src

  @test LorentzVectorBase.rapidity(v) ≈ 0.5 * log(plus / minus) atol = ATOL #src
  @test LorentzVectorBase.polar_angle(v) ≈ #src
    atan(sqrt(xval^2 + yval^2), (plus - minus) / sqrt(2.0)) atol = ATOL #src
  @test LorentzVectorBase.cos_theta(v) ≈ #src
    ((plus - minus) / sqrt(2.0)) / #src
        sqrt(xval^2 + yval^2 + ((plus - minus) / sqrt(2.0))^2) atol = ATOL #src

  @test LorentzVectorBase.phi(v) ≈ atan(yval, xval) atol = ATOL #src
  @test LorentzVectorBase.cos_phi(v) ≈ xval / sqrt(xval^2 + yval^2) atol = ATOL #src
  @test LorentzVectorBase.sin_phi(v) ≈ yval / sqrt(xval^2 + yval^2) atol = ATOL  #src
end #src
