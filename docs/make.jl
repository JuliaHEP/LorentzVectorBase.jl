using FourMomentumBase
using Documenter

DocMeta.setdocmeta!(
    FourMomentumBase, :DocTestSetup, :(using FourMomentumBase); recursive=true
)

makedocs(;
    modules=[FourMomentumBase],
    authors="Uwe Hernandez Acosta <u.hernandez@hzdr.de",
    sitename="FourMomentumBase.jl",
    format=Documenter.HTML(;
        canonical="https://szabo137.github.io/FourMomentumBase.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=["Home" => "index.md"],
)

deploydocs(; repo="github.com/szabo137/FourMomentumBase.jl", devbranch="main")
