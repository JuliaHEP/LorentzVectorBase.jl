
### Cartesian coordinates

"""
    t(lv)

Return the time (energy) component of the Lorentz-vector-like `lv`.
"""
t

"""
    x(lv)

Return the x-component (first spatial component) of the Lorentz-vector-like `lv`.
"""
x

"""
    y(lv)

Return the y-component (second spatial component) of the Lorentz-vector-like `lv`.
"""
y

"""
    z(lv)

Return the z-component (third spatial component) of the Lorentz-vector-like `lv`.
"""
z

"""
    E(lv)

Return the energy component (`E`) of a given Lorentz-vector-like `lv`.

# Example

For a four-momentum `(px, py, pz, E)`, this function returns the `E` component.

# See Also
- [`LorentzVectorBase.t`](@ref): The time component of a Lorentz-vector-like, which is equivalent to `E`.

"""
E

"""
    px(lv)

Return the x-component of a given Lorentz-vector-like `lv`.

# Example
    For a four-momentum `(px, py, pz, E)`, this function returns the `px` component.

# See Also
- [`LorentzVectorBase.x`](@ref): The x-component of a Lorentz-vector-like, which is equivalent to `px`.

"""
px

"""
    py(lv)

Return the y-component of a given Lorentz-vector-like `lv`.

# Example
For a four-momentum `(px, py, pz, E)`, this function returns the `py` component.

# See Also
- [`LorentzVectorBase.y`](@ref): The y-component of a Lorentz-vector-like, which is equivalent to `py`.

"""
py

"""
    pz(lv)

Return the z-component of a given Lorentz-vector-like `lv`.

# Example

For a four-momentum `(px, py, pz, E)`, this function returns the `pz` component.

# See Also
- [`LorentzVectorBase.z`](@ref): The z-component of a Lorentz-vector-like, which is equivalent to `pz`.

"""
pz

### Spherical Coordinates

"""
    spatial_magnitude2(lv)

Return the square of the spatial magnitude of the Lorentz-vector-like `lv`, i.e., the sum of the squares of its spatial components.

# Example
If the Lorentz-vector-like is four-vector `(x, y, z, t)`, this function returns `x^2 + y^2 + z^2`.

!!! warning

    This function differs from the `TLorentzVector::P2()` function in the `ROOT` library.
"""
spatial_magnitude2

"""
    spatial_magnitude(lv)

Return the spatial magnitude of the Lorentz-vector-like `lv`, i.e., the magnitude of its spatial components.


# Example

If the Lorentz-vector-like is a four-vector `(x, y, z, t)`, this function returns `\\sqrt(x^2 + y^2 + z^2)`.

!!! warning

    This function differs from the `TLorentzVector::P()` function in the `ROOT` library.
"""
spatial_magnitude

"""
    polar_angle(lv)

Return the polar angle (``\\theta``) of the Lorentz-vector-like `lv`.

# Example

If the Lorentz-vector-like is a four-vector ``(x, y, z, t)``, this is equivalent to ``\\arccos(z / \\sqrt{x^2 + y^2 + z^2})``.

!!! note

    If the Lorentz-vector-like is zero, the function returns zero for the angle.

# See Also
- [`LorentzVectorBase.cos_theta`](@ref): for a faster version of the cosine of the polar angle.
"""
polar_angle

"""
    cos_theta(lv)

Return the cosine of the polar angle (``\\theta``) of the Lorentz-vector-like `lv`.

Depending on the coordinate system, this might be an equivalent but faster version of `cos(polar_angle(lv))`.

# Example

If ``(x, y, z, t)`` is a four-vector, this is equivalent to ``z / \\sqrt{x^2 + y^2 + z^2}``.

# See Also
- [`LorentzVectorBase.polar_angle`](@ref): for the polar angle itself.
"""
cos_theta

"""
    phi(lv)

Return the azimuthal angle (``\\phi``) of the Lorentz-vector-like `lv`.

The azimuthal angle is the angle between the x-axis and the projection of the Lorentz-vector-like on the x-y plane.

# Example
    If ``(x, y, z, t)`` is a four-vector, this is equivalent to ``atan(y / x)``.

!!! note

    The azimuthal angle is defined with respect to the z-axis.

# See Also
- [`LorentzVectorBase.sin_phi`](@ref): for a faster version of the sine of the azimuthal angle.
- [`LorentzVectorBase.cos_phi`](@ref): for a faster version of the cosine of the azimuthal angle.
"""
phi

