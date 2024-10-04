#Access component in the design and changes the color of the system
#It Works


import adsk.core, adsk.fusion, adsk.cam, traceback

def run(context):
    try:
        app = adsk.core.Application.get()
        ui = app.userInterface

        design = app.activeProduct
        root_comp = design.rootComponent

        # Access components by their names
        comp1 = root_comp.occurrences.itemByName('Component1:1')
        comp2 = root_comp.occurrences.itemByName('Component2:1')
        comp3 = root_comp.occurrences.itemByName('Component3:1')
        comp4 = root_comp.occurrences.itemByName('Component4:1')
        comp5 = root_comp.occurrences.itemByName('Component5:1')
        comp6 = root_comp.occurrences.itemByName('Component6:1')
        comp7 = root_comp.occurrences.itemByName('Component7:1')
        comp8 = root_comp.occurrences.itemByName('Component8:1')

        # Example: Print the names of the components
        ui.messageBox('Components:\n{}\n{}\n{}\n{}\n{}\n{}\n{}\n{}'.format(comp1.name, comp2.name, comp3.name, comp4.name, comp5.name, comp6.name, comp7.name, comp8.name))

        # You can now manipulate these components as needed
        # For example, changing the appearance of a body in Component 8
        body8 = comp8.component.bRepBodies.item(0)
        body7 = comp7.component.bRepBodies.item(0)
        body6 = comp6.component.bRepBodies.item(0)
        body5 = comp5.component.bRepBodies.item(0)

        material_libs = app.materialLibraries
        appearance_lib = material_libs.itemByName("Fusion Appearance Library")
        if not appearance_lib:
            ui.messageBox('Appearance library not found.')
            return

        appearances = appearance_lib.appearances
        red_appearance = appearances.itemByName("Paint - Metal Flake (Red)")
        yellow_appearance = appearances.itemByName("Paint - Metal Flake (Yellow)")
        green_appearance = appearances.itemByName("Paint - Metal Flake (Green)")


        body8.appearance = red_appearance
        body7.appearance = yellow_appearance
        body6.appearance = red_appearance
        body5.appearance = green_appearance

    except Exception as e:
        if ui:
            ui.messageBox('Failed:\n{}'.format(traceback.format_exc()))