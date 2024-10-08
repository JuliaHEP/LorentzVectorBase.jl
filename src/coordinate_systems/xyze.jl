"""

    XYZE <: AbstractCoordinateSystem

Cartesian coordinate system for four-momenta. Using this requires the implementation of the following interface functions:

```julia
px(::CustomFourMomentum)
py(::CustomFourMomentum)
pz(::CustomFourMomentum)
energy(::CustomFourMomentum)
```

"""
struct XYZE <: AbstractCoordinateSystem end
coordinate_names(::XYZE) = (:px, :py, :pz, :energy)

####
# Interface functions
####

"""
    energy(mom)

TBW
"""
function energy end

"""
    px(mom)

TBW
"""
function px end

"""
    py(mom)

TBW
"""
function py end

"""
    pz(mom)

TBW
"""
function pz end

####
# derived components
####

"""

    spatial_magnitude2(::XYZE, mom)

Return the square of the spatial_magnitude of a given four-momentum, i.e. the sum of the squared spatial components.

!!! example

    If `(px,py,pz,E)` is a four-momentum, this is equivalent to `px^2+ py^2 + pz^2`.


!!! warning

    This function differs from a similar function for the `TLorentzVector` used in the famous `ROOT` library.

"""
@inline function spatial_magnitude2(::XYZE, mom)
  return px(mom)^2 + py(mom)^2 + pz(mom)^2
end

"""

    spatial_magnitude(::XYZE,mom)

Return the spatial_magnitude of a given four-momentum, i.e. the euklidian norm spatial components.

!!! example

    If `(px,py,pz,E)` is a four-momentum, this is equivalent to `sqrt(px^2 + py^2 + pz^2)`.


!!! warning

    This function differs from a similar function for the `TLorentzVector` used in the famous `ROOT` library.

"""
@inline function spatial_magnitude(cs::XYZE, mom)
  return sqrt(spatial_magnitude2(mom))
end

"""

    mass2(::XYZE,mom)

Return the squared invariant mass of a given four-momentum, i.e. the minkowski dot with itself.

!!! example

    If `(px,py,pz,E)` is a four-momentum, this is equivalent to `E^2 - (px^2 + py^2 + pz^2)`.


"""
@inline function mass2(::XYZE, mom)
  return energy(mom)^2 - px(mom)^2 - py(mom)^2 - pz(mom)^2
end

"""

    mass(::XYZE,mom)

Return the the invariant mass of a given four-momentum, i.e. the square root of the minkowski dot with itself.

!!! example

    If `(px,py,pz,E)` is a four-momentum, this is equivalent to `sqrt(E^2 - (px^2 + py^2 + pz^2))`.


!!! note

    If the squared invariant mass `m2` is negative, `-sqrt(-m2)` is returned.

"""
@inline function mass(::XYZE, mom)
  m2 = mass2(mom)
  if m2 < zero(m2)
    # Think about including this waring, maybe optional with a global PRINT_WARINGS switch.
    #@warn("The square of the invariant mass (m2=P*P) is negative. The value -sqrt(-m2) is returned.")
    return -sqrt(-m2)
  else
    return sqrt(m2)
  end
end

"""

    boost_beta(::XYZE, mom )

Return spatial_magnitude of the beta vector for a given four-momentum, i.e. the spatial_magnitude of the four-momentum divided by its 0-component.

!!! example

    If `(px,py,pz,E)` is a four-momentum, this is equivalent to `sqrt(px^2 + py^2 + pz^2)/E`.

"""
@inline function boost_beta(::XYZE, mom)
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

"""

    boost_gamma(::XYZE,mom)

Return the relativistic gamma factor for a given four-momentum, i.e. the inverse square root of one minus the beta vector squared.

!!! example

    If `(px,py,pz,E)` is a four-momentum with beta vector `β`, this is equivalent to `1/sqrt(1- β^2)`.

"""
@inline function boost_gamma(::XYZE, mom)
  return inv(sqrt(one(energy(mom)) - boost_beta(mom)^2))
end

########################
# transverse coordinates
########################
"""

    pt2(::XYZE,mom)

Return the squared transverse momentum for a given four-momentum, i.e. the sum of its squared 1- and 2-component.

!!! example

    If `(px,py,pz,E)` is a four-momentum, this is equivalent to `px^2 + py^2`.

!!! note

    The transverse components are defined w.r.t. to the 3-axis.

"""
@inline function pt2(::XYZE, mom)
  return px(mom)^2 + py(mom)^2
end

"""

    pt(::XYZE, mom)

Return the transverse momentum for a given four-momentum, i.e. the spatial_magnitude of its transverse components.

!!! example

    If `(px,py,pz,E)` is a four-momentum, this is equivalent to `sqrt(px^2 + py^2)`.


!!! note

    The transverse components are defined w.r.t. to the 3-axis.

"""
@inline function pt(::XYZE, mom)
  return sqrt(pt2(mom))
end

"""

    mt2(::XYZE, mom)

Return the squared transverse mass for a given four-momentum, i.e. the difference of its squared 0- and 3-component.

!!! example

    If `(px,py,pz,E)` is a four-momentum, this is equivalent to `E^2 - pz^2`.


!!! note

    The transverse components are defined w.r.t. to the 3-axis.


"""
@inline function mt2(::XYZE, mom)
  return energy(mom)^2 - pz(mom)^2
