#Check for libraries


import adsk.core, adsk.fusion, adsk.cam, traceback

def run(context):
    try:
        app = adsk.core.Application.get()
        ui = app.userInterface

        material_libs = app.materialLibraries
        lib_names = [lib.name for lib in material_libs]

        ui.messageBox('Available Material Librarires: \n{}'.format('\n'.join(lib_names)))

    except Exception as e:
        if ui:
            ui.messageBox('Failed:\n{}'.format(traceback.format_exc()))