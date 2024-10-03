"""

    PtEtaPhiM <: AbstractCoordinateSystem

Cylindrical coordinate system for four-momenta. Using this requires the implementation of the following interface functions:

```julia
pt(::CustomFourMomentum)
eta(::CustomFourMomentum)
phi(::CustomFourMomentum)
mass(::CustomFourMomentum)
```

"""
struct PtEtaPhiM <: AbstractCoordinateSystem end
coordinate_names(::PtEtaPhiM) = (:pt, :eta, :phi, :mass)

####
# derived components
####

px(::PtEtaPhiM, v) = pt(v) * cos(phi(v))
py(::PtEtaPhiM, v) = pt(v) * sin(phi(v))
pz(::PtEtaPhiM, v) = pt(v) * sinh(eta(v))

function energy(::PtEtaPhiM, mom)
  return sqrt(px(mom)^2 + py(mom)^2 + pz(mom)^2 + invariant_mass2(mom))
end

@inline function spatial_magnitude2(::PtEtaPhiM, mom)
  return pt(mom)^2 * (1 + sinh(eta(mom))^2)
end

@inline function spatial_magnitude(::PtEtaPhiM, mom)
  return sqrt(spatial_magnitude2(mom))
end

@inline function mass2(::PtEtaPhiM, mom)
  return mass(mom)^2
end

@inline function boost_beta(::PtEtaPhiM, mom)
  en = energy(mom)
  rho = spatial_magnitude(mom)
  if !iszero(en)
    rho / en
  elseif iszero(rho)
    return zero(rho)
  else
    throw(
      ArgumentError(
        "There is no beta for a four-momentum with vanishing time/energy component"
      ),
    )
  end
end

@inline function boost_gamma(::PtEtaPhiM, mom)
  return inv(sqrt(one(energy(mom)) - boost_beta(mom)^2))
end

########################
# transverse coordinates
########################

@inline function pt2(::PtEtaPhiM, mom)
  return pt(mom)^2
end

@inline function mt2(::PtEtaPhiM, mom)
  return energy(mom)^2 - pz(mom)^2
end

function mt(::PtEtaPhiM, mom)
  mT2 = mt2(mom)
  if mT2 < zero(mT2)
    # add optional waring: negative transverse mass -> -sqrt(-mT2) is returned.
    -sqrt(-mT2)
  else
    sqrt(mT2)
  end
end

@inline function rapidity(::PtEtaPhiM, mom)
  E = energy(mom)
  pz1 = pz(mom)
  return 0.5 * log((E + pz1) / (E - pz1))
end

#######################
# spherical coordinates
#######################

@inline function polar_angle(::PtEtaPhiM, mom)
    η = eta(mom)
    r = spatial_magnitude(mom)
    return iszero(r) && iszero(pz(mom)) ? zero(pz(mom)) : 2* atan(exp(-η))
end

@inline function cos_theta(::PtEtaPhiM, mom)
  r = spatial_magnitude(mom)
  return iszero(r) ? one(px(mom)) : pz(mom) / r
end

function cos_phi(::PtEtaPhiM, mom)
  pT = pt(mom)
  return iszero(pT) ? one(pT) : px(mom) / pT
end

function sin_phi(::PtEtaPhiM, mom)
  pT = pt(mom)
  return iszero(pT) ? zero(pT) : py(mom) / pT
end

########################
# light cone coordinates
########################
@inline function plus_component(::PtEtaPhiM, mom)
  return 0.5 * (energy(mom) + pz(mom))
end

@inline function minus_component(::PtEtaPhiM, mom)
  return 0.5 * (energy(mom) - pz(mom))
end
