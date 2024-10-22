
using Random
using LorentzVectorBase

const ATOL = 1e-15
const RNG = MersenneTwister(137137)

struct CustomMom
  px
  py
  pz
  E
end

LorentzVectorBase.coordinate_system(::CustomMom) = LorentzVectorBase.PxPyPzE()
LorentzVectorBase.px(mom::CustomMom) = mom.px
LorentzVectorBase.py(mom::CustomMom) = mom.py
LorentzVectorBase.pz(mom::CustomMom) = mom.pz
LorentzVectorBase.E(mom::CustomMom) = mom.E

px, py, pz = rand(RNG, 3)
m = rand(RNG)
E = sqrt(px^2 + py^2 + pz^2 + m^2)
mom_onshell = CustomMom(px, py, pz, E)
mom_zero = CustomMom(0.0, 0.0, 0.0, 0.0)
mom_offshell = CustomMom(0.0, 0.0, m, 0.0)

@testset "cooridnate names" begin
  coordinate_names(LorentzVectorBase.PxPyPzE()) == (:px, :py, :pz, :E)
end

@testset "spatial_magnitude consistence" for mom in [mom_onshell, mom_offshell, mom_zero]
  @test isapprox(
    LorentzVectorBase.spatial_magnitude(mom),
    sqrt(LorentzVectorBase.spatial_magnitude2(mom)),
  )
end

@testset "spatial_magnitude values" begin
  @test isapprox(LorentzVectorBase.spatial_magnitude2(mom_onshell), px^2 + py^2 + pz^2)
  @test isapprox(LorentzVectorBase.spatial_magnitude(mom_onshell), sqrt(px^2 + py^2 + pz^2))
end

@testset "mass consistence" for mom_on in [mom_onshell, mom_zero]
  @test isapprox(LorentzVectorBase.mass(mom_on), sqrt(LorentzVectorBase.mass2(mom_on)))
  @test LorentzVectorBase.invariant_mass2(mom_on) == LorentzVectorBase.mass2(mom_on)
  @test LorentzVectorBase.invariant_mass(mom_on) == LorentzVectorBase.mass(mom_on)
  @test isapprox(
    LorentzVectorBase.invariant_mass(mom_on),
    sqrt(LorentzVectorBase.invariant_mass2(mom_on)),
  )
end

@testset "mass value" begin
  @test isapprox(LorentzVectorBase.mass2(mom_onshell), E^2 - (px^2 + py^2 + pz^2))
  @test isapprox(LorentzVectorBase.mass(mom_onshell), sqrt(E^2 - (px^2 + py^2 + pz^2)))

  @test isapprox(LorentzVectorBase.mass(mom_onshell), m)
  @test isapprox(LorentzVectorBase.mass(mom_offshell), -m)
  @test isapprox(LorentzVectorBase.mass(mom_zero), 0.0)
end

@testset "momentum components" begin
  @test LorentzVectorBase.t(mom_onshell) == E
  @test LorentzVectorBase.x(mom_onshell) == px
  @test LorentzVectorBase.y(mom_onshell) == py
  @test LorentzVectorBase.z(mom_onshell) == pz

  @test LorentzVectorBase.E(mom_onshell) == E
  @test LorentzVectorBase.E(LorentzVectorBase.PxPyPzE(), mom_onshell) == E
  @test LorentzVectorBase.px(mom_onshell) == px
  @test LorentzVectorBase.px(LorentzVectorBase.PxPyPzE(), mom_onshell) == px
  @test LorentzVectorBase.py(mom_onshell) == py
  @test LorentzVectorBase.py(LorentzVectorBase.PxPyPzE(), mom_onshell) == py
  @test LorentzVectorBase.pz(mom_onshell) == pz
  @test LorentzVectorBase.pz(LorentzVectorBase.PxPyPzE(), mom_onshell) == pz

  @test isapprox(LorentzVectorBase.boost_beta(mom_onshell), sqrt(px^2 + py^2 + pz^2) / E)
  @test isapprox(
    LorentzVectorBase.boost_gamma(mom_onshell),
    1 / sqrt(1.0 - LorentzVectorBase.boost_beta(mom_onshell)^2),
  )

  @test LorentzVectorBase.t(mom_zero) == 0.0
  @test LorentzVectorBase.x(mom_zero) == 0.0
  @test LorentzVectorBase.y(mom_zero) == 0.0
  @test LorentzVectorBase.z(mom_zero) == 0.0
  @test isapprox(LorentzVectorBase.boost_beta(mom_zero), 0.0)
  @test isapprox(LorentzVectorBase.boost_gamma(mom_zero), 1.0)
end

@testset "transverse coordiantes value" begin
  @test isapprox(LorentzVectorBase.pt2(mom_onshell), px^2 + py^2)
  @test isapprox(LorentzVectorBase.pt(mom_onshell), sqrt(px^2 + py^2))
  @test isapprox(LorentzVectorBase.mt2(mom_onshell), E^2 - pz^2)
  @test isapprox(LorentzVectorBase.mt(mom_onshell), sqrt(E^2 - pz^2))
  @test isapprox(LorentzVectorBase.mt(mom_offshell), -m)

  @test isapprox(LorentzVectorBase.rapidity(mom_onshell), 0.5 * log((E + pz) / (E - pz)))

  @test isapprox(LorentzVectorBase.pt2(mom_zero), 0.0)
  @test isapprox(LorentzVectorBase.pt(mom_zero), 0.0)
  @test isapprox(LorentzVectorBase.mt2(mom_zero), 0.0)
  @test isapprox(LorentzVectorBase.mt(mom_zero), 0.0)
end

@testset "spherical coordiantes consistence" for mom_on in [mom_onshell, mom_zero]
  @test isapprox(
    LorentzVectorBase.cos_theta(mom_on), cos(LorentzVectorBase.polar_angle(mom_on))
  )
  @test isapprox(LorentzVectorBase.cos_phi(mom_on), cos(LorentzVectorBase.phi(mom_on)))
  @test isapprox(LorentzVectorBase.sin_phi(mom_on), sin(LorentzVectorBase.phi(mom_on)))
end

@testset "spherical coordiantes values" begin
  @test isapprox(
    LorentzVectorBase.polar_angle(mom_onshell), atan(LorentzVectorBase.pt(mom_onshell), pz)
  )
  @test isapprox(LorentzVectorBase.polar_angle(mom_zero), 0.0)

  @test isapprox(LorentzVectorBase.phi(mom_onshell), atan(py, px))
  @test isapprox(LorentzVectorBase.phi(mom_zero), 0.0)
end

@testset "light-cone coordiantes" begin
  @test isapprox(LorentzVectorBase.plus_component(mom_onshell), 0.5 * (E + pz))
  @test isapprox(LorentzVectorBase.minus_component(mom_onshell), 0.5 * (E - pz))

  @test isapprox(LorentzVectorBase.plus_component(mom_zero), 0.0)
  @test isapprox(LorentzVectorBase.minus_component(mom_zero), 0.0)
end
