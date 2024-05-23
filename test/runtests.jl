using FourMomentumBase
using Test
using SafeTestsets

begin
    @time @safetestset "interface" begin
        include("interface.jl")
    end

    @time @safetestset "xyze" begin
        include("xyze.jl")
    end
end
