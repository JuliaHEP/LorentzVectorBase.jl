```@meta
CurrentModule = LorentzVectorBase
```

# LorentzVectorBase

Documentation for [LorentzVectorBase](https://github.com/JuliaHEP/LorentzVectorBase.jl).


```@autodocs
Modules = [FourMomentumBase]
```


## Implementing the interface (i.e. becoming a `LorentzVector`)

A type `MyLorentzVector` will comply to the `LorentzVector` interface if one of the following et of methods is implemented.

### Option 1: position with cartesian coordinates

| Required Methods                                             | Brief Description                               |
|--------------------------------------------------------------|-------------------------------------------------|
| `LorentzVectorBase.islorentzvector(::Type{MyLorentzVector})` | Declare that your type implements the interface |
| `LorentzVectorBase.coordinatesystem(::Type{MyLorentzVector}) = LorentzVectorBase.XYZE`  | Declare the preferred coordinated system |
| `LorentzVectorBase.x(::Tupe{MyLorentzVector})`               | x cartesian coordinate                          |
| `LorentzVectorBase.y(::Tupe{MyLorentzVector})`               | y cartesian coordinate                          |
| `LorentzVectorBase.z(::Tupe{MyLorentzVector})`               | z cartesian coordinate                          |
| `LorentzVectorBase.t(::Tupe{MyLorentzVector})`               | t cartesian coordinate                          |                                                             |                                                 |

### Option 2: four-momentum with catesian coordinates

| Required Methods                                             | Brief Description                               |
|--------------------------------------------------------------|-------------------------------------------------|
| `LorentzVectorBase.islorentzvector(::Type{MyLorentzVector})` | Declare that your type implements the interface |
| `LorentzVectorBase.coordinatesystem(::Type{MyLorentzVector}) = LorentzVectorBase.XYZE`  | Declare the preferred coordinated system |
| `LorentzVectorBase.px(::Tupe{MyLorentzVector})`              | x cartesian coordinate                          |
| `LorentzVectorBase.py(::Tupe{MyLorentzVector})`              | y cartesian coordinate                          |
| `LorentzVectorBase.pz(::Tupe{MyLorentzVector})`              | z cartesian coordinate                          |
| `LorentzVectorBase.pt(::Tupe{MyLorentzVector})`              | t cartesian coordinate                          |                                                             |                                                 |

### Option 3 four-momentum with cylindrical coordinates

| Required Methods                                             | Brief Description                               |
|--------------------------------------------------------------|-------------------------------------------------|
| `LorentzVectorBase.islorentzvector(::Type{MyLorentzVector})` | Declare that your type implements the interface |
| `LorentzVectorBase.coordinatesystem(::Type{MyLorentzVector})`| Declare the preferred coordinated system. Must return PtEtaPhiM, PtEtaPhiE, PtYPhiM, or PtYPhiE (from LorentzVectorBase).|
| `LorentzVectorBase.pt(::Tupe{MyLorentzVector})`              | x cartesian coordinate                          |
| `LorentzVectorBase.phi(::Tupe{MyLorentzVector})`             | z cartesian coordinate                          |

<br>
and *one of*

| | |
|-|-|
| `LorentzVectorBase.eta(::Tupe{MyLorentzVector})`             | y cartesian coordinate                          |
| `LorentzVectorBase.rapidity(::Tupe{MyLorentzVector})`        | y cartesian coordinate                          |

<br>
and *one of*

| | |
|-|-|
| `LorentzVectorBase.energy(::Tupe{MyLorentzVector})`          | energy |
| `LorentzVectorBase.mass(::Tupe{MyLorentzVector})`            | invariant mass  |

The methods that returns the coordinates of the prefered system (returned by `coordinatesystem()`) must be implemented.

## Optional methods

| | |
|-|-|
| `LorentzVectorBase.mass2(::MyType{MyLorentzVector})`              | mass to the square |
| `LorentzVectorBase.spatial_magnitude2(::MyType{MyLorentzVector})` | mass to the square |
| Any of the above method i.e, a method of option Y when methods of option X are provided || 
=======
>>>>>>> origin/main
