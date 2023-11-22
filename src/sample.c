#include <ecs/world.h>
#include <ecs/systems.h>

#include <render/model.h>
#include <render/skybox.h>

#include <math/vector.h>
#include <math/float.h>

#include <systems.h>
#include <components.h>

#include <stddef.h>

void worldSetup(struct world *world) {
    CREATE_COMPONENT(world, struct transformComponent);
    CREATE_COMPONENT(world, struct cameraComponent);
    CREATE_COMPONENT(world, struct firstPersonComponent);
    CREATE_COMPONENT(world, struct controllerDataComponent);
    CREATE_COMPONENT(world, struct modelComponent);
    CREATE_COMPONENT(world, struct dirLightComponent);
    CREATE_COMPONENT(world, struct spotLightComponent);
    CREATE_COMPONENT(world, struct pointLightComponent);
    CREATE_COMPONENT(world, struct skyboxComponent);
    CREATE_COMPONENT(world, struct rendererDataComponent);

    ADD_EVENT_SYSTEM(world, SYSTEM_ON_COMPONENT_ADD, setupTransform, GET_COMPONENT_ID(struct transformComponent));
    ADD_EVENT_SYSTEM(world, SYSTEM_ON_COMPONENT_ADD, setupCamera, GET_COMPONENT_ID(struct cameraComponent));

    ADD_FILTER(world, "controllerDataFilter", GET_COMPONENT_ID(struct controllerDataComponent));
    ADD_FILTER(world, "firstPersonFilter", GET_COMPONENT_ID(struct transformComponent), GET_COMPONENT_ID(struct firstPersonComponent));
    ADD_FILTER(world, "cameraTransformFilter", GET_COMPONENT_ID(struct transformComponent), GET_COMPONENT_ID(struct cameraComponent));
    ADD_FILTER(world, "cameraFilter", GET_COMPONENT_ID(struct cameraComponent));
    ADD_FILTER(world, "transformFilter", GET_COMPONENT_ID(struct transformComponent));
    ADD_FILTER(world, "rendererDataFilter", GET_COMPONENT_ID(struct rendererDataComponent));
    ADD_FILTER(world, "modelFilter", GET_COMPONENT_ID(struct transformComponent), GET_COMPONENT_ID(struct modelComponent));
    ADD_FILTER(world, "skyboxFilter", GET_COMPONENT_ID(struct skyboxComponent));
    ADD_FILTER(world, "renderCameraFilter", GET_COMPONENT_ID(struct transformComponent), GET_COMPONENT_ID(struct cameraComponent), GET_COMPONENT_ID(struct rendererDataComponent));
    ADD_FILTER(world, "dirLightFilter", GET_COMPONENT_ID(struct transformComponent), GET_COMPONENT_ID(struct dirLightComponent));
    ADD_FILTER(world, "spotLightFilter", GET_COMPONENT_ID(struct transformComponent), GET_COMPONENT_ID(struct spotLightComponent));
    ADD_FILTER(world, "pointLightFilter", GET_COMPONENT_ID(struct transformComponent), GET_COMPONENT_ID(struct pointLightComponent));

    ADD_PHASE_SYSTEM(world, SYSTEM_ON_PRE_UPDATE, updateControllerData, "controllerDataFilter");
    ADD_PHASE_SYSTEM(world, SYSTEM_ON_UPDATE, updateFirstPersonTransform, "firstPersonFilter");
    ADD_PHASE_SYSTEM(world, SYSTEM_ON_UPDATE, updateCameraView, "cameraTransformFilter");
    ADD_PHASE_SYSTEM(world, SYSTEM_ON_POST_UPDATE, updateTransformMatrix, "transformFilter");

    ADD_PHASE_SYSTEM(world, SYSTEM_ON_RENDER_SORT, rendererGetModels, "modelFilter", "rendererDataFilter");
    ADD_PHASE_SYSTEM(world, SYSTEM_ON_RENDER_SETUP, rendererGetCameras, "renderCameraFilter");
    ADD_PHASE_SYSTEM(world, SYSTEM_ON_RENDER_SETUP, rendererGetSkybox, "skyboxFilter", "rendererDataFilter");
    ADD_PHASE_SYSTEM(world, SYSTEM_ON_RENDER_SETUP, rendererGetDirLights, "dirLightFilter", "rendererDataFilter");
    ADD_PHASE_SYSTEM(world, SYSTEM_ON_RENDER_SETUP, rendererGetSpotLights, "spotLightFilter", "rendererDataFilter");
    ADD_PHASE_SYSTEM(world, SYSTEM_ON_RENDER_SETUP, rendererGetPointLights, "pointLightFilter", "rendererDataFilter");

    ADD_PHASE_SYSTEM(world, SYSTEM_ON_RENDER_OPAQUE, rendererOpaqueRender, "rendererDataFilter");
    ADD_PHASE_SYSTEM(world, SYSTEM_ON_RENDER_SKYBOX, renderSkybox, "skyboxFilter", "cameraFilter");
    ADD_PHASE_SYSTEM(world, SYSTEM_ON_RENDER_TRANSPARENT, rendererTransparentRender, "rendererDataFilter");

    ADD_PHASE_SYSTEM(world, SYSTEM_ON_RENDER_FINISH, finishRender, "cameraFilter");

    ADD_SINGLETON_COMPONENT(world, struct controllerDataComponent);

    entityId camera = createEntity(world, "Camera");
    ADD_COMPONENT(world, camera, struct transformComponent);
    ADD_COMPONENT(world, camera, struct cameraComponent);
    ADD_COMPONENT(world, camera, struct firstPersonComponent);
    ADD_COMPONENT(world, camera, struct rendererDataComponent);
    struct cameraComponent *cameraComponent = GET_COMPONENT(world, camera, struct cameraComponent);
    cameraComponent->fov = 60.0f;
    cameraComponent->near = 0.1f;
    cameraComponent->far = 100.0f;
    struct firstPersonComponent *firstPerson = GET_COMPONENT(world, camera, struct firstPersonComponent);
    firstPerson->rotation = (struct vec2) { 0, 0 };
    firstPerson->rotationSpeed = 1.3f;
    firstPerson->moveSpeed = 2.0f;

    struct transformComponent *transform;
#if 1
    entityId chest1 = loadModel(world, "assets/chest.obj", "assets/chest.qoi", "assets/chest_normal.qoi", "assets/chest_specular.qoi", "assets/chest_reflectance.qoi", false);
    transform = GET_COMPONENT(world, chest1, struct transformComponent);
    transform->position = (struct vec3) { 0, -1, -1 };
#endif
#if 1
    entityId chest2 = loadModel(world, "assets/chest.obj", "assets/chest.qoi", "assets/chest_normal.qoi", "assets/chest_specular.qoi", "assets/chest_reflectance.qoi", false);
    transform = GET_COMPONENT(world, chest2, struct transformComponent);
    transform->position = (struct vec3) { 0, -1, -1 };
    transform->scale = (struct vec3) { 0.5f, 0.5f, 0.5f };
    transform->parent = chest1;
#endif
#if 1
    entityId chest3 = loadModel(world, "assets/chest.obj", "assets/chest.qoi", "assets/chest_normal.qoi", "assets/chest_specular.qoi", "assets/chest_reflectance.qoi", false);
    transform = GET_COMPONENT(world, chest3, struct transformComponent);
    transform->position = (struct vec3) { 0, -1, -1 };
    transform->scale = (struct vec3) { 0.5f, 0.5f, 0.5f };
    transform->parent = chest2;
#endif

    entityId plane = loadModel(world, "assets/plane.fbx", NULL, NULL, NULL, NULL, false);
    transform = GET_COMPONENT(world, plane, struct transformComponent);
    transform->position = (struct vec3) { 0, -3.2f, 0 };
    transform->rotation = eulerToQuat((struct vec3) { M_PI, 0, 0 });
    transform->scale = (struct vec3) { 0.1f, 0.1f, 0.1f };

    entityId skybox = createEntity(world, "Skybox");
    ADD_COMPONENT(world, skybox, struct skyboxComponent);
    const char *skyboxPaths[] = { "assets/skybox/clouds1_east.qoi", "assets/skybox/clouds1_west.qoi", "assets/skybox/clouds1_up.qoi", "assets/skybox/clouds1_down.qoi", "assets/skybox/clouds1_north.qoi", "assets/skybox/clouds1_south.qoi" };
    loadSkybox(skyboxPaths, GET_COMPONENT(world, skybox, struct skyboxComponent));

    entityId grass = loadModel(world, "assets/grass.fbx", "assets/grass.qoi", NULL, NULL, NULL, true);
    transform = GET_COMPONENT(world, grass, struct transformComponent);
    transform->position = (struct vec3) { 0, 0, 2 };

    entityId light = createEntity(world, "Light");
    ADD_COMPONENT(world, light, struct transformComponent);
    ADD_COMPONENT(world, light, struct dirLightComponent);
    struct dirLightComponent *dirLight = GET_COMPONENT(world, light, struct dirLightComponent);
    dirLight->ambientColor = (struct vec3) { 1, 1, 1 };
    dirLight->diffuseColor = (struct vec3) { 1, 1, 1 };
    dirLight->specularColor = (struct vec3) { 1, 1, 1 };

}
