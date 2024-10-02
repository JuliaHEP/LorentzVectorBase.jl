
using Random
using LorentzVectorBase

const ATOL = 1e-15
const RNG = MersenneTwister(137137)

struct CustomMom
    x
    y
    z
    e
end

LorentzVectorBase.coordinate_system(::CustomMom) = LorentzVectorBase.XYZE()
LorentzVectorBase.px(mom::CustomMom) = mom.x
LorentzVectorBase.py(mom::CustomMom) = mom.y
LorentzVectorBase.pz(mom::CustomMom) = mom.z
LorentzVectorBase.energy(mom::CustomMom) = mom.e

x, y, z = rand(RNG, 3)
m = rand(RNG)
E = sqrt(x^2 + y^2 + z^2 + m^2)
mom_onshell = CustomMom(x, y, z, E)
mom_zero = CustomMom(0.0, 0.0, 0.0, 0.0)
mom_offshell = CustomMom(0.0, 0.0, m, 0.0)

@testset "spatial_magnitude consistence" for mom in [mom_onshell, mom_offshell, mom_zero]
    @test LorentzVectorBase.spatial_magnitude2(mom) == LorentzVectorBase.mag2(mom)
    @test LorentzVectorBase.spatial_magnitude(mom) == LorentzVectorBase.mag(mom)
    @test isapprox(LorentzVectorBase.spatial_magnitude(mom), sqrt(LorentzVectorBase.spatial_magnitude2(mom)))
end

@testset "spatial_magnitude values" begin
    @test isapprox(LorentzVectorBase.spatial_magnitude2(mom_onshell), x^2 + y^2 + z^2)
    @test isapprox(LorentzVectorBase.spatial_magnitude(mom_onshell), sqrt(x^2 + y^2 + z^2))
end

@testset "mass consistence" for mom_on in [mom_onshell, mom_zero]
    @test LorentzVectorBase.invariant_mass2(mom_on) == LorentzVectorBase.mass2(mom_on)
    @test LorentzVectorBase.invariant_mass(mom_on) == LorentzVectorBase.mass(mom_on)
    @test isapprox(
        LorentzVectorBase.invariant_mass(mom_on),
        sqrt(LorentzVectorBase.invariant_mass2(mom_on)),
    )
end

@testset "mass value" begin
    @test isapprox(LorentzVectorBase.invariant_mass2(mom_onshell), E^2 - (x^2 + y^2 + z^2))
    @test isapprox(
        LorentzVectorBase.invariant_mass(mom_onshell), sqrt(E^2 - (x^2 + y^2 + z^2))
    )

    @test isapprox(LorentzVectorBase.invariant_mass(mom_onshell), m)
    @test isapprox(LorentzVectorBase.invariant_mass(mom_offshell), -m)
    @test isapprox(LorentzVectorBase.invariant_mass(mom_zero), 0.0)
end

@testset "momentum components" begin
    @test LorentzVectorBase.energy(mom_onshell) == E
    @test LorentzVectorBase.px(mom_onshell) == x
    @test LorentzVectorBase.py(mom_onshell) == y
    @test LorentzVectorBase.pz(mom_onshell) == z

    @test isapprox(LorentzVectorBase.boost_beta(mom_onshell), sqrt(x^2 + y^2 + z^2) / E)
    @test isapprox(
        LorentzVectorBase.boost_gamma(mom_onshell),
        1 / sqrt(1.0 - LorentzVectorBase.boost_beta(mom_onshell)^2),
    )

    @test LorentzVectorBase.energy(mom_zero) == 0.0
    @test LorentzVectorBase.px(mom_zero) == 0.0
    @test LorentzVectorBase.py(mom_zero) == 0.0
    @test LorentzVectorBase.pz(mom_zero) == 0.0

    @test isapprox(LorentzVectorBase.boost_beta(mom_zero), 0.0)
    @test isapprox(LorentzVectorBase.boost_gamma(mom_zero), 1.0)
end

@testset "transverse coordinates" for mom_on in [mom_onshell, mom_zero]
    @test LorentzVectorBase.transverse_momentum2(mom_on) == LorentzVectorBase.pt2(mom_on)
    @test LorentzVectorBase.transverse_momentum2(mom_on) == LorentzVectorBase.perp2(mom_on)
    @test LorentzVectorBase.transverse_momentum(mom_on) == LorentzVectorBase.pt(mom_on)
    @test LorentzVectorBase.transverse_momentum(mom_on) == LorentzVectorBase.perp(mom_on)

    @test isapprox(
        LorentzVectorBase.transverse_momentum(mom_on),
        sqrt(LorentzVectorBase.transverse_momentum2(mom_on)),
    )

    @test LorentzVectorBase.transverse_mass2(mom_on) == LorentzVectorBase.mt2(mom_on)
    @test LorentzVectorBase.transverse_mass(mom_on) == LorentzVectorBase.mt(mom_on)
end

@testset "transverse coordiantes value" begin
    @test isapprox(LorentzVectorBase.transverse_momentum2(mom_onshell), x^2 + y^2)
    @test isapprox(LorentzVectorBase.transverse_momentum(mom_onshell), sqrt(x^2 + y^2))
    @test isapprox(LorentzVectorBase.transverse_mass2(mom_onshell), E^2 - z^2)
    @test isapprox(LorentzVectorBase.transverse_mass(mom_onshell), sqrt(E^2 - z^2))
    @test isapprox(LorentzVectorBase.transverse_mass(mom_offshell), -m)

    @test isapprox(LorentzVectorBase.rapidity(mom_onshell), 0.5 * log((E + z) / (E - z)))

    @test isapprox(LorentzVectorBase.transverse_momentum2(mom_zero), 0.0)
    @test isapprox(LorentzVectorBase.transverse_momentum(mom_zero), 0.0)
    @test isapprox(LorentzVectorBase.transverse_mass2(mom_zero), 0.0)
    @test isapprox(LorentzVectorBase.transverse_mass(mom_zero), 0.0)
end

@testset "spherical coordiantes consistence" for mom_on in [mom_onshell, mom_zero]
    @test isapprox(
        LorentzVectorBase.cos_theta(mom_on), cos(LorentzVectorBase.polar_angle(mom_on))
    )
    @test isapprox(
        LorentzVectorBase.cos_phi(mom_on), cos(LorentzVectorBase.azimuthal_angle(mom_on))
    )
    @test isapprox(
        LorentzVectorBase.sin_phi(mom_on), sin(LorentzVectorBase.azimuthal_angle(mom_on))
    )
end

@testset "spherical coordiantes values" begin
    @test isapprox(
        LorentzVectorBase.polar_angle(mom_onshell),
        atan(LorentzVectorBase.transverse_momentum(mom_onshell), z),
    )
    @test isapprox(LorentzVectorBase.polar_angle(mom_zero), 0.0)

    @test isapprox(LorentzVectorBase.azimuthal_angle(mom_onshell), atan(y, x))
    @test isapprox(LorentzVectorBase.azimuthal_angle(mom_zero), 0.0)
end

@testset "light-cone coordiantes" begin
    @test isapprox(LorentzVectorBase.plus_component(mom_onshell), 0.5 * (E + z))
    @test isapprox(LorentzVectorBase.minus_component(mom_onshell), 0.5 * (E - z))

    @test isapprox(LorentzVectorBase.plus_component(mom_zero), 0.0)
    @test isapprox(LorentzVectorBase.minus_component(mom_zero), 0.0)
end
