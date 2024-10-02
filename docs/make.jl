using LorentzVectorBase
using Documenter

DocMeta.setdocmeta!(
    LorentzVectorBase, :DocTestSetup, :(using LorentzVectorBase); recursive=true
)

makedocs(;
    modules=[LorentzVectorBase],
    authors="Uwe Hernandez Acosta <u.hernandez@hzdr.de",
    sitename="LorentzVectorBase.jl",
    format=Documenter.HTML(;
        canonical="https://JuliaHEP.github.io/LorentzVectorBase.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=["Home" => "index.md"],
)

deploydocs(; repo="github.com/JuliaHEP/LorentzVectorBase.jl", devbranch="main")
