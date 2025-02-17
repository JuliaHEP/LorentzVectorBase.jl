"""
    available_accessors()

Returns a list of available accessor functions for four-momentum components.

This function gathers all defined accessor methods (such as px, py, pz, E, etc.) that are available
for **any** custom four-momentum type implementing the LorentzVectorBase interface.

### Example

```julia
julia> LorentzVectorBase.available_accessors()
38-element Vector{Symbol}:
 :x
 :y
 :z
 :t
 :energy
 :px
 :py
 ...
```

This allows users to query which accessor functions are available for any custom four-momentum type.
"""
function available_accessors()
  res = Symbol[]
  for acc in FOURMOMENTUM_GETTER_FUNCTIONS
    push!(res, acc)
    for (key, val) in FOURMOMENTUM_GETTER_ALIASSES
      if val == acc
        push!(res, key)
        continue
      end
    end
  end
  return res
end