end

"""

    mt(::XYZE,mom)

Return the transverse momentum for a given four-momentum, i.e. the square root of its squared transverse mass.

!!! example

    If `(px,py,pz,E)` is a four-momentum, this is equivalent to `sqrt(E^2 - pz^2)`.


!!! note

    The transverse components are defined w.r.t. to the 3-axis.

!!! note

    If the squared transverse mass `mt2` is negative, `-sqrt(-mt2)` is returned.

"""
function mt(::XYZE, mom)
  mT2 = mt2(mom)
  if mT2 < zero(mT2)
    # add optional waring: negative transverse mass -> -sqrt(-mT2) is returned.
    -sqrt(-mT2)
  else
    sqrt(mT2)
  end
end

"""

    rapidity(::XYZE, mom)

Return the [rapidity](https://en.wikipedia.org/wiki/Rapidity) for a given four-momentum.

!!! example

    If `(px,py,pz,E)` is a four-momentum, this is equivalent to `0.5*log((E+pz)/(E-pz))`.


!!! note

    The transverse components are defined w.r.t. to the 3-axis.

"""
@inline function rapidity(::XYZE, mom)
  en = energy(mom)
  zcomp = pz(mom)
  return 0.5 * log((en + zcomp) / (en - zcomp))
end

"""
    eta(::XYZE, mom)

TBW
"""
function eta(::XYZE, mom)
  cth = cos_theta(mom)

  if cth^2 < one(cth)
    return -0.5 * log((1 - cth) / (1 + cth))
  end

  z = pz(mom)
  if iszero(z)
    return zero(z)
  end

  @warn "Pseudorapidity (η): transverse momentum is zero! return +/- 10e10"
  if z > zero(z)
    return 10e10
  end

  return 10e-10
end

#######################
# spherical coordinates
#######################
"""

    polar_angle(::XYZE,mom)

Return the theta angle for a given four-momentum, i.e. the polar angle of its spatial components in [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system).
The angle is defined in the range `[0,π]`.

!!! example

    If `(px,py,pz,E)` is a four-momentum with spatial_magnitude `rho`, the function returns `arccos(pz/rho)`; see [`cos_theta`](@ref).

!!! note

    The [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system) are defined w.r.t. to the 3-axis.

"""
@inline polar_angle(c::XYZE, mom) = acos(cos_theta(mom))

"""

    cos_theta(::XYZE, mom)

Return the cosine of the theta angle for a given four-momentum.

!!! note

    This is an equivalent but faster version of `cos(polar_angle(::XYZE, mom))`; see [`polar_angle`](@ref).

"""
@inline function cos_theta(::XYZE, mom)
  r = spatial_magnitude(mom)
  return iszero(r) ? one(px(mom)) : pz(mom) / r
end

"""

    phi(::XYZE, mom)

Return the phi angle for a given four-momentum, i.e. the azimuthal angle of its spatial components in [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system).

!!! example

    If `(px,py,pz,E)` is a four-momentum, this is equivalent to `atan(py,px)`.

!!! note

    The [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system) are defined w.r.t. to the 3-axis.

"""
function phi(::XYZE, mom)
  xcomp = px(mom)
  ycomp = py(mom)
  return iszero(xcomp) && iszero(ycomp) ? zero(xcomp) : atan(ycomp, xcomp)
end

"""

    cos_phi(::XYZE, mom)

Return the cosine of the azimuthal angle for a given four-momentum.

!!! note

    This is an equivalent but faster version of `cos(azimuthal_angle(mom))`; see [`phi`](@ref).

"""
function cos_phi(::XYZE, mom)
  pT = transverse_momentum(mom)
  return iszero(pT) ? one(pT) : px(mom) / pT
end

"""

    sin_phi(::XYZE,mom)

Return the sine of the azimuthal angle for a given four-momentum.

!!! note

    This is an equivalent but faster version of `sin(azimuthal_angle(mom))`; see [`phi`](@ref).

"""
function sin_phi(::XYZE, mom)
  pT = transverse_momentum(mom)
  return iszero(pT) ? zero(pT) : py(mom) / pT
end

########################
# light cone coordinates
########################
"""

    plus_component(::XYZE, mom)

Return the plus component for a given four-momentum in [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates).

!!! example

    If `(px,py,pz,E)` is a four-momentum, this is equivalent to `(E+pz)/2`.

!!! note

    The [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates) are defined w.r.t. to the 3-axis.

!!! warning

    The definition ``p^+ := (E + p_z)/2` differs from the usual definition of [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates) in general relativity.

"""
@inline function plus_component(::XYZE, mom)
  return 0.5 * (energy(mom) + pz(mom))
end

"""

    minus_component(::XYZE, mom)

Return the minus component for a given four-momentum in [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates).

!!! example

    If `(px,py,pz,E)` is a four-momentum, this is equivalent to `(E-pz)/2`.

!!! note

    The [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates) are defined w.r.t. to the 3-axis.

!!! warning

    The definition ``p^- := (E - p_z)/2` differs from the usual definition of [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates) in general relativity.

"""
@inline function minus_component(::XYZE, mom)
  return 0.5 * (energy(mom) - pz(mom))
end