"""
    cos_phi(lv)

Return the cosine of the azimuthal angle (``\\phi``) of the Lorentz-vector-like `lv`.

Depending on the coordinate system, this might be an equivalent but faster version of `cos(phi(lv))`.

# Example
If ``(x, y, z, t)`` is a four-momentum, this is equivalent to ``x / \\sqrt{x^2 + y^2}``.

# See Also
- [`LorentzVectorBase.phi`](@ref): for the azimuthal angle itself.
- [`LorentzVectorBase.sin_phi`](@ref): for a faster version of the sine of the azimuthal angle.
"""
cos_phi

"""
    sin_phi(lv)

Return the sine of the azimuthal angle (``\\phi``) of the Lorentz-vector-like `lv`.

Depending on the coordinate system, this might be an equivalent but faster version of `sin(phi(lv))`.

# Example
If ``(x, y, z, t)`` is a four-momentum, this is equivalent to ``y / \\sqrt{x^2 + y^2}``.

# See Also
- [`LorentzVectorBase.phi`](@ref): for the azimuthal angle itself.
- [`LorentzVectorBase.cos_phi`](@ref): for a faster version of the cosine of the azimuthal angle.
"""
sin_phi

### Masses
"""
    mass2(lv)

Return the squared invariant mass of the Lorentz-vector-like `lv`, computed as the Minkowski inner product of the four-vector components with itself.


# Example
For a four-momentum `(px, py, pz, E)`, this function returns `E^2 - (px^2 + py^2 + pz^2)`.

# See Also
- [`mass`](@ref): For the invariant mass, i.e., the square root of this value.

"""
mass2

"""
    mass(lv)

Return the invariant mass  of the Lorentz-vector-like `lv`, computed as the square root of the Minkowski inner product of the four-vector components with itself.


# Example
For a four-momentum `(px, py, pz, E)`, this function returns `\\sqrt(E^2 - (px^2 + py^2 + pz^2))`.

# Notes
- If the squared invariant mass `m^2` is negative, this function returns `-\\sqrt(-m^2)` to ensure a real result. This can happen in certain unphysical cases where the energy component is smaller than the spatial momentum magnitude.

# See Also
- [`mass2`](@ref): For the squared invariant mass calculation.

"""
mass

### Boost Parameter
"""
    boost_beta(lv)

Return the magnitude of the velocity (``\\beta``) of a particle as a fraction of the speed of light of the Lorentz-vector-like `lv`.


# Example
For a four-momentum `(px, py, pz, E)`, this function returns `\\sqrt(px^2 + py^2 + pz^2) / E`.

# Throws
- `ArgumentError` if the time (energy) component is zero while the spatial components are non-zero, as this results in an undefined velocity.

# Notes
- If both the time (energy) and spatial components are zero, the function returns zero (``\\beta = 0``), as this represents a stationary object with no motion.

# See Also
- [`boost_gamma`](@ref): For the relativistic gamma factor, which depends on ``\\beta``.
"""
boost_beta

"""
    boost_gamma(lv)

Return the relativistic gamma factor (``\\gamma``) for the Lorentz-vector-like `lv`.


# Example
For a four-momentum `(px, py, pz, E)` with velocity ``\\beta``, this function returns ``1 / \\sqrt(1 - \\beta^2)``.

# See Also
- [`boost_beta`](@ref): For the velocity ``\\beta``, which is used to compute ``\\gamma``.
"""
boost_gamma

### Transverse Coordinates

"""
    pt2(lv)

Return the squared transverse momentum (``p_T^2``) of a given Lorentz-vector-like `lv`. The transverse momentum is defined with respect to the z-axis (3-axis) and is the sum of the squares of the x- and y-components.

# Example
For a four-momentum `(px, py, pz, E)`, this function returns `px^2 + py^2`.

# Notes
- The transverse components are the momentum projections in the x-y plane, perpendicular to the z-axis.

# See Also
- [`pt`](@ref): For the transverse momentum.
"""
pt2

"""
    pt(lv)

Return the transverse momentum (``p_T``) of a given Lorentz-vector-like `lv`, defined as
the Euclidean magnitude of the momentum components in the x-y plane.

# Example
For a four-momentum `(px, py, pz, E)`, this function returns `\\sqrt(px^2 + py^2)`.

# Notes
- The transverse components are defined with respect to the z-axis (3-axis), representing the perpendicular momentum to this axis.

# See Also
- [`pt2`](@ref): For the squared transverse momentum.

"""
pt

"""
    mt2(lv)

Return the squared transverse mass (``m_T^2``) of a given Lorentz-vector-like `lv`, which
is the difference between the squared time- (energy-) and the squared z-component.

# Example
For a four-momentum `(px, py, pz, E)`, this function returns `E^2 - pz^2`.

# Notes
- The transverse components are defined with respect to the z-axis (3-axis), indicating a projection in the x-y plane.

# See Also
- [`mt`](@ref): For the transverse mass.
"""
mt2

