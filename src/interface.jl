
abstract type AbstractCoordinateSystem end

"""
    coordinate_names(::AbstractCoordinateSystem)::Tuple{Symbols}

"""
function coordinate_names end

"""

    coordinate_system(::MomType)::CS where {CS <: AbstractCoordinateSystem}

"""
function coordinate_system end

const FOURMOMENTUM_GETTER_FUNCTIONS = (
    :energy,
    :px,
    :py,
    :pz,
    :magnitude2,
    :magnitude,
    :invariant_mass2,
    :invariant_mass,
    :boost_beta,
    :boost_gamma,
    :transverse_momentum2,
    :transverse_momentum,
    :transverse_mass2,
    :transverse_mass,
    :rapidity,
    :pseudorapidity,
    :polar_angle,
    :cos_theta,
    :azimuthal_angle,
    :cos_phi,
    :sin_phi,
    :plus_component,
    :minus_component,
)

for func in FOURMOMENTUM_GETTER_FUNCTIONS
    eval(
        quote
            ($func)(mom) = ($func)($coordinate_system(mom), mom)
        end,
    )
end

const FOURMOMENTUM_GETTER_ALIASSES = Dict(
    :mag2 => :magnitude2,
    :mag => :magnitude,
    :mass2 => :invariant_mass2,
    :mass => :invariant_mass,
    :pt2 => :transverse_momentum2,
    :perp2 => :transverse_momentum2,
    :pt => :transverse_momentum,
    :perp => :transverse_momentum,
    :mt2 => :transverse_mass2,
    :mt => :transverse_mass,
)

for (alias, func) in FOURMOMENTUM_GETTER_ALIASSES
    eval(
        quote
            ($alias)(mom) = ($func)(mom)
        end,
    )
end
