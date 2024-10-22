using LorentzVectorBase
using Test
using SafeTestsets

begin
  @time @safetestset "interface" begin
    include("interface.jl")
  end

  @time @safetestset "xyze" begin
    include("xyze.jl")
  end

  @time @safetestset "PtEtaPhiM" begin
    include("PtEtaPhiM.jl")
  end
end
