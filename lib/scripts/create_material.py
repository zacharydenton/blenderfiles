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
filename = os.path.join(os.path.abspath(os.path.dirname(filepath)), "{0}-{1}.blend".format(os.path.basename(filepath).replace('.blend', ''), material.name))
print("saving {0} to {1}".format(plane.active_material, filename))
bpy.ops.wm.save_as_mainfile("EXEC_DEFAULT", filepath=filename, check_existing=False)
