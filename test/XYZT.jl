
using Random
using LorentzVectorBase

const ATOL = 1e-15
const RNG = MersenneTwister(137137)

struct CustomLVector
  x
  y
  z
  t
end

LorentzVectorBase.coordinate_system(::CustomLVector) = LorentzVectorBase.XYZT()
LorentzVectorBase.x(mom::CustomLVector) = mom.x
LorentzVectorBase.y(mom::CustomLVector) = mom.y
LorentzVectorBase.z(mom::CustomLVector) = mom.z
LorentzVectorBase.t(mom::CustomLVector) = mom.t

x, y, z = rand(RNG, 3)
m = rand(RNG)
t = sqrt(x^2 + y^2 + z^2 + m^2)
mom_onshell = CustomLVector(x, y, z, t)
mom_zero = CustomLVector(0.0, 0.0, 0.0, 0.0)
mom_offshell = CustomLVector(0.0, 0.0, m, 0.0)

@testset "spatial_magnitude consistence" for mom in [mom_onshell, mom_offshell, mom_zero]
  @test isapprox(
    LorentzVectorBase.spatial_magnitude(mom),
    sqrt(LorentzVectorBase.spatial_magnitude2(mom)),
  )
end

@testset "spatial_magnitude values" begin
  @test isapprox(LorentzVectorBase.spatial_magnitude2(mom_onshell), x^2 + y^2 + z^2)
  @test isapprox(LorentzVectorBase.spatial_magnitude(mom_onshell), sqrt(x^2 + y^2 + z^2))
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
  @test isapprox(LorentzVectorBase.mass2(mom_onshell), t^2 - (x^2 + y^2 + z^2))
  @test isapprox(LorentzVectorBase.mass(mom_onshell), sqrt(t^2 - (x^2 + y^2 + z^2)))

  @test isapprox(LorentzVectorBase.mass(mom_onshell), m)
  @test isapprox(LorentzVectorBase.mass(mom_offshell), -m)
  @test isapprox(LorentzVectorBase.mass(mom_zero), 0.0)
end

@testset "momentum components" begin
  @test LorentzVectorBase.t(mom_onshell) == t
  @test LorentzVectorBase.x(mom_onshell) == x
  @test LorentzVectorBase.y(mom_onshell) == y
  @test LorentzVectorBase.z(mom_onshell) == z

  @test isapprox(LorentzVectorBase.boost_beta(mom_onshell), sqrt(x^2 + y^2 + z^2) / t)
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
  @test isapprox(LorentzVectorBase.pt2(mom_onshell), x^2 + y^2)
  @test isapprox(LorentzVectorBase.pt(mom_onshell), sqrt(x^2 + y^2))
  @test isapprox(LorentzVectorBase.mt2(mom_onshell), t^2 - z^2)
  @test isapprox(LorentzVectorBase.mt(mom_onshell), sqrt(t^2 - z^2))
  @test isapprox(LorentzVectorBase.mt(mom_offshell), -m)

  @test isapprox(LorentzVectorBase.rapidity(mom_onshell), 0.5 * log((t + z) / (t - z)))

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
    LorentzVectorBase.polar_angle(mom_onshell), atan(LorentzVectorBase.pt(mom_onshell), z)
  )
  @test isapprox(LorentzVectorBase.polar_angle(mom_zero), 0.0)

  @test isapprox(LorentzVectorBase.phi(mom_onshell), atan(y, x))
  @test isapprox(LorentzVectorBase.phi(mom_zero), 0.0)
end

@testset "light-cone coordiantes" begin
  @test isapprox(LorentzVectorBase.plus_component(mom_onshell), 0.5 * (t + z))
  @test isapprox(LorentzVectorBase.minus_component(mom_onshell), 0.5 * (t - z))

  @test isapprox(LorentzVectorBase.plus_component(mom_zero), 0.0)
  @test isapprox(LorentzVectorBase.minus_component(mom_zero), 0.0)
end
