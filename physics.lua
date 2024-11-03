function beginContact(a, b, coll)
    -- print names of the two fixtures that collided
    local nameA = a:getUserData()
    local nameB = b:getUserData()

    print("Begin contact: ")
    print(nameA, nameB)

    -- if the player collides with the ground, end the game
    if nameA == "Player" and nameB == "Pipe" then
        isPlayerAlive = false
    elseif nameA == "Pipe" and nameB == "Player" then
        isPlayerAlive = false
    end
end

function endContact(a, b, coll)

end

function preSolve(a, b, coll)

end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)

end
