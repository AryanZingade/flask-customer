import logging
from flask import Flask, request, jsonify, render_template
from dotenv import load_dotenv
import os
import mysql.connector
import matplotlib.pyplot as plt
import base64
from io import BytesIO

load_dotenv()

# Set up logging to console
logging.basicConfig(
    level=logging.DEBUG,  # Ensure that DEBUG level logs are shown
    format='%(asctime)s - %(levelname)s - %(message)s',  # Log format to include timestamp, level, and message
)

logger = logging.getLogger(__name__)

app = Flask(__name__)

def get_connection():
    try:
        logger.debug("Connecting to MySQL database...")
        connection = mysql.connector.connect(
            host=os.getenv('DB_HOST'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD'),
            database=os.getenv('DB_NAME')
        )
        logger.debug("Successfully connected to MySQL database")
        return connection
    except mysql.connector.Error as err:
        logger.error(f"Error connecting to database: {err}")
        return None

@app.route('/run_query', methods=['GET', 'POST'])
def run_query():
    chart_image = None  # Initialize the variable for the chart image

    if request.method == 'POST':  # If the form was submitted (POST request)
        query = request.form.get('sql_query')  # Get the query entered by the user
        
        # Validate the SQL query to ensure it is not empty
        if not query:
            logger.debug("No query entered by the user")
            return render_template('index.html', chart_image=None)  # Return the page without a chart if no query
        
        # Connect to the MySQL database using the get_connection function
        connection = get_connection()
        cursor = connection.cursor()
        
        try:
            logger.debug(f"Executing query: {query}")
            cursor.execute(query)  # Execute the SQL query entered by the user
            result = cursor.fetchall()  # Get all the results of the query
            columns = [desc[0] for desc in cursor.description]  # Get the column names from the query result

            # Log the results and columns to check if data is being fetched
            logger.debug(f"Query Result: {result}")
            logger.debug(f"Columns: {columns}")

            if not result:
                logger.debug("No results returned from the query")
                
            # Process the results into two lists (x and y values) for plotting
            x = [row[0] for row in result]  # First column of each row (used as x-axis values)
            y = [row[1] for row in result]  # Second column of each row (used as y-axis values)

            if not x or not y:
                logger.debug("X or Y values are empty, no chart will be generated")
            
            # Generate a bar chart using the Matplotlib library
            fig, ax = plt.subplots()  # Create a new figure and axis
            ax.bar(x, y)  # Plot the bar chart with x and y values
            ax.set_xlabel(columns[0])  # Set the label for the x-axis (first column)
            ax.set_ylabel(columns[1])  # Set the label for the y-axis (second column)
            ax.set_title('Query Result')  # Set the title of the chart

            # Save the generated chart as an image in PNG format to a BytesIO object
            img_io = BytesIO()  # Create a BytesIO object to store the image in memory
            fig.savefig(img_io, format='png')  # Save the chart to the BytesIO object as PNG
            img_io.seek(0)  # Move the pointer to the beginning of the image data
            img_data = base64.b64encode(img_io.getvalue()).decode('utf-8')  # Encode the image data in base64 format
            chart_image = img_data
            
        except mysql.connector.Error as err:
            chart_image = None  # If there's an error, set chart_image to None (no chart to display)
            logger.error(f"Error executing query: {err}")
        finally:
            connection.close()  # Close the database connection when done
    
    return render_template('index.html', chart_image=chart_image)


if __name__ == "__main__":
    logger.info("Starting Flask application...")
    app.run(host='0.0.0.0', port=5002)
