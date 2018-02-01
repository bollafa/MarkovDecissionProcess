
#=

=#

using DataStructures
using IterTools
function value_iteration(S,A,P,R,Θ)
γ = 0.9
V₀ = DefaultDict{Tuple{Int,Int},Int}(0)
Vk::Array{Any} = [V₀]
k = 1
V₁::Dict{Tuple{Int,Int},Float64} = Dict{Tuple{Int,Int},Float64}()
# update value
while true
    k = k + 1
    push!(Vk,Dict{Tuple{Int,Int},Float64}())
    for s in S
        Vp = []
         for a in A
            #=@show s,a
            println(broadcast(s′ -> R(s,a,s′),[S...]))
            println(broadcast(s′ -> P(s′,s,a),[S...]))=#
            #push!(Vp,sum(broadcast(s′ -> P(s′,s,a)*R(s,a,s′),[S...])))
            push!(Vp, sum(broadcast(s′ -> P(s′,s,a)*(R(s,a,s′)+γ*Vk[k-1][s′]),[S...])))
        end
        #@show Vp
        Vk[k][s] = maximum(Vp)

    end
    abs(sum(abs,values(Vk[k])) - sum(abs,values(Vk[k-1]))) < Θ && break;
end
@show k
Vk[k]
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
    s == (0,0) && return 10
    s == (1,1) && return -10
    0
end
