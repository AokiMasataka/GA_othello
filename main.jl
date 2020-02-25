include("funcs.jl")
include("genetic.jl")
include("game.jl")
using .Tool
using .Game
using .GA

function main()
    self::GA.DNA = GA.initialGenerat(0.1)
    for i in 1:10
        parent::Array{Array{Float32, 1}, 1} = GA.choice(self)
        genom::Array{Float32, 1} = GA.crossover(self, parent)
        self.genom = GA.mutation(self, genom)
    end
end

@time main()
