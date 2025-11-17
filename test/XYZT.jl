
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
LorentzVectorBase.x(lv::CustomLVector) = lv.x
LorentzVectorBase.y(lv::CustomLVector) = lv.y
LorentzVectorBase.z(lv::CustomLVector) = lv.z
LorentzVectorBase.t(lv::CustomLVector) = lv.t

x, y, z = rand(RNG, 3)
t = sqrt(1 + x^2 + y^2 + z^2) # ensure a positive p*p
lvec_non_zero = CustomLVector(x, y, z, t)
lvec_zero = CustomLVector(0.0, 0.0, 0.0, 0.0)

@testset "coordiante names" begin
  coordinate_names(LorentzVectorBase.XYZT()) == (:x, :y, :z, :E)
end

@testset "spatial_magnitude consistence" for lvec in [lvec_non_zero, lvec_zero]
  @test isapprox(
    LorentzVectorBase.spatial_magnitude(lvec),
    sqrt(LorentzVectorBase.spatial_magnitude2(lvec)),
  )
end

@testset "spatial_magnitude values" begin
  @test isapprox(LorentzVectorBase.spatial_magnitude2(lvec_non_zero), x^2 + y^2 + z^2)
  @test isapprox(LorentzVectorBase.spatial_magnitude(lvec_non_zero), sqrt(x^2 + y^2 + z^2))
end

@testset "mass consistence" for lvec in [lvec_non_zero, lvec_zero]
  @test isapprox(LorentzVectorBase.mass(lvec), sqrt(LorentzVectorBase.mass2(lvec)))
  @test LorentzVectorBase.invariant_mass2(lvec) == LorentzVectorBase.mass2(lvec)
  @test LorentzVectorBase.invariant_mass(lvec) == LorentzVectorBase.mass(lvec)
  @test isapprox(
    LorentzVectorBase.invariant_mass(lvec), sqrt(LorentzVectorBase.invariant_mass2(lvec))
  )
end

@testset "mass value" begin
  @test isapprox(LorentzVectorBase.mass2(lvec_non_zero), t^2 - (x^2 + y^2 + z^2))
  @test isapprox(LorentzVectorBase.mass(lvec_non_zero), sqrt(t^2 - (x^2 + y^2 + z^2)))

  @test isapprox(LorentzVectorBase.mass(lvec_zero), 0.0)
end

@testset "cartesian components" begin
  @test LorentzVectorBase.t(lvec_non_zero) == t
  @test LorentzVectorBase.E(lvec_non_zero) == t

  @test LorentzVectorBase.x(lvec_non_zero) == x
  @test LorentzVectorBase.px(lvec_non_zero) == x

  @test LorentzVectorBase.y(lvec_non_zero) == y
  @test LorentzVectorBase.py(lvec_non_zero) == y

  @test LorentzVectorBase.z(lvec_non_zero) == z
  @test LorentzVectorBase.pz(lvec_non_zero) == z

  @test LorentzVectorBase.t(lvec_zero) == 0.0
  @test LorentzVectorBase.E(lvec_zero) == 0.0
  @test LorentzVectorBase.x(lvec_zero) == 0.0
  @test LorentzVectorBase.px(lvec_zero) == 0.0
  @test LorentzVectorBase.y(lvec_zero) == 0.0
  @test LorentzVectorBase.py(lvec_zero) == 0.0
  @test LorentzVectorBase.z(lvec_zero) == 0.0
  @test LorentzVectorBase.pz(lvec_zero) == 0.0
end

@testset "boost coordinates" begin
  @test isapprox(LorentzVectorBase.boost_beta(lvec_non_zero), sqrt(x^2 + y^2 + z^2) / t)
  @test isapprox(
    LorentzVectorBase.boost_gamma(lvec_non_zero),
    1 / sqrt(1.0 - LorentzVectorBase.boost_beta(lvec_non_zero)^2),
  )
  @test isapprox(LorentzVectorBase.boost_beta(lvec_zero), 0.0)
  @test isapprox(LorentzVectorBase.boost_gamma(lvec_zero), 1.0)

  @test_throws ArgumentError LorentzVectorBase.boost_beta(CustomLVector(1, 1, 1, 0))
end

@testset "transverse coordiantes value" begin
  @test isapprox(LorentzVectorBase.pt2(lvec_non_zero), x^2 + y^2)
  @test isapprox(LorentzVectorBase.pt(lvec_non_zero), sqrt(x^2 + y^2))
  @test isapprox(LorentzVectorBase.mt2(lvec_non_zero), t^2 - z^2)
  @test isapprox(LorentzVectorBase.mt(lvec_non_zero), sqrt(t^2 - z^2))

  @test isapprox(LorentzVectorBase.rapidity(lvec_non_zero), 0.5 * log((t + z) / (t - z)))

  @test isapprox(LorentzVectorBase.pt2(lvec_zero), 0.0)
  @test isapprox(LorentzVectorBase.pt(lvec_zero), 0.0)
  @test isapprox(LorentzVectorBase.mt2(lvec_zero), 0.0)
  @test isapprox(LorentzVectorBase.mt(lvec_zero), 0.0)
end

@testset "pseudo rapidity" begin
  cth = z / sqrt(x^2 + y^2 + z^2)
  @test isapprox(LorentzVectorBase.eta(lvec_non_zero), 0.5 * log((1 + cth) / (1 - cth)))

  @test isapprox(LorentzVectorBase.eta(lvec_zero), 0.0)
  @test isapprox(LorentzVectorBase.eta(CustomLVector(0.0, 0.0, 1.0, 0.0)), 10e10)
  @test isapprox(LorentzVectorBase.eta(CustomLVector(0.0, 0.0, -1.0, 0.0)), -10e10)
end

@testset "spherical coordiantes consistence" for lvec in [lvec_non_zero, lvec_zero]
  @test isapprox(
    LorentzVectorBase.cos_theta(lvec), cos(LorentzVectorBase.polar_angle(lvec))
  )
  @test isapprox(LorentzVectorBase.cos_phi(lvec), cos(LorentzVectorBase.phi(lvec)))
  @test isapprox(LorentzVectorBase.sin_phi(lvec), sin(LorentzVectorBase.phi(lvec)))
end

@testset "spherical coordiantes values" begin
  @test isapprox(
    LorentzVectorBase.polar_angle(lvec_non_zero),
    atan(LorentzVectorBase.pt(lvec_non_zero), z),
  )
  @test isapprox(LorentzVectorBase.polar_angle(lvec_zero), 0.0)

  @test isapprox(LorentzVectorBase.phi(lvec_non_zero), atan(y, x))
  @test isapprox(LorentzVectorBase.phi(lvec_zero), 0.0)
end

@testset "light-cone coordiantes" begin
  @test isapprox(LorentzVectorBase.plus_component(lvec_non_zero), 0.5 * (t + z))
  @test isapprox(LorentzVectorBase.minus_component(lvec_non_zero), 0.5 * (t - z))

  @test isapprox(LorentzVectorBase.plus_component(lvec_zero), 0.0)
  @test isapprox(LorentzVectorBase.minus_component(lvec_zero), 0.0)
end
