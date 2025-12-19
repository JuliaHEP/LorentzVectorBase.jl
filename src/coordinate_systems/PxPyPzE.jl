
"""
    PxPyPzE <: AbstractCoordinateSystem

Represents the Cartesian coordinate system for four-momenta, where the components are labeled as (px, py, pz, E).
This system is commonly used in high-energy physics to describe the momentum and energy of particles.

To use this coordinate system with a custom four-momentum type, you must implement the following interface methods:

```julia
LorentzVectorBase.px(::CustomFourMomentum)  # Returns the x-component of momentum
LorentzVectorBase.py(::CustomFourMomentum)  # Returns the y-component of momentum
LorentzVectorBase.pz(::CustomFourMomentum)  # Returns the z-component of momentum
LorentzVectorBase.E(::CustomFourMomentum)   # Returns the energy component
```

### Example

The following example demonstrates how to define a custom four-momentum type and implement the required interface:

```jldoctest
julia> struct CustomFourMomentum
           px
           py
           pz
           E
       end

julia> LorentzVectorBase.coordinate_system(::CustomFourMomentum) = LorentzVectorBase.PxPyPzE()

julia> LorentzVectorBase.px(p::CustomFourMomentum) = p.px

julia> LorentzVectorBase.py(p::CustomFourMomentum) = p.py

julia> LorentzVectorBase.pz(p::CustomFourMomentum) = p.pz

julia> LorentzVectorBase.E(p::CustomFourMomentum) = p.E

julia> p = CustomFourMomentum(1.0, 2.0, 3.0, 4.0)
CustomFourMomentum(1.0, 2.0, 3.0, 4.0)

julia> isapprox(LorentzVectorBase.spatial_magnitude(p), sqrt(1.0^2 + 2.0^2 + 3.0^2))
true

```

By implementing these methods, the custom type `CustomFourMomentum` becomes compatible with `LorentzVectorBase` operations in the `PxPyPzE` coordinate system.
"""
struct PxPyPzE <: AbstractCoordinateSystem end
coordinate_names(::PxPyPzE) = (:px, :py, :pz, :E)

x(::PxPyPzE, p) = px(p)
y(::PxPyPzE, p) = py(p)
z(::PxPyPzE, p) = pz(p)
t(::PxPyPzE, p) = E(p)

const DELEGATED_GETTER_FUNCTIONS = (
  :pt,
  :pt2,
  :eta,
  :phi,
  :spatial_magnitude,
  :spatial_magnitude2,
  :mass,
  :mass2,
  :boost_beta,
  :boost_gamma,
  :mt2,
  :mt,
  :rapidity,
  :polar_angle,
  :cos_theta,
  :cos_phi,
  :sin_phi,
  :plus_component,
  :minus_component,
)

for func in DELEGATED_GETTER_FUNCTIONS
  eval(quote
    ($func)(::PxPyPzE, mom) = ($func)(XYZT(), mom)
  end)
end
