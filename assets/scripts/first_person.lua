local M_PI_2 = math.pi / 2

local function clamp(value, low, high)
    if value < low then return low end
    if value > high then return high end
    return value
end

local mathLib = engine.math

function updateFirstPerson(run)
    local dt = run.dt
    local controllerData = engine.getSingleton("controllerDataComponent")

    local transforms = engine.view(run, 0, "transformComponent")
    local rotations = engine.view(run, 0, "firstPersonComponent")

    for row = 0, transforms.rows - 1 do
        local transform = transforms[row]
        local rotation = rotations[row]

        local leftAnalog = { x = (controllerData.lx - 128) / 128.0, y = (controllerData.ly - 128) / 128.0 }
        local rightAnalog = { x = (controllerData.rx - 128) / 128.0, y = (controllerData.ry - 128) / 128.0 }

        if mathLib.vectorLenSquared2D(engine.vec2(leftAnalog.x, leftAnalog.y)) < 0.1 then
            leftAnalog = { x = 0, y = 0 }
        else
            local scaled = mathLib.vectorScale2D(dt, engine.vec2(leftAnalog.x, leftAnalog.y))
            leftAnalog = { x = scaled.x, y = scaled.y }
        end
        if mathLib.vectorLenSquared2D(engine.vec2(rightAnalog.x, rightAnalog.y)) < 0.1 then
            rightAnalog = { x = 0, y = 0 }
        else
            local scaled = mathLib.vectorScale2D(dt, engine.vec2(rightAnalog.x, rightAnalog.y))
            rightAnalog = { x = scaled.x, y = scaled.y }
        end

        rotation.rotation.x = rotation.rotation.x + rightAnalog.x * rotation.rotationSpeed
        rotation.rotation.y = rotation.rotation.y + rightAnalog.y * rotation.rotationSpeed
        rotation.rotation.y = clamp(rotation.rotation.y, -0.95 * M_PI_2, 0.95 * M_PI_2)

        local xQuat = mathLib.quatFromAxisAngle(engine.vec3(0, -1, 0), rotation.rotation.x)
        local yQuat = mathLib.quatFromAxisAngle(engine.vec3(-1, 0, 0), rotation.rotation.y)
        transform.rotation = mathLib.quatMult(xQuat, yQuat)

        local dir = mathLib.vectorRotate(engine.vec3(0, 0, 1), transform.rotation)
        transform.position = mathLib.vectorAdd(transform.position, mathLib.vectorScale(leftAnalog.y * rotation.moveSpeed, dir))

        local right = mathLib.vectorRotate(engine.vec3(1, 0, 0), transform.rotation)
        transform.position = mathLib.vectorAdd(transform.position, mathLib.vectorScale(leftAnalog.x * rotation.moveSpeed, right))

        local up = engine.vec3(0, 1, 0)
        local rb = controllerData.rb and 1 or 0
        local lb = controllerData.lb and 1 or 0
        transform.position = mathLib.vectorAdd(transform.position, mathLib.vectorScale(rb * dt * rotation.moveSpeed, up))
        transform.position = mathLib.vectorSubtract(transform.position, mathLib.vectorScale(lb * dt * rotation.moveSpeed, up))
    end
end
