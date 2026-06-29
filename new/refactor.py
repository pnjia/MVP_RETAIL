import glob
import os
import re

files_metadata = {
    "00_Project/01_Product_Vision_And_Scope.md": {"id": "project-vision-scope", "title": "Product Vision And Scope", "type": "project", "parent": "root", "tags": "vision, scope", "version": "1.0"},
    "00_Project/17_Development_Roadmap.md": {"id": "project-development-roadmap", "title": "Development Roadmap", "type": "project", "parent": "root", "tags": "roadmap, schedule", "version": "1.0"},
    "01_Business/02_Business_Domain_Analysis.md": {"id": "domain-analysis", "title": "Business Domain Analysis", "type": "domain", "parent": "root", "tags": "domain, business", "version": "1.0"},
    "01_Business/03_Business_Process_Mapping.md": {"id": "process-mapping", "title": "Business Process Mapping", "type": "process", "parent": "domain-analysis", "tags": "process, flow", "version": "1.0"},
    "01_Business/05_Functional_Spesification.md": {"id": "functional-specification", "title": "Functional Specification", "type": "domain", "parent": "domain-analysis", "tags": "functional, spec", "version": "1.0"},
    "01_Business/06_Business_Rules_And_State_Machine.md": {"id": "business-rules", "title": "Business Rules And State Machine", "type": "rule", "parent": "domain-analysis", "tags": "rule, state", "version": "1.0"},
    "02_Architecture/04_Bounded_Context_And_Domain_Model.md": {"id": "architecture-bounded-context", "title": "Bounded Context And Domain Model", "type": "architecture", "parent": "domain-analysis", "tags": "architecture, ddd", "version": "1.0"},
    "02_Architecture/10_Backend_Architecture.md": {"id": "architecture-backend", "title": "Backend Architecture", "type": "architecture", "parent": "architecture-bounded-context", "tags": "backend, architecture", "version": "1.0"},
    "02_Architecture/12_Frontend_Architecture.md": {"id": "architecture-frontend", "title": "Frontend Architecture", "type": "architecture", "parent": "architecture-bounded-context", "tags": "frontend, architecture", "version": "1.0"},
    "03_Data/07_Conceptual_Data_Model.md": {"id": "data-conceptual", "title": "Conceptual Data Model", "type": "entity", "parent": "architecture-bounded-context", "tags": "data, conceptual", "version": "1.0"},
    "03_Data/08_Logical_Data_Model.md": {"id": "data-logical", "title": "Logical Data Model", "type": "database", "parent": "data-conceptual", "tags": "data, logical", "version": "1.0"},
    "03_Data/09_Physical_Database_Design.md": {"id": "data-physical", "title": "Physical Database Design", "type": "database", "parent": "data-logical", "tags": "database, physical", "version": "1.0"},
    "04_API/11_API_Contract.md": {"id": "api-contract", "title": "API Contract", "type": "api", "parent": "architecture-backend", "tags": "api, contract", "version": "1.0"},
    "05_UI/13_Information_Architecture.md": {"id": "ui-information-architecture", "title": "Information Architecture", "type": "ui", "parent": "architecture-frontend", "tags": "ui, ia", "version": "1.0"},
    "05_UI/14_UI_FLOW.md": {"id": "ui-flow", "title": "UI FLOW", "type": "ui", "parent": "ui-information-architecture", "tags": "ui, flow", "version": "1.0"},
    "05_UI/15_Screen_Spesification.md": {"id": "ui-screen-spec", "title": "Screen Specification", "type": "ui", "parent": "ui-flow", "tags": "ui, screen", "version": "1.0"},
    "05_UI/16_Design_System.md": {"id": "ui-design-system", "title": "Design System", "type": "ui", "parent": "ui-screen-spec", "tags": "ui, design system", "version": "1.0"}
}

required_sections = [
    "Summary",
    "Related Domains",
    "Related Processes",
    "Related Entities",
    "Related Database",
    "Related API",
    "Related Screens",
    "Business Rules",
    "References"
]

for filepath, meta in files_metadata.items():
    if not os.path.exists(filepath):
        print(f"Skipping {filepath}, not found")
        continue
    
    with open(filepath, 'r') as f:
        content = f.read()

    # Remove existing frontmatter if any
    content = re.sub(r'^---\n.*?\n---\n*', '', content, flags=re.DOTALL)
    
    frontmatter = f"---\nid: {meta['id']}\ntitle: {meta['title']}\ntype: {meta['type']}\nparent: {meta['parent']}\ntags: {meta['tags']}\nversion: {meta['version']}\n---\n\n"
    
    # Check what headings exist
    existing_headings = re.findall(r'^##\s+(.*)$', content, flags=re.MULTILINE)
    
    # We want to add missing headings at the end of the file.
    # But wait, the main content needs to be under the right document structure.
    # Let's append the required sections if they are missing.
    appended_content = ""
    for req in required_sections:
        if req not in existing_headings and f"Related {req}" not in existing_headings and req != "Related Screens" and req != "Related Business Rules":
            appended_content += f"\n## {req}\n\n- TBD\n"

    new_content = frontmatter + content + appended_content
    
    with open(filepath, 'w') as f:
        f.write(new_content)
        
    print(f"Refactored {filepath}")
