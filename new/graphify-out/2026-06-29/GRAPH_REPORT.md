# Graph Report - .  (2026-06-29)

## Corpus Check
- 20 files · ~16,868 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 31 nodes · 24 edges · 17 communities (4 shown, 13 thin omitted)
- Extraction: 88% EXTRACTED · 12% INFERRED · 0% AMBIGUOUS · INFERRED: 3 edges (avg confidence: 0.92)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Business Process & Planning|Business Process & Planning]]
- [[_COMMUNITY_Core Business Rules|Core Business Rules]]
- [[_COMMUNITY_Contact Domain|Contact Domain]]
- [[_COMMUNITY_Backend Architecture|Backend Architecture]]
- [[_COMMUNITY_Graphify Tools|Graphify Tools]]
- [[_COMMUNITY_Architecture Principles|Architecture Principles]]
- [[_COMMUNITY_Modular Monolith|Modular Monolith]]
- [[_COMMUNITY_Feature First UI|Feature First UI]]
- [[_COMMUNITY_Frontend Architecture|Frontend Architecture]]
- [[_COMMUNITY_Stock Movement|Stock Movement]]
- [[_COMMUNITY_Identifier Strategy|Identifier Strategy]]
- [[_COMMUNITY_Information Architecture|Information Architecture]]
- [[_COMMUNITY_Screen Specs|Screen Specs]]
- [[_COMMUNITY_Design System|Design System]]
- [[_COMMUNITY_UX Principles|UX Principles]]
- [[_COMMUNITY_Glossary|Glossary]]

## God Nodes (most connected - your core abstractions)
1. `Development Roadmap Document` - 8 edges
2. `Product Vision and Scope Document` - 7 edges
3. `README Document` - 7 edges
4. `Business Domain Analysis Document` - 3 edges
5. `Business Process Mapping Document` - 3 edges
6. `Physical Database Design Document` - 3 edges
7. `API Contract Document` - 3 edges
8. `Contact as Root Entity Rationale` - 2 edges
9. `Bounded Context and Domain Model Document` - 2 edges
10. `Graphify Knowledge Graph` - 1 edges

## Surprising Connections (you probably didn't know these)
- `Contact as Root Entity Rationale` --semantically_similar_to--> `Contact as Root Aggregate`  [INFERRED] [semantically similar]
  01_Business/02_Business_Domain_Analysis.md → 02_Architecture/04_Bounded_Context_And_Domain_Model.md
- `Contact as Root Entity Rationale` --semantically_similar_to--> `Contact as Unified Entity`  [INFERRED] [semantically similar]
  01_Business/02_Business_Domain_Analysis.md → 03_Data/07_Conceptual_Data_Model.md
- `README Document` --cites--> `Bounded Context and Domain Model Document`  [EXTRACTED]
  README.md → 02_Architecture/04_Bounded_Context_And_Domain_Model.md
- `Product Vision and Scope Document` --cites--> `Business Domain Analysis Document`  [EXTRACTED]
  00_Project/01_Product_Vision_And_Scope.md → 01_Business/02_Business_Domain_Analysis.md
- `Product Vision and Scope Document` --cites--> `Business Process Mapping Document`  [EXTRACTED]
  00_Project/01_Product_Vision_And_Scope.md → 01_Business/03_Business_Process_Mapping.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Domain Analysis Flow** — 01_business_02_business_domain_analysis_file, 01_business_03_business_process_mapping_file, 01_business_05_functional_spesification_file, 01_business_06_business_rules_and_state_machine_file [INFERRED 0.95]
- **Architecture Flow** — 02_architecture_04_bounded_context_and_domain_model_file, 02_architecture_10_backend_architecture_file, 02_architecture_12_frontend_architecture_file [INFERRED 0.95]
- **Data Flow** — 03_data_07_conceptual_data_model_file, 03_data_08_logical_data_model_file, 03_data_09_physical_database_design_file [INFERRED 0.95]

## Communities (17 total, 13 thin omitted)

### Community 0 - "Business Process & Planning"
Cohesion: 0.36
Nodes (8): Development Roadmap Document, Business Domain Analysis Document, Business Process Mapping Document, Functional Specification Document, Logical Data Model Document, Physical Database Design Document, UI Flow Document, README Document

### Community 1 - "Core Business Rules"
Cohesion: 0.50
Nodes (4): Product Vision and Scope Document, Business Rules and State Machine Document, Conceptual Data Model Document, API Contract Document

### Community 2 - "Contact Domain"
Cohesion: 0.67
Nodes (3): Contact as Root Entity Rationale, Contact as Root Aggregate, Contact as Unified Entity

## Knowledge Gaps
- **13 isolated node(s):** `Graphify Knowledge Graph`, `Graphify Workflow`, `Functional Specification Document`, `Business Rules and State Machine Document`, `Backend Architecture Document` (+8 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **13 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `README Document` connect `Business Process & Planning` to `Core Business Rules`, `Backend Architecture`?**
  _High betweenness centrality (0.078) - this node is a cross-community bridge._
- **Why does `Development Roadmap Document` connect `Business Process & Planning` to `Core Business Rules`?**
  _High betweenness centrality (0.063) - this node is a cross-community bridge._
- **Why does `Product Vision and Scope Document` connect `Core Business Rules` to `Business Process & Planning`?**
  _High betweenness centrality (0.057) - this node is a cross-community bridge._
- **What connects `Graphify Knowledge Graph`, `Graphify Workflow`, `Architecture Principles` to the rest of the system?**
  _21 weakly-connected nodes found - possible documentation gaps or missing edges._