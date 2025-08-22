# # Implementing the `LorentzVectorBase` Interface
#
# This tutorial demonstrates how to make a custom Julia type compatible with the
# `LorentzVectorBase` interface. Once your type implements the minimal required
# methods, you gain access to a rich suite of automatically derived kinematic
# functions such as `mass`, `pt`, `rapidity`, `phi`, and many others. See [here](@ref
# getter) for a complete list.
#
# ## Step 1: Load the package

using LorentzVectorBase

# ## Step 2: Define your custom Lorentz vector type
#
# Let's define a simple concrete type representing a four-momentum vector
# using Cartesian coordinates: `x`, `y`, `z`, and `t`.

struct MyVector
  x::Float64
  y::Float64
  z::Float64
  t::Float64
end

# ## Step 3: Specify the coordinate system
#
# Next, we tell `LorentzVectorBase` which coordinate system our type uses. Since
# `MyVector` stores its components in Cartesian momentum form, we declare:

LorentzVectorBase.coordinate_system(::MyVector) = LorentzVectorBase.XYZT()

# The tag `XYZT()` indicates a four-momentum representation with components
# `(x, y, z, t)`.
# ## Step 4: Implement the required accessors
#
# Finally, we provide methods to extract the components expected by the `XYZT`
# coordinate system: `x`, `y`, `z`, and `t`.

LorentzVectorBase.x(v::MyVector) = v.x
LorentzVectorBase.y(v::MyVector) = v.y
LorentzVectorBase.z(v::MyVector) = v.z
LorentzVectorBase.t(v::MyVector) = v.t

# With these definitions in place, `MyVector` now fully satisfies the
# `LorentzVectorBase` interface!
#
# ## Step 5: Use the derived functionality
#
# Let's create an instance of our custom type and use some of the functionality
# that `LorentzVectorBase` now provides for free:

using LorentzVectorBase: mass, pt, eta, rapidity, phi

v = MyVector(1.0, 2.0, 3.0, 4.0)

mass(v) # Invariant mass
pt(v) # Transverse momentum
eta(v) # Pseudorapidity
rapidity(v) # Rapidity
phi(v) # Azimuthal angle

# ## Optional: Use aliases for convenience
#
# The package also defines aliases like `energy`, `invariant_mass`, and
# `transverse_momentum`. These are mapped automatically to their canonical
# counterparts:

using LorentzVectorBase: energy, invariant_mass, transverse_momentum

energy(v) # Same as `t(v)` or `E(v)`
invariant_mass(v) # Same as `mass(v)`
transverse_momentum(v) # Same as `pt(v)`
