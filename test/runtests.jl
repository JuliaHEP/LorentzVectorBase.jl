using LorentzVectorBase
using Test
using SafeTestsets

begin
  @time @safetestset "interface" begin
    include("interface.jl")
  end

  @time @safetestset "XYZT" begin
    include("XYZT.jl")
  end

  @time @safetestset "PxPyPzE" begin
    include("PxPyPzE.jl")
  end
end
