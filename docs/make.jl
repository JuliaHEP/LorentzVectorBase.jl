using Pkg

# targeting the correct source code
# this asumes the make.jl script is located in QEDcore.jl/docs
project_path = Base.Filesystem.joinpath(Base.Filesystem.dirname(Base.source_path()), "..")
Pkg.develop(; path=project_path)

using LorentzVectorBase
using Documenter

DocMeta.setdocmeta!(
  LorentzVectorBase, :DocTestSetup, :(using LorentzVectorBase); recursive=true
)

pages = [
  "Home" => "index.md", "Interface" => "10-interface.md", "Reference" => "95-reference.md"
]

makedocs(;
  modules=[LorentzVectorBase],
  authors="Uwe Hernandez Acosta <u.hernandez@hzdr.de>",
  repo=Documenter.Remotes.GitHub("JuliaHEP", "LorentzVectorBase.jl"),
  sitename="LorentzVectorBase.jl",
  format=Documenter.HTML(;
    prettyurls=get(ENV, "CI", "false") == "true",
    canonical="https://JuliaHEP.github.io/LorentzVectorBase.jl",
    # repolink="https://github.com/JuliaHEP/LorentzVectorBase.jl",
    # edit_link="main",
    assets=String[],
  ),
  pages=pages,
)

deploydocs(; repo="github.com/JuliaHEP/LorentzVectorBase.jl", push_preview=true)
