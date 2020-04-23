module Game
mutable struct Var
    state::Array{Int8, 2}
    player::Int8
    size::Int8
end

function init(size::Int8)::Var
    self = Var(zeros(Int8, (size, size)), 1, size)
    herf::Int8 = floor(size / 2)
    self.state[herf, herf] = self.state[herf + 1, herf + 1] = -1
    self.state[herf + 1, herf] = self.state[herf, herf + 1] = 1
    return self
end

function isDone(self::Var)::Bool
    if length(getLegalAction(self)) == 0
        self.player = 0 - self.player
        if length(getLegalAction(self)) == 0
            self.player = 0 - self.player
            return true
        end
    end
    return false
end

function action(self::Var, action::Int8)
    player::Int8 = self.player
    x::Int8 = (action % self.size) + 1
    y::Int8 = Int8(floor(action / self.size) + 1)
    self.state[x, y] = player
    for dx in -1:1, dy in -1:1
        if dx == 0 && dy == 0 continue end
        for i in 1:self.size
            posX::Int8, posY::Int8 =  i*dx+x, i*dy+y
            if 1 <= posX <= self.size && 1 <= posY <= self.size
                if self.state[posX, posY] == player
                    if 1 < i
                        for n in 1:i
                            self.state[n*dx+x, n*dy+y] = player
                        end
                    end
                elseif self.state[posX, posY] == 0 - player
                else break
                end
            else
                break
            end
        end
    end
end


function getLegalAction(self::Var)::Array{Int8, 1}
    actions::Array{Int8, 1} = []
    for x::Int8 in 1:self.size, y::Int8 in 1:self.size
        if self.state[x, y] != 0 continue end
        if legalAction(self, x, y)
            append!(actions, (x - 1) + (y - 1) * self.size)
        end
    end
    return actions
end

function legalAction(self::Var, x::Int8, y::Int8)::Bool
    player::Int8 = self.player

    for dx::Int8 in -1:1, dy::Int8 in -1:1
        if dx == 0 && dy == 0 continue end
        for i in 1:self.size
            posX::Int8, posY::Int8 = i*dx+x, i*dy+y
            if 1 <= posX <= self.size && 1 <= posY <= self.size
                if self.state[posX, posY] == player
                    if 1 < i return true end
                    break
                elseif self.state[posX, posY] == 0 - player
                else break
                end
            else
                break
            end
        end
    end
    return false
end

function show(self::Var)
    for i in 1:self.size
        print(i, " ")
    end
    println()
    for i in 1: self.size
        for j in 1: self.size
            if self.state[i, j] == 1
                print("B ")
            elseif self.state[i, j] == -1
                print("W ")
            else
                print("* ")
            end
        end
        println(i)
    end
    println()
end

end
