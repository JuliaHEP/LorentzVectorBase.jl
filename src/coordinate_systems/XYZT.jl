"""

    XYZT <: AbstractCoordinateSystem

Cartesian coordinate system for four-momenta. Using this requires the implementation of the following interface functions:

```julia
LorentzVectorBase.x(::CustomFourMomentum)
LorentzVectorBase.y(::CustomFourMomentum)
LorentzVectorBase.z(::CustomFourMomentum)
LorentzVectorBase.t(::CustomFourMomentum)
```

"""
struct XYZT <: AbstractCoordinateSystem end
coordinate_names(::XYZT) = (:x, :y, :z, :t)

####
# Interface functions
####

"""
    t(mom)

TBW
"""
function t end

"""
    x(mom)

TBW
"""
function x end

"""
    y(mom)

TBW
"""
function y end

"""
    z(mom)

TBW
"""
function z end

####
# derived components
####

"""

    spatial_magnitude2(::XYZT, mom)

Return the square of the spatial_magnitude of a given four-momentum, i.e. the sum of the squared spatial components.

!!! example

    If `(x,y,z,T)` is a four-momentum, this is equivalent to `x^2+ y^2 + z^2`.


!!! warning

    This function differs from a similar function for the `TLorentzVector` used in the famous `ROOT` library.

"""
@inline function spatial_magnitude2(::XYZT, mom)
    return x(mom)^2 + y(mom)^2 + z(mom)^2
end

"""

    spatial_magnitude(::XYZT,mom)

Return the spatial_magnitude of a given four-momentum, i.e. the euklidian norm spatial components.

!!! example

    If `(x,y,z,T)` is a four-momentum, this is equivalent to `sqrt(x^2 + y^2 + z^2)`.


!!! warning

    This function differs from a similar function for the `TLorentzVector` used in the famous `ROOT` library.

"""
@inline function spatial_magnitude(cs::XYZT, mom)
    return sqrt(spatial_magnitude2(mom))
end

"""

    mass2(::XYZT,mom)

Return the squared invariant mass of a given four-momentum, i.e. the minkowski dot with itself.

!!! example

    If `(x,y,z,T)` is a four-momentum, this is equivalent to `T^2 - (x^2 + y^2 + z^2)`.


"""
@inline function mass2(::XYZT, mom)
    return t(mom)^2 - x(mom)^2 - y(mom)^2 - z(mom)^2
end

"""

    mass(::XYZT,mom)

Return the the invariant mass of a given four-momentum, i.e. the square root of the minkowski dot with itself.

!!! example

    If `(x,y,z,T)` is a four-momentum, this is equivalent to `sqrt(T^2 - (x^2 + y^2 + z^2))`.


!!! note

    If the squared invariant mass `m2` is negative, `-sqrt(-m2)` is returned.

"""
@inline function mass(::XYZT, mom)
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

    boost_beta(::XYZT, mom )

Return spatial_magnitude of the beta vector for a given four-momentum, i.e. the spatial_magnitude of the four-momentum divided by its 0-component.

!!! example

    If `(x,y,z,T)` is a four-momentum, this is equivalent to `sqrt(x^2 + y^2 + z^2)/t`.

"""
@inline function boost_beta(::XYZT, mom)
    en = t(mom)
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

    boost_gamma(::XYZT,mom)

Return the relativistic gamma factor for a given four-momentum, i.e. the inverse square root of one minus the beta vector squared.

!!! example

    If `(x,y,z,t)` is a four-momentum with beta vector `β`, this is equivalent to `1/sqrt(1- β^2)`.

"""
@inline function boost_gamma(::XYZT, mom)
    beta = boost_beta(mom)
    return inv(sqrt(one(beta)- beta^2))
end

########################
# transverse coordinates
########################
"""

    pt2(::XYZT,mom)

Return the squared transverse momentum for a given four-momentum, i.e. the sum of its squared 1- and 2-component.

!!! example

    If `(x,y,z,t)` is a four-momentum, this is equivalent to `x^2 + y^2`.

!!! note

    The transverse components are defined w.r.t. to the 3-axis.

"""
@inline function pt2(::XYZT, mom)
  return x(mom)^2 + y(mom)^2
end

"""

    pt(::XYZT, mom)

Return the transverse momentum for a given four-momentum, i.e. the spatial_magnitude of its transverse components.

!!! example

    If `(x,y,z,t)` is a four-momentum, this is equivalent to `sqrt(x^2 + y^2)`.


!!! note

    The transverse components are defined w.r.t. to the 3-axis.

"""
@inline function pt(::XYZT, mom)
  return sqrt(pt2(mom))
end

"""

    mt2(::XYZT, mom)

Return the squared transverse mass for a given four-momentum, i.e. the difference of its squared 0- and 3-component.

!!! example

    If `(x,y,z,t)` is a four-momentum, this is equivalent to `E^2 - pz^2`.


!!! note

    The transverse components are defined w.r.t. to the 3-axis.


"""
@inline function mt2(::XYZT, mom)
  return t(mom)^2 - z(mom)^2
end

