using Pkg

# targeting the correct source code
# this asumes the make.jl script is located in QEDcore.jl/docs
project_path = Base.Filesystem.joinpath(Base.Filesystem.dirname(Base.source_path()), "..")
Pkg.develop(; path=project_path)

using LorentzVectorBase
using Documenter
using Literate

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

# setup examples using Literate.jl
literate_paths = [
  Base.Filesystem.joinpath(project_path, "docs/src/tutorial/20-new_four_vector.jl"),
  Base.Filesystem.joinpath(project_path, "docs/src/tutorial/21-new_coord_system.jl"),
]

tutorial_output_dir = joinpath(project_path, "docs/src/generated/")
!ispath(tutorial_output_dir) && mkdir(tutorial_output_dir)
@info "Literate: create temp dir at $tutorial_output_dir"

tutorial_output_dir_name = splitpath(tutorial_output_dir)[end]

pages = [
  "Home" => "index.md",
  "Interface" => "10-interface.md",
  "Tutorial" => [
    "New Four-Vector" => joinpath(tutorial_output_dir_name, "20-new_four_vector.md"),
    "New Coordinate System" =>
      joinpath(tutorial_output_dir_name, "21-new_coord_system.md"),
  ],
  "Contributors guide" => "90-contributing.md",
  "Developer docs" => "91-dev_docs.md",
  "API Reference" => "95-reference.md",
]

try

  # generate markdown files with Literate.jl
  for file in literate_paths
    Literate.markdown(file, tutorial_output_dir; documenter=true)
  end
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
finally
  # doing some garbage collection
  @info "GarbageCollection: remove generated landing page"
  rm(index_path)

  @info "GarbageCollection: remove generated tutorial files"
  rm(tutorial_output_dir; recursive=true)
end
