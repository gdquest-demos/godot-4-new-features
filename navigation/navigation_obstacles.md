# General Info

Navigation API has been reworked for Godot 4.1, but the docs aren't synced yet.

## PRs

- [Update NavigationObstacle API](https://github.com/godotengine/godot/pull/78081)

## Gotchas

The docs make it seem like `NavigationAgent3D.velocity_computed` signal is emitted only after `NavigationAgent3D.velocity` is set to a new value, but this is incorrect [see doc ref.](https://docs.godotengine.org/en/latest/tutorials/navigation/navigation_using_navigationagents.html#navigationagent-avoidance).

`velocity_computed` signal is emitted every frame because the navigation agent has no concept of "standing still" as explained in [this issue comment](https://github.com/godotengine/godot/issues/78197#issuecomment-1589832860).

Furthermore, the callback registered with `velocity_computed` will be called with the **last computed `safe_velocity`**. In practice this means that it isn't enough to `set_physics_process(false)`.

One workaround is to connect the `velocity_computed` signal when we set a new target and disconnect it when the target is reached. I don't know if there are any corner cases here.

---

Checking the docs from [latest](https://docs.godotengine.org/en/latest/tutorials/navigation/navigation_using_navigationobstacles.html), they differ from stable regarding navigation obstacles.