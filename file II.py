#Places 4 rectangles and color them green

#This is a WORKING file
#This is a WORKING file
#This is a WORKING file
#This is a WORKING file
#This is a WORKING file
#This is a WORKING file
#This is a WORKING file

import adsk.core, adsk.fusion, adsk.cam, traceback

def run(context):
    try:
        app = adsk.core.Application.get()
        ui = app.userInterface

        design = app.activeProduct
        root_comp = design.rootComponent

        sketches = root_comp.sketches
        xy_plane = root_comp.xYConstructionPlane

        sketch = sketches.add(xy_plane)

        centers = [
            adsk.core.Point3D.create(0,0,0),
            adsk.core.Point3D.create(5,0,0),
            adsk.core.Point3D.create(0,5,0),
            adsk.core.Point3D.create(5,5,0)
        ]

        width = 2
        height =2

        for center in centers:
            sketch.sketchCurves.sketchLines.addCenterPointRectangle(center, adsk.core.Point3D.create(center.x + width/2, center.y + height/2, 0))

        sketch.isVisible = False
        profiles = adsk.core.ObjectCollection.create()

        for profile in sketch.profiles:
            profiles.add(profile)

        extrudes = root_comp.features.extrudeFeatures
        distance = adsk.core.ValueInput.createByReal(40)


        for profile in profiles:
            extrude_input = extrudes.createInput(profile, adsk.fusion.FeatureOperations.NewComponentFeatureOperation)
            extrude_input.setDistanceExtent(False, distance)
            extrude_feature = extrudes.add(extrude_input)

            material_libs = app.materialLibraries
            appearance_lib = material_libs.itemByName("Fusion Appearance Library")

            if not appearance_lib:
                ui.messageBox('Appearance library not found.')
                return

            appearances = appearance_lib.appearances
            green_appearance = appearances.itemByName("Paint - Metal Flake (Green)")

            if not green_appearance:
                ui.messageBox('Green appearance not found')
                return


            body = extrude_feature.bodies[0]
            body.appearance = green_appearance


        ui.messageBox('Rectangles are drawn in component with a height of 40 in Green')


    except Exception as e:
        if ui:
            ui.messageBox('Failed:\n{}'.format(traceback.format_exc()))
