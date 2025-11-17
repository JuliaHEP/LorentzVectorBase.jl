
@safetestset "20-new_four_vector" begin
  include(joinpath(dirname(@__DIR__), "docs", "src", "tutorial", "20-new_four_vector.jl"))
end

@safetestset "21-new_coord_system" begin
  include(joinpath(dirname(@__DIR__), "docs", "src", "tutorial", "21-new_coord_system.jl"))
end
