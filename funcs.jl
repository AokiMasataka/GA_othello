module Tool
include("game.jl")
using .Game

function deploy(dna::Array{Float32, 1})::Array{Float32, 2}
    state::Array{Float32, 2} = zeros(Float32, (8, 8))
    for i in 1:4
        state[i, i] = dna[i]
        if i < 4
            state[i + 1, i] = dna[i + 4]
            state[i, i + 1] = dna[i + 4]
        end
        if i < 3
            state[i + 2, i] = dna[i + 7]
            state[i, i + 2] = dna[i + 7]
        end
        if i < 2
            state[i + 3, i] = dna[i + 9]
            state[i, i + 3] = dna[i + 9]
        end
    end

    for i in 1:4
        for j in 1:4
            state[i ,9 - j] = state[9 - i ,j] = state[i ,j]
            state[9 - i, 9 - j] = state[i, j]
        end
    end
    return state
end

function getPoint(state::Array{Int8, 2}, dna::Array{Float32, 2}, player::Int8)::Float32
    point::Float32 = 0
    for i::Int8 in 1:8, j::Int8 in 1:8
        if state[i, j] == player
            point += dna[i, j]
        elseif state[i, j] == 0 - player
            point -= dna[i, j]
        end
    end
    return point
end

function selfPlay(first::Array{Float32, 1}, behind::Array{Float32, 1})::Int8
    size::Int8 = 8
    self = Game.init(size)
    fi, be = abs(60 * first[21]), abs(60 * behind[21])
    first::Array{Array{Float32, 2}} = [Tool.deploy(first[1:10]), Tool.deploy(first[11:20])]
    behind::Array{Array{Float32, 2}} = [Tool.deploy(behind[1:10]), Tool.deploy(behind[11:20])]
    turn::Int8 = 0


    while true
        if Game.isDone(self) break end

        actions::Array{Int8, 1} = Game.getLegalAction(self)

        if length(actions) > 0
            state::Array{Int8, 2} = copy(self.state)
            points::Array{Float32, 1} = []
            for action::Int8 in actions
                Game.action(self, action)
                if self.player == 1
                    if fi < turn
                        append!(points, Tool.getPoint(self.state, first[1], self.player))
                    else
                        append!(points, Tool.getPoint(self.state, first[2], self.player))
                    end
                else
                    if be < turn
                        append!(points, Tool.getPoint(self.state, behind[1], self.player))
                    else
                        append!(points, Tool.getPoint(self.state, behind[2], self.player))
                    end
                end
                self.state = copy(state)
            end
            Game.action(self, actions[argmax(points)])
            self.player = 0 - self.player
            turn += 1

        else self.player = 0 - self.player end
    end
    if sum(self.state) > 0 return 1
    elseif sum(self.state) < 0 return -1
    else return 0
    end
end

function save(genom::Array{Float32, 2})
end

function load()::Array{Float32, 2}
    genom::Array{Float32, 2}
    return genom
end

end
