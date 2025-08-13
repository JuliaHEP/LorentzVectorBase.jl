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
# Coordinate systems are singletons and must be subtypes of
# `AbstractCoordinateSystem`.

struct LightConeCoordinates <: LorentzVectorBase.AbstractCoordinateSystem end

# ## 2. Define the coordinate names
#
# `coordinate_names` returns the tuple of **getter function names**
# that *must* be implemented for any vector type using this coordinate system.

function LorentzVectorBase.coordinate_names(::LightConeCoordinates)
  (:plus_component, :minus_component, :x, :y)
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
  (plus_component(mom) + minus_component(mom)) / SQRT2
end
function LorentzVectorBase.z(::LightConeCoordinates, mom)
  (plus_component(mom) - minus_component(mom)) / SQRT2
end
LorentzVectorBase.x(::LightConeCoordinates, mom) = p_x(mom)
LorentzVectorBase.y(::LightConeCoordinates, mom) = p_y(mom)

# Momentum magnitudes
LorentzVectorBase.px(::LightConeCoordinates, mom) = p_x(mom)
LorentzVectorBase.py(::LightConeCoordinates, mom) = p_y(mom)
function LorentzVectorBase.pz(::LightConeCoordinates, mom)
  (plus_component(mom) - minus_component(mom)) / SQRT2
end
function LorentzVectorBase.E(::LightConeCoordinates, mom)
  (plus_component(mom) + minus_component(mom)) / SQRT2
end

LorentzVectorBase.pt2(::LightConeCoordinates, mom) = p_x(mom)^2 + p_y(mom)^2
LorentzVectorBase.pt(cs::LightConeCoordinates, mom) = sqrt(LorentzVectorBase.pt2(cs, mom))

function LorentzVectorBase.spatial_magnitude2(cs::LightConeCoordinates, mom)
  LorentzVectorBase.pt2(cs, mom) + LorentzVectorBase.pz(cs, mom)^2
end
function LorentzVectorBase.spatial_magnitude(cs::LightConeCoordinates, mom)
  sqrt(LorentzVectorBase.spatial_magnitude2(cs, mom))
end

# Mass and energy-related
function LorentzVectorBase.mass2(cs::LightConeCoordinates, mom)
  LorentzVectorBase.E(cs, mom)^2 - LorentzVectorBase.spatial_magnitude2(cs, mom)
end
function LorentzVectorBase.mass(cs::LightConeCoordinates, mom)
  sqrt(LorentzVectorBase.mass2(cs, mom))
end

function LorentzVectorBase.boost_beta(cs::LightConeCoordinates, mom)
  LorentzVectorBase.spatial_magnitude(cs, mom) / LorentzVectorBase.E(cs, mom)
end
function LorentzVectorBase.boost_gamma(cs::LightConeCoordinates, mom)
  1 / sqrt(1 - LorentzVectorBase.boost_beta(cs, mom)^2)
end

function LorentzVectorBase.mt2(cs::LightConeCoordinates, mom)
  LorentzVectorBase.E(cs, mom)^2 - LorentzVectorBase.pz(cs, mom)^2
end
LorentzVectorBase.mt(cs::LightConeCoordinates, mom) = sqrt(LorentzVectorBase.mt2(cs, mom))

# Angular coordinates
function LorentzVectorBase.rapidity(cs::LightConeCoordinates, mom)
  0.5 * log(
    (LorentzVectorBase.E(cs, mom) + LorentzVectorBase.pz(cs, mom)) /
    (LorentzVectorBase.E(cs, mom) - LorentzVectorBase.pz(cs, mom)),
  )
end

function LorentzVectorBase.polar_angle(cs::LightConeCoordinates, mom)
  atan(LorentzVectorBase.pt(cs, mom), LorentzVectorBase.pz(cs, mom))
end

function LorentzVectorBase.cos_theta(cs::LightConeCoordinates, mom)
  LorentzVectorBase.pz(cs, mom) / LorentzVectorBase.spatial_magnitude(cs, mom)
end

function LorentzVectorBase.phi(cs::LightConeCoordinates, mom)
  atan(LorentzVectorBase.py(cs, mom), LorentzVectorBase.px(cs, mom))
end
function LorentzVectorBase.cos_phi(cs::LightConeCoordinates, mom)
  LorentzVectorBase.px(cs, mom) / LorentzVectorBase.pt(cs, mom)
end
function LorentzVectorBase.sin_phi(cs::LightConeCoordinates, mom)
  LorentzVectorBase.py(cs, mom) / LorentzVectorBase.pt(cs, mom)
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
