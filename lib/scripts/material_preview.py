#!BPY
import os
import sys
import bpy

DIR=os.path.dirname(os.path.realpath(__file__))

# get the material
filepath = os.path.abspath(sys.argv[-1])
with bpy.data.libraries.load(filepath) as (data_from, data_to):
    for attr in dir(data_to):
        setattr(data_to, attr, getattr(data_from, attr))

material = data_to.materials[0]

# apply the material to the objects
for obj in bpy.data.objects:
    if obj.active_material is None:
        obj.active_material = material

# render each layer
bpy.context.scene.render.use_compositing = True
bpy.context.scene.render.use_radiosity = True
bpy.context.scene.render.use_raytrace = True
bpy.context.scene.render.use_shadows = True
bpy.context.scene.render.use_sss = True
bpy.context.scene.render.use_textures = True
for active in range(4):
    print("rendering layer {0} of {1}".format(active, material.name))
    bpy.context.scene.layers[active] = True
    bpy.context.scene.layers[active-1] = False
    bpy.context.scene.render.filepath = "{0}-{1}".format(filepath.replace('.blend', ''), active)
    bpy.ops.render.render(write_still=True)