"""
    mt(lv)

Return the transverse mass (``m_T``) of a given Lorentz-vector-like `lv`, calculated as the
square root of the squared transverse mass. The transverse mass is often used in high-energy
physics to describe the effective mass of a system when only the transverse components are considered.

# Example
For a four-momentum `(px, py, pz, E)`, this function returns `\\sqrt(E^2 - pz^2)`.

# Notes
- If the squared transverse mass (`mT^2`) is negative, the function returns `-\\sqrt(-mT^2)` to
handle the imaginary mass situation that can occur in some relativistic systems.
- The transverse components are defined with respect to the z-axis (3-axis), indicating momentum in the x-y plane.

# Throws
- May include a warning if the transverse mass is negative, depending on user settings.

# See Also
- [`mt2`](@ref): For the squared transverse mass.
"""
mt

"""
    eta(lv)

Return the [pseudorapidity](https://en.wikipedia.org/wiki/Pseudorapidity) (``\\eta``) of a
given Lorentz-vector-like `lv`. The pseudorapidity is a commonly used quantity in high-energy
physics, particularly in collider experiments, and is defined as:

```math
    \\eta = -\\log(\\tan(\\theta/ 2))
```

where ``\\theta`` is the polar angle of the Lorentz-vector-like relative to the z-axis.


# Example
For a four-momentum `(px, py, pz, E)`, this function `log(tan(theta/2))` where `theta` is given by the [`polar_angle`](@ref).

!!! warning

    If the transverse momentum (`pt`) is zero (i.e., the particle is aligned with the beam axis),
    a warning is raised, and a large pseudorapidity value (±10e10) is returned as a convention.
    This occurs because the pseudorapidity is ill-defined when `pt = 0`.

# Notes
- Pseudorapidity is approximately equal to the rapidity ``y`` in the ultra-relativistic limit
    (when the particle's mass is negligible compared to its energy).

# See Also
- [`rapidity`](@ref): For the rapidity of the Lorentz-vector-like.
"""
eta

"""
    rapidity(lv)

Return the [rapidity](https://en.wikipedia.org/wiki/Rapidity) for a given Lorentz-vector-like `lv`.

The rapidity ``y`` is defined as:
```math
y = \\frac{1}{2}\\log((E + p_z) / (E - p_z))
```

where `E` is the energy (time- or 0-component of the Lorentz-vector-like), and `pz` is the component along the z-axis.

# Example
For a four-vector `(px, py, pz, E)`, this function calculates the rapidity as:

```Julia
y = 0.5 * log((E + pz) / (E - pz))
```

# Notes
- Rapidity is preferred over pseudorapidity when mass effects are significant, as it takes
    into account the energy and longitudinal momentum of the particle. In contrast, pseudorapidity
    depends only on the particle's direction and ignores mass.
- The transverse components of the momentum are defined with respect to the 3-axis (beam axis).
- Rapidity is Lorentz-invariant under boosts along the z-axis, making it useful for comparisons
    between different reference frames in collider experiments.

!!! warning

    If the particle's energy `E` is equal to its longitudinal momentum `pz`, resulting in a
    denominator of zero in the logarithm, the function will raise an error as rapidity is
    ill-defined in this case.

# See Also
- [`LorentzVectorBase.eta`](@ref): For the pseudorapidity of the Lorentz-vector-like.
"""
rapidity

### Light Cone Coordinates

"""
    plus_component(lv)

Return the plus component (``p^+``) of the Lorentz-vector-like `lv` in light-cone coordinates.

This component is defined as `(t + z) / 2`, where `t` is the time (or energy) component and
`z` is the third spatial component of the Lorentz-vector-like.


# Example
If `(x, y, z, t)` is a four-vector, this is equivalent to `(t + z) / 2`.

!!! warning

    This definition differs from the light-cone coordinate definitions commonly used in general relativity.

"""
plus_component

"""
    minus_component(lv)

Return the minus component (``p^-``) of the Lorentz-vector-like `lv` in light-cone coordinates.

This component is defined as `(t - z) / 2`, where `t` is the time (or energy) component and `z`
is the third spatial component of the Lorentz-vector-like.

# Example
If `(x, y, z, t)` is a four-vector, this is equivalent to `(t - z) / 2`.

!!! warning

    This definition differs from the light-cone coordinate definitions commonly used in general relativity.

"""
minus_component
