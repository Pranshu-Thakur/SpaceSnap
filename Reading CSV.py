import adsk.core, adsk.fusion, adsk.cam, traceback
import csv

def run(context):
    ui = None
    try:
        app = adsk.core.Application.get()
        ui  = app.userInterface
        design = app.activeProduct
        
        # CSV file path
        csv_file_path = 'path_to_your_csv_file.csv'
        
        # Section 01: Read CSV
        components_status = {}
        with open(csv_file_path, mode='r') as file:
            csv_reader = csv.DictReader(file)
            for row in csv_reader:
                component_name = row['component name']
                component_status = row['component status']
                components_status[component_name] = component_status
        
        # Section 02: Apply color in Fusion 360
        root_comp = design.rootComponent
        all_occurrences = root_comp.allOccurrences
        
        # Loop through components in the model
        for occ in all_occurrences:
            comp_name = occ.component.name
            if comp_name in components_status:
                status = components_status[comp_name]
                
                # Set the color based on the component's status
                if status == "filled":
                    apply_color(occ, 255, 0, 0)  # Red
                elif status == "empty":
                    apply_color(occ, 0, 255, 0)  # Green
                elif status == "partial":
                    apply_color(occ, 255, 255, 0)  # Yellow
        
        ui.messageBox('Script completed successfully.')
    
    except:
        if ui:
            ui.messageBox('Failed:\n{}'.format(traceback.format_exc()))

# Function to apply color to the component
def apply_color(occurrence, red, green, blue):
    # Create a new appearance for the component
    app = adsk.core.Application.get()
    design = app.activeProduct
    
    appearances = design.appearances
    material_lib = app.materialLibraries.itemByName('Fusion Appearance Library')
    color_appearance = appearances.itemByName(f'CustomColor_{red}_{green}_{blue}')
    
    if not color_appearance:
        color_appearance = appearances.addByColor(f'CustomColor_{red}_{green}_{blue}', material_lib.appearances.item(0), adsk.core.Color.create(red, green, blue, 255))
    
    # Apply appearance to the occurrence
    occurrence.component.appearance = color_appearance
