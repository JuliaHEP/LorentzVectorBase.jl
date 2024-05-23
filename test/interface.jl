using FourMomentumBase

struct TestCoordinteSystem <: FourMomentumBase.AbstractCoordinateSystem end
FourMomentumBase.coordinate_names(::TestCoordinteSystem) = (:a, :b, :c, :d)

for (fun_idx, fun) in enumerate(FourMomentumBase.FOURMOMENTUM_GETTER_FUNCTIONS)
    eval(
        quote
            ($FourMomentumBase.$fun)(::$TestCoordinteSystem, mom) = $fun_idx
        end,
    )
end

struct TestMomentum end

FourMomentumBase.coordinate_system(::TestMomentum) = TestCoordinteSystem()

@testset "Accessor functions" begin
    mom = TestMomentum()
    @testset "$fun" for (i, fun) in
                        enumerate(FourMomentumBase.FOURMOMENTUM_GETTER_FUNCTIONS)
        @test eval(
            quote
                $FourMomentumBase.$fun
            end,
        )(mom) == i
    end
end

@testset "Aliasses" begin
    mom = TestMomentum()
    @testset "$alias, $fun" for (alias, fun) in
                                FourMomentumBase.FOURMOMENTUM_GETTER_ALIASSES
        alias_result = eval(
            quote
                $FourMomentumBase.$alias
            end,
        )(mom)
        groundtruth = eval(
            quote
                $FourMomentumBase.$fun
            end,
        )(mom)
        @test alias_result == groundtruth
    end
end
