"""
    XYZT <: AbstractCoordinateSystem

Represents the Cartesian coordinate system for four-vectors, where the components are labeled as (x, y, z, t).

To use this coordinate system with a custom four-vector type, you must implement the following interface methods:

```julia
LorentzVectorBase.x(::CustomFourVector)  # Returns the x-component
LorentzVectorBase.y(::CustomFourVector)  # Returns the y-component
LorentzVectorBase.z(::CustomFourVector)  # Returns the z-component
LorentzVectorBase.t(::CustomFourVector)  # Returns the time component
```

### Example

The following example demonstrates how to define a custom four-vector type and implement the required interface:

```jldoctest
julia> struct CustomLVector
           x
           y
           z
           t
       end

julia> LorentzVectorBase.coordinate_system(::CustomLVector) = LorentzVectorBase.XYZT()

julia> LorentzVectorBase.x(lv::CustomLVector) = lv.x

julia> LorentzVectorBase.y(lv::CustomLVector) = lv.y

julia> LorentzVectorBase.z(lv::CustomLVector) = lv.z

julia> LorentzVectorBase.t(lv::CustomLVector) = lv.t

julia> c = CustomLVector(1, 2, 3, 4)
CustomLVector(1, 2, 3, 4)

julia> @assert isapprox(LorentzVectorBase.spatial_magnitude(c), sqrt(1^2 + 2^2 + 3^2))

```

By implementing these methods, the custom type `CustomLVector` becomes compatible with `LorentzVectorBase` operations in the `XYZT` coordinate system.
"""
struct XYZT <: AbstractCoordinateSystem end
coordinate_names(::XYZT) = (:x, :y, :z, :t)

####
# Interface functions
####

px(XYZT, p) = x(p)
py(XYZT, p) = y(p)
pz(XYZT, p) = z(p)
E(XYZT, p) = t(p)

####
# derived components
####

@inline function spatial_magnitude2(::XYZT, mom)
  return x(mom)^2 + y(mom)^2 + z(mom)^2
end

@inline function spatial_magnitude(cs::XYZT, mom)
  return sqrt(spatial_magnitude2(mom))
end

@inline function mass2(::XYZT, mom)
  return t(mom)^2 - x(mom)^2 - y(mom)^2 - z(mom)^2
end

@inline function mass(::XYZT, mom)
  m2 = mass2(mom)
  if m2 < zero(m2)
    # Think about including this warning, maybe optional with a global PRINT_WARNINGS switch.
    #@warn("The square of the invariant mass (m2=P*P) is negative. The value -sqrt(-m2) is returned.")
    return -sqrt(-m2)
  else
    return sqrt(m2)
  end
end

@inline function boost_beta(::XYZT, mom)
  en = t(mom)
  rho = spatial_magnitude(mom)
  if !iszero(en)
    return rho / en
  elseif iszero(rho)
    return zero(rho)
  else
    throw(
      ArgumentError(
        "there is no beta for a four-vector with vanishing time/energy component"
      ),
    )
  end
end

@inline function boost_gamma(::XYZT, mom)
  beta = boost_beta(mom)
  return inv(sqrt(one(beta) - beta^2))
end

########################
# transverse coordinates
########################
@inline function pt2(::XYZT, mom)
  return x(mom)^2 + y(mom)^2
end

@inline function pt(::XYZT, mom)
  return sqrt(pt2(mom))
end

@inline function mt2(::XYZT, mom)
  return t(mom)^2 - z(mom)^2
end

function mt(::XYZT, mom)
  mT2 = mt2(mom)
  if mT2 < zero(mT2)
    # add optional waring: negative transverse mass -> -sqrt(-mT2) is returned.
    -sqrt(-mT2)
  else
    sqrt(mT2)
  end
end

@inline function rapidity(::XYZT, mom)
  en = t(mom)
  zcomp = z(mom)
  return 0.5 * log((en + zcomp) / (en - zcomp))
end

function eta(::XYZT, mom)
  cth = cos_theta(mom)

  if cth^2 < one(cth)
    return -0.5 * log((1 - cth) / (1 + cth))
  end

  zcomp = z(mom)
  if iszero(zcomp)
    return zero(zcomp)
  end

  @warn "Pseudorapidity (η): transverse momentum is zero! return +/- 10e10"
  if zcomp > zero(zcomp)
    return 10e10
  end

  return -10e10
end

#######################
# spherical coordinates
#######################
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

@inline function cos_theta(::XYZT, mom)
  r = spatial_magnitude(mom)
  return iszero(r) ? one(x(mom)) : z(mom) / r
end

function phi(::XYZT, mom)
  xcomp = x(mom)
  ycomp = y(mom)
  return iszero(xcomp) && iszero(ycomp) ? zero(xcomp) : atan(ycomp, xcomp)
end

function cos_phi(::XYZT, mom)
  pT = transverse_momentum(mom)
  return iszero(pT) ? one(pT) : x(mom) / pT
end

function sin_phi(::XYZT, mom)
  pT = transverse_momentum(mom)
  return iszero(pT) ? zero(pT) : y(mom) / pT
end

########################
# light cone coordinates
########################
@inline function plus_component(::XYZT, mom)
  return 0.5 * (t(mom) + z(mom))
end

@inline function minus_component(::XYZT, mom)
  return 0.5 * (t(mom) - z(mom))
end
