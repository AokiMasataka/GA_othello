module GA
include("funcs.jl")
using .Tool

mutable struct DNA
    genom::Array{Float32, 2}
    population::Int32
    mutationRate::Float64
end

function initialGenerat(mutationRate::Float64)::DNA
    popul::Int32 = 10
    dna  = DNA(randn(Float32, 20 + 1, popul)', popul, mutationRate)
    return dna
end

function choice(self::DNA)::Array{Array{Float32, 1}, 1}
    win::Array{Int8, 1} = zeros(Int8, (self.population))
    for X::Int32 in 1:self.population, Y::Int32 in 1:self.population
        if X != Y
            win[X] += Tool.selfPlay(self.genom[X, :], self.genom[Y, :])
        end
    end
    X::Int32 = argmax(win)
    Y::Int32 = 0
    while true
        Y = rand(1:self.population)
        if X != Y break end
    end
    return [self.genom[X, :], self.genom[Y, :]]
end

function crossover(self::DNA, dna::Array{Array{Float32, 1}, 1})::Array{Float32, 1}
    genom::Array{Float32, 1} = []
    append!(genom, dna[1])
    append!(genom, dna[2])
    for i in 1:self.population-2
        cut = rand(2: 21-1)
        append!(genom, dna[1][1: cut])
        append!(genom, dna[2][cut+1: 21])
    end
    return reshape(genom, self.population * 21)
end

function mutation(self::DNA, genom::Array{Float32, 1})::Array{Float32, 2}
    for i in 1:self.population
        if rand() < self.mutationRate
            genom[i] = rand(Float32)
        end
    end
    self.genom = reshape(genom, (21, self.population))'
end

end
