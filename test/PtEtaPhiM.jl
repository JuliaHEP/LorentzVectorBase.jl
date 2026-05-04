using Random
using LorentzVectorBase

const RNG = MersenneTwister(137137)

struct CustomCylMom
  pt
  eta
  phi
  m
end

LorentzVectorBase.coordinate_system(::CustomCylMom) = LorentzVectorBase.PtEtaPhiM()
LorentzVectorBase.pt(mom::CustomCylMom) = mom.pt
LorentzVectorBase.eta(mom::CustomCylMom) = mom.eta
LorentzVectorBase.phi(mom::CustomCylMom) = mom.phi
LorentzVectorBase.mass(mom::CustomCylMom) = mom.m

x, y, z = rand(RNG, 3)
m = abs(rand(RNG))
pt = sqrt(x^2 + y^2)
η = atanh(z / sqrt(x^2 + y^2 + z^2))
ϕ = (x == 0.0 && y == 0.0) ? 0.0 : atan(y, x)

mom_onshell = CustomCylMom(pt, η, ϕ, m)
mom_zero = CustomCylMom(0.0, 0.0, 0.0, 0.0)

@testset "spatial_magnitude consistency" begin
  for mom in [mom_onshell, mom_zero]
    @test isapprox(
      LorentzVectorBase.spatial_magnitude(mom),
      sqrt(LorentzVectorBase.spatial_magnitude2(mom)),
    )
  end
end

@testset "spatial_magnitude values" begin
  @test isapprox(LorentzVectorBase.spatial_magnitude2(mom_onshell), x^2 + y^2 + z^2)
  @test isapprox(LorentzVectorBase.spatial_magnitude(mom_onshell), sqrt(x^2 + y^2 + z^2))
end

@testset "mass2 consistency" begin
  for mom in [mom_onshell, mom_zero]
    @test isapprox(LorentzVectorBase.mass(mom), sqrt(LorentzVectorBase.mass2(mom)))
    @test LorentzVectorBase.invariant_mass2(mom) == LorentzVectorBase.mass2(mom)
    @test LorentzVectorBase.invariant_mass(mom) == LorentzVectorBase.mass(mom)
    @test isapprox(
      LorentzVectorBase.invariant_mass(mom), sqrt(LorentzVectorBase.invariant_mass2(mom))
    )
  end
end

@testset "mass value" begin
  @test LorentzVectorBase.mass2(mom_onshell) == m^2
  @test LorentzVectorBase.mass(mom_onshell) == m
  @test LorentzVectorBase.mass(mom_zero) == 0.0
end

@testset "energy" begin
  for mom in [mom_onshell, mom_zero]
    @test isapprox(
      LorentzVectorBase.energy(mom)^2,
      LorentzVectorBase.spatial_magnitude2(mom) + LorentzVectorBase.invariant_mass2(mom),
    )
  end
end

@testset "momentum components" begin
  @test LorentzVectorBase.pt(mom_onshell) == pt
  @test LorentzVectorBase.eta(mom_onshell) == η
  @test LorentzVectorBase.phi(mom_onshell) == ϕ
  @test LorentzVectorBase.mass(mom_onshell) == m
  @test isapprox(
    LorentzVectorBase.boost_beta(mom_onshell),
    LorentzVectorBase.spatial_magnitude(mom_onshell) /
    LorentzVectorBase.energy(mom_onshell),
  )

  @test LorentzVectorBase.pt(mom_zero) == 0.0
  @test LorentzVectorBase.eta(mom_zero) == 0.0
  @test LorentzVectorBase.phi(mom_zero) == 0.0
  @test LorentzVectorBase.mass(mom_zero) == 0.0
  @test LorentzVectorBase.boost_beta(mom_zero) == 0.0
end

@testset "transverse coordinates values" begin
  @test isapprox(LorentzVectorBase.pt2(mom_onshell), pt^2)
  @test isapprox(
    LorentzVectorBase.mt2(mom_onshell), LorentzVectorBase.energy(mom_onshell)^2 - z^2
  )
  @test isapprox(
    LorentzVectorBase.mt(mom_onshell), sqrt(LorentzVectorBase.mt2(mom_onshell))
  )
  @test isapprox(
    LorentzVectorBase.rapidity(mom_onshell),
    0.5 * log(
      (LorentzVectorBase.energy(mom_onshell) + z) /
      (LorentzVectorBase.energy(mom_onshell) - z),
    ),
  )

  @test isapprox(LorentzVectorBase.pt2(mom_zero), 0.0)
  @test isapprox(LorentzVectorBase.mt2(mom_zero), 0.0)
  @test isapprox(LorentzVectorBase.mt(mom_zero), 0.0)
end

@testset "cartesian coordinate values" begin
  @test isapprox(LorentzVectorBase.px(mom_onshell), x)
  @test isapprox(LorentzVectorBase.py(mom_onshell), y)
  @test isapprox(LorentzVectorBase.pz(mom_onshell), z)

  @test isapprox(LorentzVectorBase.px(mom_zero), 0.0)
  @test isapprox(LorentzVectorBase.py(mom_zero), 0.0)
  @test isapprox(LorentzVectorBase.pz(mom_zero), 0.0)

  @test isapprox(LorentzVectorBase.x(mom_onshell), x)
  @test isapprox(LorentzVectorBase.y(mom_onshell), y)
  @test isapprox(LorentzVectorBase.z(mom_onshell), z)

  @test isapprox(LorentzVectorBase.x(mom_zero), 0.0)
  @test isapprox(LorentzVectorBase.y(mom_zero), 0.0)
  @test isapprox(LorentzVectorBase.z(mom_zero), 0.0)
end

@testset "spherical coordinate values" begin
  if pt != 0 && z != 0
    @test isapprox(LorentzVectorBase.polar_angle(mom_onshell), atan(pt, z))
  else
    @test isapprox(LorentzVectorBase.polar_angle(mom_onshell), 0)
  end

  r = LorentzVectorBase.spatial_magnitude(mom_onshell)
  @test isapprox(LorentzVectorBase.cos_theta(mom_onshell), iszero(r) ? 1.0 : z / r)
  @test isapprox(LorentzVectorBase.cos_phi(mom_onshell), cos(ϕ))
  @test isapprox(LorentzVectorBase.sin_phi(mom_onshell), sin(ϕ))

  @test isapprox(LorentzVectorBase.polar_angle(mom_zero), 0.0)
  @test isapprox(LorentzVectorBase.cos_theta(mom_zero), 1.0)
  @test isapprox(LorentzVectorBase.cos_phi(mom_zero), 1.0)
  @test isapprox(LorentzVectorBase.sin_phi(mom_zero), 0.0)
end