"""

    mt(::XYZT,mom)

Return the transverse momentum for a given four-momentum, i.e. the square root of its squared transverse mass.

!!! example

    If `(x,y,z,t)` is a four-momentum, this is equivalent to `sqrt(t^2 - z^2)`.


!!! note

    The transverse components are defined w.r.t. to the 3-axis.

!!! note

    If the squared transverse mass `mt2` is negative, `-sqrt(-mt2)` is returned.

"""
function mt(::XYZT, mom)
    mT2 = mt2(mom)
    if mT2 < zero(mT2)
        # add optional waring: negative transverse mass -> -sqrt(-mT2) is returned.
        -sqrt(-mT2)
    else
        sqrt(mT2)
    end
end

"""

    rapidity(::XYZT, mom)

Return the [rapidity](https://en.wikipedia.org/wiki/Rapidity) for a given four-momentum.

!!! example

    If `(x,y,z,t)` is a four-momentum, this is equivalent to `0.5*log((t+z)/(t-z))`.


!!! note

    The transverse components are defined w.r.t. to the 3-axis.

"""
@inline function rapidity(::XYZT, mom)
    en = t(mom)
    zcomp = z(mom)
    return 0.5 * log((en + zcomp) / (en - zcomp))
end

"""
    eta(::XYZT, mom)

TBW
"""
function eta(::XYZT, mom)
    cth = cos_theta(mom)

  if cth^2 < one(cth)
    return -0.5 * log((1 - cth) / (1 + cth))
  end

    z = z(mom)
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

    polar_angle(::XYZT,mom)

Return the theta angle for a given four-momentum, i.e. the polar angle of its spatial components in [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system).

!!! example

    If `(x,y,z,t)` is a four-momentum with spatial_magnitude `rho`, this is equivalent to `arccos(z/rho)`, which is also equivalent to `arctan(sqrt(x^2+y^2)/z)`.

!!! note

    The [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system) are defined w.r.t. to the 3-axis.

"""
@inline function polar_angle(::XYZT, mom)
    xcomp = x(mom)
    ycomp = y(mom)
    zcomp = z(mom)

  return if iszero(xcomp) && iszero(ycomp) && iszero(zcomp)
    zero(xcomp)
  else
    atan(transverse_momentum(mom), zcomp)
  end
end

"""

    cos_theta(::XYZT, mom)

Return the cosine of the theta angle for a given four-momentum.

!!! note

    This is an equivalent but faster version of `cos(polar_angle(::XYZT, mom))`; see [`polar_angle`](@ref).

"""
@inline function cos_theta(::XYZT, mom)
    r = spatial_magnitude(mom)
    return iszero(r) ? one(x(mom)) : z(mom) / r
end

"""

    phi(::XYZT, mom)

Return the phi angle for a given four-momentum, i.e. the azimuthal angle of its spatial components in [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system).

!!! example

    If `(x,y,z,t)` is a four-momentum, this is equivalent to `atan(y,x)`.

!!! note

    The [spherical coordinates](https://en.wikipedia.org/wiki/Spherical_coordinate_system) are defined w.r.t. to the 3-axis.

"""
function phi(::XYZT, mom)
    xcomp = x(mom)
    ycomp = y(mom)
    return iszero(xcomp) && iszero(ycomp) ? zero(xcomp) : atan(ycomp, xcomp)
end

"""

    cos_phi(::XYZT, mom)

Return the cosine of the azimuthal angle for a given four-momentum.

!!! note

    This is an equivalent but faster version of `cos(azimuthal_angle(mom))`; see [`phi`](@ref).

"""
function cos_phi(::XYZT, mom)
    pT = transverse_momentum(mom)
    return iszero(pT) ? one(pT) : x(mom) / pT
end

"""

    sin_phi(::XYZT,mom)

Return the sine of the azimuthal angle for a given four-momentum.

!!! note

    This is an equivalent but faster version of `sin(azimuthal_angle(mom))`; see [`phi`](@ref).

"""
function sin_phi(::XYZT, mom)
    pT = transverse_momentum(mom)
    return iszero(pT) ? zero(pT) : y(mom) / pT
end

########################
# light cone coordinates
########################
"""

    plus_component(::XYZT, mom)

Return the plus component for a given four-momentum in [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates).

!!! example

    If `(x,y,z,t)` is a four-momentum, this is equivalent to `(t+z)/2`.

!!! note

    The [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates) are defined w.r.t. to the 3-axis.

!!! warning

    The definition ``p^+ := (t + z)/2` differs from the usual definition of [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates) in general relativity.

"""
@inline function plus_component(::XYZT, mom)
    return 0.5 * (t(mom) + z(mom))
end

"""

    minus_component(::XYZT, mom)

Return the minus component for a given four-momentum in [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates).

!!! example

    If `(x,y,z,t)` is a four-momentum, this is equivalent to `(t-z)/2`.

!!! note

    The [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates) are defined w.r.t. to the 3-axis.

!!! warning

    The definition ``p^- := (t - z)/2` differs from the usual definition of [light-cone coordinates](https://en.wikipedia.org/wiki/Light-cone_coordinates) in general relativity.

"""
@inline function minus_component(::XYZT, mom)
    return 0.5 * (t(mom) - z(mom))
end
