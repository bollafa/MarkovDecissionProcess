
#=

=#

using DataStructures
function value_iteration(S,A,P,R,Θ)
γ = 0
V₀ = DefaultDict{Int,Int}(0)
Vk = [V₀]
V₁ = DefaultDict(0)
# update value
for s in S
    Vp = []
    for a in A
        #@show S
        println(broadcast(s′ -> R(s,a,s′),S))
        println(broadcast(s′ -> P(s′,s,a),S))
        push!(Vp,sum(broadcast(s′ -> P(s′,s,a)*R(s,a,s′),S)))
    end
    @show Vp
    V₁[s] = maximum(Vp)
end
V₁
end
ActionToVec = Dict(1 => (0,1),2 => (1,0), 3 => (0,-1), 4 => (-1,0))
function P(s′,s,a)

    Action = [0.1, 0.1, 0.1, 0.1]
    Action[a] = 0.7
    Vec = map(t -> ActionToVec[t],[1,2,3,4])
    Near = map(x -> s.+x,Vec)
    !any([s′] .== Near) && return 0

    Action[findin(Near,[s′])][1]

end
function R(s,a,s′)
    s == (0,0) && return 2
    s == (1,1) && return -2
    0
end
