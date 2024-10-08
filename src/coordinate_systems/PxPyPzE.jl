
"""

    PxPyPzE <: AbstractCoordinateSystem

Cartesian coordinate system for four-momenta. Using this requires the implementation of the following interface functions:

```julia
LorentzVectorBase.px(::CustomFourMomentum)
LorentzVectorBase.py(::CustomFourMomentum)
LorentzVectorBase.pz(::CustomFourMomentum)
LorentzVectorBase.E(::CustomFourMomentum)
```

"""
struct PxPyPzE <: AbstractCoordinateSystem end
coordinate_names(::PxPyPzE) = (:px, :py, :pz, :E)

x(::PxPyPzE, p) = px(p)
x(::XYZT, p) = x(p)
px(::PxPyPzE, p) = px(p)
px(::XYZT, p) = x(p)

y(::PxPyPzE, p) = py(p)
y(::XYZT, p) = y(p)
py(::PxPyPzE, p) = py(p)
py(::XYZT, p) = y(p)

z(::PxPyPzE, p) = pz(p)
z(::XYZT, p) = z(p)
pz(::PxPyPzE, p) = pz(p)
pz(::XYZT, p) = z(p)

t(::PxPyPzE, p) = E(p)
t(::XYZT, p) = t(p)
E(::PxPyPzE, p) = E(p)
E(::XYZT, p) = t(p)

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
  eval(
    quote
      ($func)(::PxPyPzE, mom) = ($func)(XYZT(), mom)
    end,
  )
end
