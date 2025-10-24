using LorentzVectorBase

struct TestCoordinteSystem <: LorentzVectorBase.AbstractCoordinateSystem end
LorentzVectorBase.coordinate_names(::TestCoordinteSystem) = (:a, :b, :c, :d)

for (fun_idx, fun) in enumerate(LorentzVectorBase.FOURMOMENTUM_GETTER_FUNCTIONS)
  eval(quote
    ($LorentzVectorBase.$fun)(::$TestCoordinteSystem, mom) = $fun_idx
  end)
end

struct TestMomentum end

LorentzVectorBase.coordinate_system(::TestMomentum) = TestCoordinteSystem()

@testset "Accessor functions" begin
  mom = TestMomentum()
  @testset "$fun" for (i, fun) in enumerate(LorentzVectorBase.FOURMOMENTUM_GETTER_FUNCTIONS)
    @test eval(quote
      $LorentzVectorBase.$fun
    end)(mom) == i
  end
end

@testset "Aliasses" begin
  mom = TestMomentum()
  @testset "$alias, $fun" for (alias, fun) in LorentzVectorBase.FOURMOMENTUM_GETTER_ALIASSES
    alias_result = eval(quote
      $LorentzVectorBase.$alias
    end)(mom)
    groundtruth = eval(quote
      $LorentzVectorBase.$fun
    end)(mom)
    @test alias_result == groundtruth
  end
end
