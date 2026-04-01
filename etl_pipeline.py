import pandas as pd
import sqlite3
import logging

# Set up logging to track the pipeline's progress
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def run_pipeline():
    logging.info("Starting the Data Pipeline...")

    # 1. EXTRACT: Read the raw data from Excel/CSV files
    # (Make sure these file names match the ones you upload to GitHub!)
    try:
        logging.info("Extracting raw data from files...")
        suppliers_df = pd.read_excel('raw_supplier_data.xlsx')
        products_df = pd.read_excel('raw_product_inventory.xlsx')
        orders_df = pd.read_csv('historical_orders.csv')
        logging.info("Data extraction successful.")
    except FileNotFoundError as e:
        logging.error(f"Error finding files: {e}. Please check file paths.")
        return

    # 2. TRANSFORM: Clean and format the data
    logging.info("Transforming and cleaning data...")
    # Ensure dates are in the correct format
    orders_df['order_date'] = pd.to_datetime(orders_df['order_date']).dt.date
    
    # Fill any missing numerical values with 0 (e.g., if inventory is blank)
    products_df['quantity_in_stock'] = products_df['quantity_in_stock'].fillna(0)

    # 3. LOAD: Connect to the database and load the tables
    logging.info("Connecting to SQL database...")
    # This creates a local database file named 'inventory_system.db'
    conn = sqlite3.connect('inventory_system.db')
    cursor = conn.cursor()

    try:
        logging.info("Loading data into SQL tables...")
        # Write the dataframes to SQL tables. 
        # 'if_exists="replace"' ensures we don't duplicate data if we run the script twice.
        suppliers_df.to_sql('Suppliers', conn, if_exists='replace', index=False)
        products_df.to_sql('Products', conn, if_exists='replace', index=False)
        orders_df.to_sql('Orders', conn, if_exists='replace', index=False)
        logging.info("Data successfully loaded into the database!")

    except Exception as e:
        logging.error(f"Error loading data to SQL: {e}")
    
    finally:
        # Always close the connection
        conn.close()
        logging.info("Database connection closed. Pipeline execution finished.")

if __name__ == "__main__":
    run_pipeline()