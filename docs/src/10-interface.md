# [Interface](@id interface)

This section explains how the object can become a `LorentzVector`. 

## Definition

We will call _`LorentzVector`-compliant_, a type that fulfills our interface described in this section. The package that provides such a type will be called _the provider_.

## Coordinate systems

The provider must specify a preferred coordinate system for its _`LorentzVector`-compliant_ type and provides  accesors to the components in this system with standardized methods (specified below). In case the object natively supports several coordinate systems, the one for which the component access is the most efficient will be chosen as the _preferred coordinate system_. It has to be one of the supported coordinate system.

The `LorentzVectorBase` package complements the component accessors to cover all the supported coordinate systems. It uses the components in the _preferred coordinate_ system to implement the complementary accessors. The Julia dispatch mechanism is used to give the preference to the accessors provided with the objet.

📝 A `LorenztVector`-compliant type can include more data than the four-vector. E.g., a type describing an elementary particle can comply, while containing more data than the particle four-momentum.

## Implementation

A type `MyLorentzVector` will comply to the `LorentzVector` interface if one of the following set of methods is implemented.

### Option 1: position with cartesian coordinates

| Required Methods                                             | Brief Description                               |
|--------------------------------------------------------------|-------------------------------------------------|
| `LorentzVectorBase.islorentzvector(::Type{MyLorentzVector})` | Declare that your type implements the interface |
| `LorentzVectorBase.coordinatesystem(::Type{MyLorentzVector}) = LorentzVectorBase.XYZE`  | Declare the preferred coordinate system |
| `LorentzVectorBase.x(::Tupe{MyLorentzVector})`               | x cartesian coordinate                          |
| `LorentzVectorBase.y(::Tupe{MyLorentzVector})`               | y cartesian coordinate                          |
| `LorentzVectorBase.z(::Tupe{MyLorentzVector})`               | z cartesian coordinate                          |
| `LorentzVectorBase.t(::Tupe{MyLorentzVector})`               | t cartesian coordinate                          |
|                                                              |                                                 |


### Option 2: four-momentum with catesian coordinates

| Required Methods                                             | Brief Description                               |
|--------------------------------------------------------------|-------------------------------------------------|
| `LorentzVectorBase.islorentzvector(::Type{MyLorentzVector})` | Declare that your type implements the interface |
| `LorentzVectorBase.coordinatesystem(::Type{MyLorentzVector}) = LorentzVectorBase.XYZE`  | Declare the preferred coordinated system |
| `LorentzVectorBase.px(::Tupe{MyLorentzVector})`              | momentum x-component                            |
| `LorentzVectorBase.py(::Tupe{MyLorentzVector})`              | momentum y-component                            |
| `LorentzVectorBase.pz(::Tupe{MyLorentzVector})`              | momentim z-component                            |
| `LorentzVectorBase.energy(::Tupe{MyLorentzVector})`          | energy                                          |

### Option 3 four-momentum with cylindrical coordinates

| Required Methods                                             | Brief Description                               |
|--------------------------------------------------------------|-------------------------------------------------|
| `LorentzVectorBase.islorentzvector(::Type{MyLorentzVector})` | Declare that your type implements the interface |
| `LorentzVectorBase.coordinatesystem(::Type{MyLorentzVector})`| Declare the preferred coordinated system. Must return PtEtaPhiM, PtEtaPhiE, PtYPhiM, or PtYPhiE (from LorentzVectorBase).|
| `LorentzVectorBase.pt(::Tupe{MyLorentzVector})`              | transverse momemun                              |
| `LorentzVectorBase.phi(::Tupe{MyLorentzVector})`             | azimuthal angle                                 |

<br>
and *one of*

| &nbsp;  |  &nbsp; |
|---|---|
| `LorentzVectorBase.eta(::Tupe{MyLorentzVector})`             | pseudorapity                                    |
| `LorentzVectorBase.rapidity(::Tupe{MyLorentzVector})`        | rapidity relative to the beam axis (z-axis)     |

<br>
and *one of*

| &nbsp;  |  &nbsp; |
|-|-|
| `LorentzVectorBase.energy(::Tupe{MyLorentzVector})`          | energy          |
| `LorentzVectorBase.mass(::Tupe{MyLorentzVector})`            | invariant mass  |

The methods that returns the coordinates of the preferred system (returned by `coordinate_system()`) must be implemented.

## Optional methods

| &nbsp;  |  &nbsp; |
|-|-|
| `LorentzVectorBase.mass2(::MyType{MyLorentzVector})`              | mass to the square |
| `LorentzVectorBase.rho2(::MyType{MyLorentzVector})`               | ρ² = \|**p**\|²      |
| Any of the above method i.e, a method of option Y when methods of option X are provided ||

