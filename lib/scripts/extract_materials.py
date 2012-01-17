#!BPY
import os
import bpy
import subprocess

DIR=os.path.dirname(os.path.realpath(__file__))

materials = bpy.data.materials
for i, material in enumerate(materials):
    subprocess.call("blender -b {0}/upload.blend -P {0}/create_material.py -- {1} {2}".format(DIR, bpy.data.filepath, i), shell=True)

