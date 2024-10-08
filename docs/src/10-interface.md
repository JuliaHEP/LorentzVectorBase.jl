# [Interface](@id interface)

This section explains how an object can become a _object with kinematic informations_.

## Definition

A type that adheres to the interface described in this section will be referred to as
_`KinematicInterface`-compliant_. A package providing such a type will be called _the provider_.

## Coordinate Systems

The provider must define a preferred coordinate system for its _`KinematicInterface`-compliant_
type and provide accessors for the components of this system using standardized methods
(outlined below). If the object natively supports multiple coordinate systems, the provider
should choose the one in which component access is the most efficient as the _preferred
coordinate system_. This system must be one of the supported options.

The `LorentzVectorBase` package supplements these component accessors to cover all supported
coordinate systems. It uses the components of the _preferred coordinate system_ to implement
complementary accessors. Julia’s dispatch mechanism prioritizes the accessors provided by
the object itself.

!!! note

    A `KinematicInterface`-compliant type can store additional data beyond the four-vector. For instance,
    a type representing an elementary particle may comply while containing more information than
    just the particle’s four-momentum.

## Implementation

A type `MyLorentzVector` (which do not necessary need to be a vector) will comply with the `KinematicInterface` if it implements
one of the following sets of methods:

### Option 1: Position with Cartesian Coordinates

| Required Methods                                                                        | Brief Description                               |
| --------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `LorentzVectorBase.islorentzvector(::Type{MyLorentzVector})`                            | Declare that your type implements the interface |
| `LorentzVectorBase.coordinate_system(::Type{MyLorentzVector}) = LorentzVectorBase.XYZE` | Declare the preferred coordinate system         |
| `LorentzVectorBase.x(::MyLorentzVector)`                                                | X Cartesian coordinate                          |
| `LorentzVectorBase.y(::MyLorentzVector)`                                                | Y Cartesian coordinate                          |
| `LorentzVectorBase.z(::MyLorentzVector)`                                                | Z Cartesian coordinate                          |
| `LorentzVectorBase.t(::MyLorentzVector)`                                                | Time coordinate (t)                             |

### Option 2: Four-Momentum with Cartesian Coordinates

| Required Methods                                                                        | Brief Description                               |
| --------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `LorentzVectorBase.islorentzvector(::Type{MyLorentzVector})`                            | Declare that your type implements the interface |
| `LorentzVectorBase.coordinate_system(::Type{MyLorentzVector}) = LorentzVectorBase.XYZE` | Declare the preferred coordinate system         |
| `LorentzVectorBase.px(::MyLorentzVector)`                                               | Momentum X-component                            |
| `LorentzVectorBase.py(::MyLorentzVector)`                                               | Momentum Y-component                            |
| `LorentzVectorBase.pz(::MyLorentzVector)`                                               | Momentum Z-component                            |
| `LorentzVectorBase.energy(::MyLorentzVector)`                                           | Energy                                          |

### Option 3: Four-Momentum with Cylindrical Coordinates

| Required Methods                                               | Brief Description                                                                                                                       |
| -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `LorentzVectorBase.islorentzvector(::Type{MyLorentzVector})`   | Declare that your type implements the interface                                                                                         |
| `LorentzVectorBase.coordinate_system(::Type{MyLorentzVector})` | Declare the preferred coordinate system, which must return `PtEtaPhiM`, `PtEtaPhiE`, `PtYPhiM`, or `PtYPhiE` (from `LorentzVectorBase`) |
| `LorentzVectorBase.pt(::MyLorentzVector)`                      | Transverse momentum                                                                                                                     |
| `LorentzVectorBase.phi(::MyLorentzVector)`                     | Azimuthal angle                                                                                                                         |

Additionally, you must implement _one_ of the following:

| Required Method                                 | Description                                 |
| ----------------------------------------------- | ------------------------------------------- |
| `LorentzVectorBase.eta(::MyLorentzVector)`      | Pseudorapidity                              |
| `LorentzVectorBase.rapidity(::MyLorentzVector)` | Rapidity relative to the beam axis (z-axis) |

And _one_ of:

| Required Method                               | Description    |
| --------------------------------------------- | -------------- |
| `LorentzVectorBase.energy(::MyLorentzVector)` | Energy         |
| `LorentzVectorBase.mass(::MyLorentzVector)`   | Invariant mass |

The methods returning the coordinates of the preferred system (as specified by `coordinate_system()`) must be implemented.

## Optional Methods

| Optional Method                              | Description                                  |
| -------------------------------------------- | -------------------------------------------- |
| `LorentzVectorBase.mass2(::MyLorentzVector)` | Square of the mass                           |
| `LorentzVectorBase.rho2(::MyLorentzVector)`  | ρ² = \|**p**\|² (squared momentum magnitude) |

Additionally, any method from another option (i.e., a method from Option Y when methods from Option X are provided) may also be implemented.
