# LorentzVectorBase.jl

[![Stable Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaHEP.github.io/LorentzVectorBase.jl/stable/)
[![In development documentation](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaHEP.github.io/LorentzVectorBase.jl/dev/)
[![Test workflow status](https://github.com/JuliaHEP/LorentzVectorBase.jl/actions/workflows/Test.yml/badge.svg?branch=main)](https://github.com/JuliaHEP/LorentzVectorBase.jl/actions/workflows/Test.yml?query=branch%3Amain)
[![Docs workflow Status](https://github.com/JuliaHEP/LorentzVectorBase.jl/actions/workflows/Docs.yml/badge.svg?branch=main)](https://github.com/JuliaHEP/LorentzVectorBase.jl/actions/workflows/Docs.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaHEP/LorentzVectorBase.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaHEP/LorentzVectorBase.jl)

**LorentzVectorBase.jl** provides base interfaces for four-momenta in high-energy physics, facilitating standardized representations and operations on Lorentz vectors.

## Installation

Install the package using Julia's package manager:

```julia
using Pkg
Pkg.add("LorentzVectorBase")
```

## Usage

This package defines abstract interfaces for Lorentz vectors. To utilize concrete implementations, consider packages like [LorentzVectorHEP.jl](https://github.com/JuliaHEP/LorentzVectorHEP.jl) or [FourVectors.jl](https://github.com/mmikhasenko/FourVectors.jl).

## Example

Here is an example of how to define a custom Lorentz vector type and implement the required interface functions:

```Julia
struct CustomLVector
  x
  y
  z
  t
end

LorentzVectorBase.coordinate_system(::CustomLVector) = LorentzVectorBase.XYZT()
LorentzVectorBase.x(lv::CustomLVector) = lv.x
LorentzVectorBase.y(lv::CustomLVector) = lv.y
LorentzVectorBase.z(lv::CustomLVector) = lv.z
LorentzVectorBase.t(lv::CustomLVector) = lv.t


c = CustomLVector(1,2,3,4)
@assert isapprox(LorentzVectorBase.spatial_magnitude(c), sqrt(1^2 + 2^2 + 3^2))
```

## Code Formatting

To maintain code consistency, format your code with:

```julia
julia --project=.formatting -e 'using Pkg; Pkg.instantiate(); include(".formatting/format_all.jl")'
```

This ensures adherence to the project's formatting standards.

## License

This project is licensed under the MIT License.
