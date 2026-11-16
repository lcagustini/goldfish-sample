engine.addFilter("controllerDataFilter", { "controllerDataComponent" })
engine.addFilter("firstPersonFilter", { "transformComponent", "firstPersonComponent" })
engine.addFilter("cameraTransformFilter", { "transformComponent", "cameraComponent" })
engine.addFilter("cameraFilter", { "cameraComponent" })
engine.addFilter("transformFilter", { "transformComponent" })
engine.addFilter("rendererDataFilter", { "rendererDataComponent" })
engine.addFilter("modelFilter", { "transformComponent", "modelComponent" })
engine.addFilter("skyboxFilter", { "skyboxComponent" })
engine.addFilter("renderCameraFilter", { "transformComponent", "cameraComponent", "rendererDataComponent" })
engine.addFilter("dirLightFilter", { "transformComponent", "dirLightComponent" })
engine.addFilter("spotLightFilter", { "transformComponent", "spotLightComponent" })
engine.addFilter("pointLightFilter", { "transformComponent", "pointLightComponent" })

engine.addPhaseSystem(engine.phases.preUpdate, "updateControllerData", { "controllerDataFilter" })
engine.addPhaseSystem(engine.phases.update, "updateFirstPerson", { "firstPersonFilter" })
engine.addPhaseSystem(engine.phases.update, "updateCameraView", { "cameraTransformFilter" })
engine.addPhaseSystem(engine.phases.postUpdate, "updateTransformMatrix", { "transformFilter" })

engine.addPhaseSystem(engine.phases.renderSort, "rendererGetModels", { "modelFilter", "rendererDataFilter" })
engine.addPhaseSystem(engine.phases.renderSetup, "rendererGetCameras", { "renderCameraFilter" })
engine.addPhaseSystem(engine.phases.renderSetup, "rendererGetSkybox", { "skyboxFilter", "rendererDataFilter" })
engine.addPhaseSystem(engine.phases.renderSetup, "rendererGetDirLights", { "dirLightFilter", "rendererDataFilter" })
engine.addPhaseSystem(engine.phases.renderSetup, "rendererGetSpotLights", { "spotLightFilter", "rendererDataFilter" })
engine.addPhaseSystem(engine.phases.renderSetup, "rendererGetPointLights", { "pointLightFilter", "rendererDataFilter" })

engine.addPhaseSystem(engine.phases.renderOpaque, "rendererOpaqueRender", { "rendererDataFilter" })
engine.addPhaseSystem(engine.phases.renderSkybox, "renderSkybox", { "skyboxFilter", "cameraFilter" })
engine.addPhaseSystem(engine.phases.renderTransparent, "rendererTransparentRender", { "rendererDataFilter" })
engine.addPhaseSystem(engine.phases.renderFinish, "finishRender", { "cameraFilter" })

engine.addSingleton("controllerDataComponent")

local camera = engine.createEntity("Camera")
engine.addComponent(camera, "transformComponent")
engine.addComponent(camera, "cameraComponent")
engine.addComponent(camera, "firstPersonComponent")
engine.addComponent(camera, "rendererDataComponent")
local cameraData = engine.getComponent(camera, "cameraComponent")
cameraData.fov = 60.0
cameraData.near = 0.1
cameraData.far = 100.0
local firstPerson = engine.getComponent(camera, "firstPersonComponent")
firstPerson.rotation = engine.vec2(0, 0)
firstPerson.rotationSpeed = 1.3
firstPerson.moveSpeed = 2.0

local chest1 = engine.loadModel("assets/chest.obj", "assets/chest.qoi", "assets/chest_normal.qoi", "assets/chest_specular.qoi", "assets/chest_reflectance.qoi", false)
local chest1Transform = engine.getComponent(chest1, "transformComponent")
chest1Transform.position = engine.vec3(0, -1, -1)

local chest2 = engine.loadModel("assets/chest.obj", "assets/chest.qoi", "assets/chest_normal.qoi", "assets/chest_specular.qoi", "assets/chest_reflectance.qoi", false)
local chest2Transform = engine.getComponent(chest2, "transformComponent")
chest2Transform.position = engine.vec3(0, -1, -1)
chest2Transform.scale = engine.vec3(0.5, 0.5, 0.5)
chest2Transform.parent = engine.rawEntity(chest1)

local chest3 = engine.loadModel("assets/chest.obj", "assets/chest.qoi", "assets/chest_normal.qoi", "assets/chest_specular.qoi", "assets/chest_reflectance.qoi", false)
local chest3Transform = engine.getComponent(chest3, "transformComponent")
chest3Transform.position = engine.vec3(0, -1, -1)
chest3Transform.scale = engine.vec3(0.5, 0.5, 0.5)
chest3Transform.parent = engine.rawEntity(chest2)

local plane = engine.loadModel("assets/plane.fbx", nil, nil, nil, nil, false)
local planeTransform = engine.getComponent(plane, "transformComponent")
planeTransform.position = engine.vec3(0, -3.2, 0)
planeTransform.rotation = engine.math.eulerToQuat(engine.vec3(math.pi, 0, 0))
planeTransform.scale = engine.vec3(0.1, 0.1, 0.1)

engine.loadSkybox({ "assets/skybox/clouds1_east.qoi", "assets/skybox/clouds1_west.qoi", "assets/skybox/clouds1_up.qoi", "assets/skybox/clouds1_down.qoi", "assets/skybox/clouds1_north.qoi", "assets/skybox/clouds1_south.qoi" })

local grass = engine.loadModel("assets/grass.fbx", "assets/grass.qoi", nil, nil, nil, true)
local grassTransform = engine.getComponent(grass, "transformComponent")
grassTransform.position = engine.vec3(0, 0, 2)

local light = engine.createEntity("Light")
engine.addComponent(light, "transformComponent")
engine.addComponent(light, "dirLightComponent")
local dirLight = engine.getComponent(light, "dirLightComponent")
dirLight.ambientColor = engine.vec3(1, 1, 1)
dirLight.diffuseColor = engine.vec3(1, 1, 1)
dirLight.specularColor = engine.vec3(1, 1, 1)
