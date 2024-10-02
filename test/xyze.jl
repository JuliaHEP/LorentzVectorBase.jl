
using Random
using FourMomentumBase

const ATOL = 1e-15
const RNG = MersenneTwister(137137)

struct CustomMom
    e
    x
    y
    z
end

FourMomentumBase.coordinate_system(::CustomMom) = FourMomentumBase.EXYZ()
FourMomentumBase.px(mom::CustomMom) = mom.x
FourMomentumBase.py(mom::CustomMom) = mom.y
FourMomentumBase.pz(mom::CustomMom) = mom.z
FourMomentumBase.energy(mom::CustomMom) = mom.e

x, y, z = rand(RNG, 3)
m = rand(RNG)
E = sqrt(x^2 + y^2 + z^2 + m^2)
mom_onshell = CustomMom(E, x, y, z)
mom_zero = CustomMom(0.0, 0.0, 0.0, 0.0)
mom_offshell = CustomMom(0.0, 0.0, 0.0, m)

@testset "magnitude values" begin
    @test isapprox(FourMomentumBase.spatial_magnitude2(mom_onshell), x^2 + y^2 + z^2)
    @test isapprox(FourMomentumBase.spatial_magnitude(mom_onshell), sqrt(x^2 + y^2 + z^2))
end

@testset "mass consistence" for mom_on in [mom_onshell, mom_zero]
    @test isapprox(
        FourMomentumBase.mass(mom_on),
        sqrt(FourMomentumBase.mass2(mom_on)),
    )
end

@testset "mass value" begin
    @test isapprox(FourMomentumBase.mass2(mom_onshell), E^2 - (x^2 + y^2 + z^2))
    @test isapprox(
        FourMomentumBase.mass(mom_onshell), sqrt(E^2 - (x^2 + y^2 + z^2))
    )

    @test isapprox(FourMomentumBase.mass(mom_onshell), m)
    @test isapprox(FourMomentumBase.mass(mom_offshell), -m)
    @test isapprox(FourMomentumBase.mass(mom_zero), 0.0)
end

@testset "momentum components" begin
    @test FourMomentumBase.energy(mom_onshell) == E
    @test FourMomentumBase.px(mom_onshell) == x
    @test FourMomentumBase.py(mom_onshell) == y
    @test FourMomentumBase.pz(mom_onshell) == z

    @test isapprox(FourMomentumBase.boost_beta(mom_onshell), sqrt(x^2 + y^2 + z^2) / E)
    @test isapprox(
        FourMomentumBase.boost_gamma(mom_onshell),
        1 / sqrt(1.0 - FourMomentumBase.boost_beta(mom_onshell)^2),
    )

    @test FourMomentumBase.energy(mom_zero) == 0.0
    @test FourMomentumBase.px(mom_zero) == 0.0
    @test FourMomentumBase.py(mom_zero) == 0.0
    @test FourMomentumBase.pz(mom_zero) == 0.0

    @test isapprox(FourMomentumBase.boost_beta(mom_zero), 0.0)
    @test isapprox(FourMomentumBase.boost_gamma(mom_zero), 1.0)
end

@testset "transverse coordiantes value" begin
    @test isapprox(FourMomentumBase.pt2(mom_onshell), x^2 + y^2)
    @test isapprox(FourMomentumBase.pt(mom_onshell), sqrt(x^2 + y^2))
    @test isapprox(FourMomentumBase.mt2(mom_onshell), E^2 - z^2)
    @test isapprox(FourMomentumBase.mt(mom_onshell), sqrt(E^2 - z^2))
    @test isapprox(FourMomentumBase.mt(mom_offshell), -m)

    @test isapprox(FourMomentumBase.rapidity(mom_onshell), 0.5 * log((E + z) / (E - z)))

    @test isapprox(FourMomentumBase.pt2(mom_zero), 0.0)
    @test isapprox(FourMomentumBase.pt(mom_zero), 0.0)
    @test isapprox(FourMomentumBase.mt2(mom_zero), 0.0)
    @test isapprox(FourMomentumBase.mt(mom_zero), 0.0)
end

@testset "spherical coordiantes consistence" for mom_on in [mom_onshell, mom_zero]
    @test isapprox(
        FourMomentumBase.cos_theta(mom_on), cos(FourMomentumBase.polar_angle(mom_on))
    )
    @test isapprox(
        FourMomentumBase.cos_phi(mom_on), cos(FourMomentumBase.phi(mom_on))
    )
    @test isapprox(
        FourMomentumBase.sin_phi(mom_on), sin(FourMomentumBase.phi(mom_on))
    )
end

@testset "spherical coordiantes values" begin
    @test isapprox(
        FourMomentumBase.polar_angle(mom_onshell),
        atan(FourMomentumBase.pt(mom_onshell), z),
    )
    @test isapprox(FourMomentumBase.polar_angle(mom_zero), 0.0)

    @test isapprox(FourMomentumBase.phi(mom_onshell), atan(y, x))
    @test isapprox(FourMomentumBase.phi(mom_zero), 0.0)
end

@testset "light-cone coordiantes" begin
    @test isapprox(FourMomentumBase.plus_component(mom_onshell), 0.5 * (E + z))
    @test isapprox(FourMomentumBase.minus_component(mom_onshell), 0.5 * (E - z))

    @test isapprox(FourMomentumBase.plus_component(mom_zero), 0.0)
    @test isapprox(FourMomentumBase.minus_component(mom_zero), 0.0)
end
