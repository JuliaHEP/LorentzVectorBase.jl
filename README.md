# LorentzVectorBase

Base interfaces for four-momenta in high-energy physics.

[![Stable Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaHEP.github.io/LorentzVectorBase.jl/stable/)
[![In development documentation](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaHEP.github.io/LorentzVectorBase.jl/dev/)
[![Test workflow status](https://github.com/JuliaHEP/LorentzVectorBase.jl/actions/workflows/Test.yml/badge.svg?branch=main)](https://github.com/JuliaHEP/LorentzVectorBase.jl/actions/workflows/Test.yml?query=branch%3Amain)
[![Docs workflow Status](https://github.com/JuliaHEP/LorentzVectorBase.jl/actions/workflows/Docs.yml/badge.svg?branch=main)](https://github.com/JuliaHEP/LorentzVectorBase.jl/actions/workflows/Docs.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaHEP/LorentzVectorBase.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaHEP/LorentzVectorBase.jl)

# Code Formatting

This package follows a standardized formatting configuration to ensure consistency across
the codebase. We enforce these formatting guidelines by running checks on all pull requests
through continuous integration (CI).

To format your code locally and ensure it meets the required standards, you can run the
following command in your terminal:

```bash
julia --project=.formatting -e 'using Pkg; Pkg.instantiate(); include(".formatting/format_all.jl")'
```

This will apply the necessary formatting rules to your code before submission.
