#!BPY
import os
import sys
import bpy

DIR=os.path.dirname(os.path.realpath(__file__))

# get the arguments
args = sys.argv[sys.argv.index('--'):]
filepath = args[1]
mat_id = int(args[2])

# get the object
plane = bpy.data.objects["Plane"]

# get the material
with bpy.data.libraries.load(filepath) as (data_from, data_to):
    data_to.materials = [data_from.materials[mat_id]]

material = data_to.materials[0]
plane.active_material = material

# save the material
blend_dir = os.path.realpath(os.path.dirname(filepath))
blend_base = os.path.basename(filepath)
filename = os.path.join(blend_dir, "{0}-{1}.blend".format(blend_base, material.name))
print("saving {0} to {1}".format(plane.active_material, filename))
bpy.ops.wm.save_as_mainfile("EXEC_DEFAULT", filepath=filename, check_existing=False)
