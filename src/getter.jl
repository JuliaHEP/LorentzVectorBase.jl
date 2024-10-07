"""
    t(mom)

Return the time (energy) component of the four-momentum `mom`.
"""
t

"""
    x(mom)

Return the x-component (first spatial component) of the four-momentum `mom`.
"""
x

"""
    y(mom)

Return the y-component (second spatial component) of the four-momentum `mom`.
"""
y

"""
    z(mom)

Return the z-component (third spatial component) of the four-momentum `mom`.
"""
z

"""
    eta(mom)

Return the pseudorapidity (η) of a given four-momentum `mom`.


!!! warning

    If the transverse momentum is zero, a warning is raised and a large value (±10e10) is returned.

"""
eta


### Spherical Coordinates

"""
    polar_angle(mom)

Return the polar angle (``\\theta``) of the four-momentum `mom`.

# Example
If ``(x, y, z, t)`` is a four-momentum, this is equivalent to ``\\arccos(z / \\sqrt{x^2 + y^2 + z^2})`.

!!! note

    If the momentum is zero, the function returns zero for the angle.

"""
polar_angle

"""
    cos_theta(mom)

Return the cosine of the polar angle (``\\theta``) of the four-momentum `mom`.

# Example

If ``(x, y, z, t)`` is a four-momentum, this is equivalent to ``z / \\sqrt{x^2 + y^2 + z^2}``.
"""
cos_theta

"""
    phi(mom)

Return the azimuthal angle (``\\phi``) of the four-momentum `mom`.

The azimuthal angle is the angle between the x-axis and the projection of the momentum on the x-y plane.

# Example
    If ``(x, y, z, t)`` is a four-momentum, this is equivalent to ``atan(y / x)``.

!!! note

    The azimuthal angle is defined with respect to the z-axis.

"""
phi

"""
    cos_phi(mom)

Return the cosine of the azimuthal angle (``\\phi``) of the four-momentum `mom`.

This is a faster version of `cos(phi(mom))`, using the transverse momentum and x-component of the four-momentum.

# Example
If ``(x, y, z, t)`` is a four-momentum, this is equivalent to ``x / \\sqrt{x^2 + y^2}``.

"""
cos_phi

"""
    sin_phi(mom)

Return the sine of the azimuthal angle (``\\phi``) of the four-momentum `mom`.

Depending on the coordinate system, this might be an equivalent but faster version of `sin(phi(mom))`.

# Example
If ``(x, y, z, t)`` is a four-momentum, this is equivalent to ``y / \\sqrt{x^2 + y^2}``.

"""
sin_phi

### Light Cone Coordinates

"""
    plus_component(mom)

Return the plus component (``p^+``) of the four-momentum `mom` in light-cone coordinates.

This component is defined as `(t + z) / 2`, where `t` is the time (or energy) component and `z` is the third spatial component of the

# Arguments
- `mom`: A four-momentum object.

# Returns
- The plus component (p⁺) of the four-momentum `mom`.

# Example
    If `(x, y, z, t)` is a four-momentum, this is equivalent to `(t + z) / 2`.

!!! warning
    This definition differs from the light-cone coordinate definitions commonly used in general relativity.
"""
plus_component

"""
    minus_component(mom)

Return the minus component (p⁻) of the four-momentum `mom` in light-cone coordinates.

This component is defined as `(t - z) / 2`, where `t` is the time (or energy) component and `z` is the third spatial component of the momentum.

# Arguments
- `mom`: A four-momentum object.

# Returns
-

 The minus component (p⁻) of the four-momentum `mom`.

# Example
    If `(x, y, z, t)` is a four-momentum, this is equivalent to `(t - z) / 2`.

!!! warning
    This definition differs from the light-cone coordinate definitions commonly used in general relativity.
"""
minus_component
