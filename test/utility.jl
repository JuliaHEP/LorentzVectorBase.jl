using LorentzVectorBase

av_accessors = available_accessors()

groundtruth = (
  LorentzVectorBase.FOURMOMENTUM_GETTER_FUNCTIONS...,
  keys(LorentzVectorBase.FOURMOMENTUM_GETTER_ALIASSES)...,
)

@testset "available accessors" begin
  @test length(av_accessors) == length(groundtruth)

  @testset "acc: $acc" for acc in groundtruth
    @test any(x -> acc == x, av_accessors)
  end
end
