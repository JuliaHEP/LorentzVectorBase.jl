```@meta
CurrentModule = LorentzVectorBase
```

# [`LorentzVectorBase` Interface](@id interface)

The `LorentzVectorBase` package defines a **common interface for
LorentzVectorBase-compliant types** in Julia. This interface allows developers to define
their own custom four-vector types (e.g., for particles or kinematic configurations) and
automatically gain access to a large suite of common kinematic computations. For maximum
flexibility, it is **not necessary** to inherit from an abstract base
type.

## Purpose

The main goal is to provide a lightweight abstraction that enables:

- Interoperability between different packages using Lorentz vectors
- Automatic derivation of many derived quantities (e.g. $p_T$, $\eta$, $m$) from a minimal interface
- Coordinate system flexibility while maintaining performance

## Defining a Lorentz-Vector-Like Type

To make your type compliant with `LorentzVectorBase`, you must:

Assign a coordinate system using:

```julia
LorentzVectorBase.coordinate_system(::MyVector) = XYZT()
```

Coordinate systems are tagged using constructors like `XYZT()`, `PtEtaPhiE()`, etc. These indicate how the four components are interpreted.

Implement the four accessors required by the chosen coordinate system.

For example, with `XYZT()`:

```julia
x(::MyVector)
y(::MyVector)
z(::MyVector)
t(::MyVector)
```

You can inspect the required accessors for a given coordinate system using:

```julia
coordinate_system(XYZT())  # returns (:x, :y, :z, :t)
```

This indicates which component accessors your type must implement to be compliant with that system.

That's it! Once those are defined, the `LorentzVectorBase` package will automatically
provide implementations for a wide variety of additional kinematic functions and
coordinate conversions.

## [What You Get Automatically](@id getter)

Once a minimal interface is implemented, the following functions become available (among others), categorized by topic:

### Cartesian Components

- [`x`](@ref), [`y`](@ref), [`z`](@ref), [`t`](@ref)
- [`px`](@ref), [`py`](@ref), [`pz`](@ref), [`E`](@ref)

### Spherical and Cylindrical Coordinates

- [`spatial_magnitude`](@ref), [`spatial_magnitude2`](@ref)
- [`polar_angle`](@ref), [`cos_theta`](@ref)
- [`phi`](@ref), [`cos_phi`](@ref), [`sin_phi`](@ref)

### Mass and Invariant Quantities

- [`mass`](@ref), [`mass2`](@ref)
- [`mt`](@ref), [`mt2`](@ref)
- [`pt`](@ref), [`pt2`](@ref)

### Rapidity and Related Quantities

- [`eta`](@ref): pseudorapidity
- [`rapidity`](@ref)

### Boost Parameters

- [`boost_beta`](@ref), [`boost_gamma`](@ref)

### Light-Cone Coordinates

- [`plus_component`](@ref), [`minus_component`](@ref)

### Accessor Aliases

To improve readability and interoperability, `LorentzVectorBase` provides a set of
**aliases** for common physics terminology. These aliases map frequently used or
alternative names to the canonical accessor functions.

For example, `energy` is an alias for `t`, and `invariant_mass` maps to `mass`.

```julia
energy(lv)           === t(lv)
invariant_mass(lv)   === mass(lv)
transverse_momentum(lv) === pt(lv)
```

This allows users to choose more descriptive or domain-specific terminology without losing compatibility.

### Available Aliases

| Alias                  | Canonical Function |
| ---------------------- | ------------------ |
| `energy`               | `t`                |
| `invariant_mass`       | `mass`             |
| `invariant_mass2`      | `mass2`            |
| `transverse_momentum`  | `pt`               |
| `transverse_momentum2` | `pt2`              |
| `perp`                 | `pt`               |
| `perp2`                | `pt2`              |
| `transverse_mass`      | `mt`               |
| `transverse_mass2`     | `mt2`              |
| `azimuthal_angle`      | `phi`              |
| `pseudorapidity`       | `eta`              |


Note, that most of the package functions are not exported. They can always be called with `LorentzVectorBase.` prefix.
For convenience, these methods can be exported in custom packages that utilize LorentzVectorBase.
For example, as follows,

```julia
module Custom4Vector

import LorentzVectorBase: invariant_mass
export invariant_mass

end
```

See also [an example](https://github.com/mmikhasenko/FourVectors.jl/blob/main/src/FourVectors.jl#L28-L33) of exporting multiple selected methods in a loop.

## Coordinate System Tags

The following coordinate systems are supported via tags like `XYZT()`, `PtEtaPhiM()`, etc.:

- `XYZT`, `PxPyPzE` — position/time or cartesian four-momentum
- `PtEtaPhiM` — common in collider physics

Each tag specifies which component names (`x`, `pt`, `eta`, etc.) you must implement.

## Example

```julia
struct MyVector
    px::Float64
    py::Float64
    pz::Float64
    E::Float64
end

LorentzVectorBase.coordinate_system(::MyVector) = PxPyPzE()

LorentzVectorBase.px(v::MyVector) = v.px
LorentzVectorBase.py(v::MyVector) = v.py
LorentzVectorBase.pz(v::MyVector) = v.pz
LorentzVectorBase.energy(v::MyVector) = v.E
```

Now your type supports:

```julia
mass(MyVector(...))
eta(MyVector(...))
pt(MyVector(...))
phi(MyVector(...))
```

without implementing them manually.
