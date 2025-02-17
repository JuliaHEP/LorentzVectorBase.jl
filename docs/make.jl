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

# some paths for links
readme_path = joinpath(project_path, "README.md")
index_path = joinpath(project_path, "docs/src/index.md")
license_path = "https://github.com/QEDjl-project/QEDcore.jl/blob/main/LICENSE"

# Copy README.md from the project base folder and use it as the start page
open(readme_path, "r") do readme_in
  readme_string = read(readme_in, String)

  # replace relative links in the README.md
  readme_string = replace(readme_string, "[MIT](LICENSE)" => "[MIT]($(license_path))")

  open(index_path, "w") do readme_out
    write(readme_out, readme_string)
  end
end

pages = [
  "Home" => "index.md", "Interface" => "10-interface.md", "Reference" => "95-reference.md"
]

try
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

finally
  # doing some garbage collection
  @info "GarbageCollection: remove generated landing page"
  rm(index_path)
end

deploydocs(; repo="github.com/JuliaHEP/LorentzVectorBase.jl", push_preview=true)
