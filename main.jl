include("funcs.jl")
include("genetic.jl")
include("game.jl")
using .Tool
using .Game
using .GA

function train(step::Int64)::Array{Float32, 1}
    self::GA.DNA = GA.initialGenerat(0.1)
    for i in 1:step
        println("trainnig step : ", i)
        parent::Array{Array{Float32, 1}, 1} = GA.choice(self)
        genom::Array{Float32, 1} = GA.crossover(self, parent)
        self.genom = GA.mutation(self, genom)
    end
    parent = GA.choice(self)
    return parent[1]
end


function play(genom::Array{Float32, 1})
    turn::Int8 = 0
    size::Int8 = 8
    actions::Array{Int8, 1} = []
    split::Float32 = abs(60 * genom[21])
    DNA::Array{Array{Float32, 2}} = [Tool.deploy(genom[1:10]), Tool.deploy(genom[11:20])]
    self = Game.init(size)

    while true
        Game.show(self)
        if Game.isDone(self) break end

        actions = Game.getLegalAction(self)
        if length(actions) == 0
            self.player = 0 - self.player
        else
            if self.player == 1
                x = Base.prompt("x")
                x = parse(Int8, x)

                y = Base.prompt("y")
                y = parse(Int8, y)
                act::Int8 = (y-1) + (x-1) * self.size
                println(act)
                Game.action(self, act)
            else
                state::Array{Int8, 2} = copy(self.state)
                points::Array{Float32, 1} = []
                for action::Int8 in actions
                    Game.action(self, action)
                    if split < turn
                        append!(points, Tool.getPoint(self.state, DNA[1], self.player))
                    else
                        append!(points, Tool.getPoint(self.state, DNA[2], self.player))
                    end
                end
                self.state = copy(state)
                Game.action(self, actions[argmax(points)])
            end
            self.player = 0 - self.player
            turn += 1
        end
    end
end


genom = train(10)
play(genom)
