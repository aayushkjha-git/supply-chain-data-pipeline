# Brewing Operations: Supply Chain & Inventory Data Pipeline

## Objective
This project simulates a backend data pipeline and relational database for a high-volume brewing plant. It is designed to extract raw operational data, load it into a structured database, and execute queries that monitor real-time inventory levels to prevent production bottlenecks.

## Tech Stack & Workflow
* **Python (Pandas & SQLite):** Engineered an automated ETL (Extract, Transform, Load) pipeline to programmatically extract raw inventory data from daily Excel/CSV logs, clean missing values, and load it into a local database.
* **SQL:** Designed the relational schema (Data Definition Language) and wrote analytical queries (Data Manipulation Language) to optimize procurement.
* **Excel:** Served as the simulated raw data source from the shop floor.

## Database Architecture
The system relies on three interconnected tables to ensure data integrity:
1. **Suppliers:** Tracks vendor details and historical lead times.
2. **Products:** Monitors SKUs, current stock levels, and links to respective suppliers.
3. **Orders:** Logs all incoming and outgoing shipments to calculate throughput.

## Key Business Logic Queries
* **Automated Low-Stock Flagging:** Identifies SKUs falling below critical safety stock thresholds.
* **Lead Time Optimization:** Calculates average delivery time per supplier to inform the procurement strategy.
* **Throughput Tracking:** Analyzes monthly shipment volumes to gauge overall warehouse efficiency.
