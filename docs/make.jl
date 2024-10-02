using LorentzVectorBase
using Documenter

DocMeta.setdocmeta!(LorentzVectorBase, :DocTestSetup, :(using LorentzVectorBase); recursive = true)

const numbered_pages = [
  file for
  file in readdir(joinpath(@__DIR__, "src")) if file != "index.md" && splitext(file)[2] == ".md"
]

makedocs(;
    modules = [LorentzVectorBase],
    authors = "Uwe Hernandez Acosta <u.hernandez@hzdr.de>",
    repo = "https://github.com/JuliaHEP/LorentzVectorBase.jl/blob/{commit}{path}#{line}",
    sitename = "LorentzVectorBase.jl",
    format = Documenter.HTML(;
        canonical = "https://JuliaHEP.github.io/LorentzVectorBase.jl",
        repolink = "https://github.com/JuliaHEP/LorentzVectorBase.jl"
        edit_link="main",
        assets=String[]
    ),
    pages = ["index.md"; numbered_pages],
)

deploydocs(; repo = "github.com/JuliaHEP/LorentzVectorBase.jl")
