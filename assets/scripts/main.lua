local scene = engine.newScene()

scene.filters.firstPersonFilter = { "transformComponent", "firstPersonComponent" }
scene.systems[#scene.systems + 1] = { phase = "update", fn = "updateFirstPerson", filters = { "firstPersonFilter" } }

scene.entities = {
    { name = "Camera", components = {
        transformComponent = true,
        cameraComponent = { fov = 60.0, near = 0.1, far = 100.0 },
        firstPersonComponent = { rotation = { 0, 0 }, rotationSpeed = 1.3, moveSpeed = 2.0 },
        rendererDataComponent = true,
    } },
    { name = "chest1", model = "assets/chest.obj",
      diffuse = "assets/chest.qoi", normal = "assets/chest_normal.qoi",
      specular = "assets/chest_specular.qoi", reflectance = "assets/chest_reflectance.qoi",
      components = { transformComponent = { position = { 0, -1, -1 } } } },
    { name = "chest2", model = "assets/chest.obj",
      diffuse = "assets/chest.qoi", normal = "assets/chest_normal.qoi",
      specular = "assets/chest_specular.qoi", reflectance = "assets/chest_reflectance.qoi",
      components = { transformComponent = { position = { 0, -1, -1 }, scale = { 0.5, 0.5, 0.5 }, parent = "chest1" } } },
    { name = "chest3", model = "assets/chest.obj",
      diffuse = "assets/chest.qoi", normal = "assets/chest_normal.qoi",
      specular = "assets/chest_specular.qoi", reflectance = "assets/chest_reflectance.qoi",
      components = { transformComponent = { position = { 0, -1, -1 }, scale = { 0.5, 0.5, 0.5 }, parent = "chest2" } } },
    { name = "plane", model = "assets/plane.fbx",
      components = { transformComponent = { position = { 0, -3.2, 0 }, rotationEuler = { math.pi, 0, 0 }, scale = { 0.1, 0.1, 0.1 } } } },
    { name = "grass", model = "assets/grass.fbx", diffuse = "assets/grass.qoi", transparent = true,
      components = { transformComponent = { position = { 0, 0, 2 } } } },
    { name = "Light", components = {
        transformComponent = true,
        dirLightComponent = { ambientColor = { 1, 1, 1 }, diffuseColor = { 1, 1, 1 }, specularColor = { 1, 1, 1 } },
    } },
}

scene.skybox = {
    "assets/skybox/clouds1_east.qoi", "assets/skybox/clouds1_west.qoi",
    "assets/skybox/clouds1_up.qoi", "assets/skybox/clouds1_down.qoi",
    "assets/skybox/clouds1_north.qoi", "assets/skybox/clouds1_south.qoi",
}

return scene
