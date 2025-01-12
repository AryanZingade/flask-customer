import logging
from flask import Flask, request, jsonify, render_template, session, redirect, url_for
from dotenv import load_dotenv
import os
import mysql.connector
import matplotlib.pyplot as plt
import base64
from io import BytesIO
from flask_session import Session

# Load environment variables
load_dotenv()

# Set up logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s',
)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Configure Flask session
app.config['SECRET_KEY'] = 'your_secret_key'
app.config['SESSION_TYPE'] = 'filesystem'
Session(app)


def get_connection():
    """Establish a connection to the database using session variables."""
    try:
        logger.debug("Connecting to MySQL database...")
        connection = mysql.connector.connect(
            host=session.get('db_host'),
            user=session.get('db_user'),
            password=session.get('db_password'),
            database=session.get('db_name')
        )
        logger.debug("Successfully connected to the MySQL database")
        return connection
    except mysql.connector.Error as err:
        logger.error(f"Error connecting to database: {err}")
        return None


@app.route('/', methods=['GET', 'POST'])
def database_input():
    """Route to accept database connection details."""
    if request.method == 'POST':
        # Get database details from the form
        session['db_host'] = request.form.get('db_host')
        session['db_user'] = request.form.get('db_user')
        session['db_password'] = request.form.get('db_password')
        session['db_name'] = request.form.get('db_name')

        # Attempt to establish a connection
        connection = get_connection()
        if connection:
            connection.close()
            return redirect(url_for('run_query'))
        else:
            return render_template('database_input.html', error="Unable to connect to the database. Please check your details.")

    return render_template('database_input.html')


@app.route('/run_query', methods=['GET', 'POST'])
def run_query():
    """Route to execute queries and display results."""
    chart_image = None  # Initialize the variable for the chart image

    if request.method == 'POST':
        query = request.form.get('sql_query')  # Get the SQL query

        if not query:
            logger.debug("No query entered by the user")
            return render_template('query_input.html', chart_image=None, error="Please enter a query.")

        # Connect to the database
        connection = get_connection()
        if not connection:
            return redirect(url_for('database_input'))  # Redirect to database input if connection fails

        cursor = connection.cursor()
        try:
            logger.debug(f"Executing query: {query}")
            cursor.execute(query)
            result = cursor.fetchall()
            columns = [desc[0] for desc in cursor.description]

            # Log the query results
            logger.debug(f"Query Result: {result}")
            logger.debug(f"Columns: {columns}")

            if not result:
                logger.debug("No results returned from the query")
                return render_template('query_input.html', chart_image=None, error="Query returned no results.")

            # Prepare x and y values for the chart
            x = [row[0] for row in result]
            y = [row[1] for row in result]

            if not x or not y:
                logger.debug("X or Y values are empty, no chart will be generated")
                return render_template('query_input.html', chart_image=None, error="Cannot generate chart from query results.")

            # Generate the chart
            fig, ax = plt.subplots()
            ax.bar(x, y)
            ax.set_xlabel(columns[0])
            ax.set_ylabel(columns[1])
            ax.set_title('Query Result')

            # Save the chart as a base64 string
            img_io = BytesIO()
            fig.savefig(img_io, format='png')
            img_io.seek(0)
            img_data = base64.b64encode(img_io.getvalue()).decode('utf-8')
            chart_image = img_data

        except mysql.connector.Error as err:
            logger.error(f"Error executing query: {err}")
            return render_template('query_input.html', chart_image=None, error=f"Error executing query: {err}")
        finally:
            connection.close()

    return render_template('query_input.html', chart_image=chart_image)


if __name__ == "__main__":
    logger.info("Starting Flask application...")
    app.run(host='0.0.0.0', port=5002)
