
abstract type AbstractCoordinateSystem end

"""
    coordinate_names(::AbstractCoordinateSystem)::Tuple{Symbols}

"""
function coordinate_names end

"""

    coordinate_system(::MomType)::CS where {CS <: AbstractCoordinateSystem}

"""
function coordinate_system end

const FOURMOMENTUM_GETTER_FUNCTIONS = (
  :x,
  :y,
  :z,
  :t,
  :px,
  :py,
  :pz,
  :E,
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

for func in FOURMOMENTUM_GETTER_FUNCTIONS
  eval(quote
    ($func)(mom) = ($func)($coordinate_system(mom), mom)
  end)
end

const FOURMOMENTUM_GETTER_ALIASSES = Dict(
  :energy => :t,
  :invariant_mass => :mass,
  :invariant_mass2 => :mass2,
  :transverse_momentum => :pt,
  :transverse_momentum2 => :pt2,
  :perp => :pt,
  :perp2 => :pt2,
  :transverse_mass => :mt,
  :transverse_mass2 => :mt2,
  :azimuthal_angle => :phi,
  :pseudorapidity => :eta,
)

for (alias, func) in FOURMOMENTUM_GETTER_ALIASSES
  eval(quote
    ($alias)(mom) = ($func)(mom)
  end)
end
