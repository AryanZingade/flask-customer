from flask import Flask, request, jsonify
import mysql.connector
import logging

# Set up logging
logging.basicConfig(level=logging.DEBUG)  # Set the log level to DEBUG
logger = logging.getLogger(__name__)

app = Flask(__name__)

def get_connection():
    try:
        logger.debug("Connecting to MySQL database...")
        connection = mysql.connector.connect(
            host='host.docker.internal',
            user='root',
            password='Platino@1901',
            database='hotel'
        )
        logger.debug("Successfully connected to MySQL database")
        return connection
    except mysql.connector.Error as err:
        logger.error(f"Error connecting to database: {err}")
        return None

@app.route('/customer', methods=['POST'])
def create_customer():
    data = request.get_json()
    f_name = data.get('F_Name')
    l_name = data.get('L_Name')
    dob = data.get('DOB')

    if not f_name or not l_name or not dob:
        return jsonify({'error': 'First name, last name, and DOB are required'}), 400

    connection = get_connection()
    if connection is None:
        return "Database connection failed.", 500

    try:
        cursor = connection.cursor()
        cursor.execute(
            "INSERT INTO customer (F_Name, L_Name, DOB) VALUES (%s, %s, %s)",
            (f_name, l_name, dob)
        )
        connection.commit()
        connection.close()
        return jsonify({'message': 'Customer created successfully'}), 201
    except mysql.connector.Error as err:
        logger.error(f"Error executing query: {err}")
        connection.close()
        return jsonify({'error': 'Error creating customer'}), 500

@app.route('/customer', methods=['GET'])
def read_customers():
    connection = get_connection()
    if connection is None:
        return "Database connection failed.", 500

    try:
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM customer")
        result = cursor.fetchall()
        connection.close()

        if not result:
            return jsonify({"message": "No customers found"}), 404
        
        customers = [
            {'ID': row[0], 'F_Name': row[1], 'L_Name': row[2], 'DOB': row[3].strftime('%Y-%m-%d')}
            for row in result
        ]
        return jsonify(customers)
    except mysql.connector.Error as err:
        logger.error(f"Error executing query: {err}")
        connection.close()
        return jsonify({'error': 'Error reading customers'}), 500

@app.route('/customer/<int:id>', methods=['PUT'])
def update_customer(id):
    data = request.get_json()
    f_name = data.get('F_Name')
    l_name = data.get('L_Name')
    dob = data.get('DOB')

    if not f_name or not l_name or not dob:
        return jsonify({"message": "First name, last name, and DOB are required"}), 400

    connection = get_connection()
    if connection is None:
        return "Database connection failed.", 500

    try:
        cursor = connection.cursor()
        update_query = """
            UPDATE customer
            SET F_Name = %s, L_Name = %s, DOB = %s
            WHERE ID = %s
        """
        cursor.execute(update_query, (f_name, l_name, dob, id))
        connection.commit()

        if cursor.rowcount == 0:
            return jsonify({"message": "Customer not found"}), 404

        connection.close()
        return jsonify({"message": "Customer updated successfully"})
    except mysql.connector.Error as err:
        logger.error(f"Error updating customer: {err}")
        connection.close()
        return jsonify({"error": "Error updating customer"}), 500

@app.route('/customer/<int:id>', methods=['DELETE'])
def delete_customer(id):
    connection = get_connection()
    if connection is None:
        return "Database connection failed.", 500

    try:
        cursor = connection.cursor()
        delete_query = "DELETE FROM customer WHERE ID = %s"
        cursor.execute(delete_query, (id,))
        connection.commit()

        if cursor.rowcount == 0:
            return jsonify({"message": "Customer not found"}), 404

        connection.close()
        return jsonify({"message": "Customer deleted successfully"})
    except mysql.connector.Error as err:
        logger.error(f"Error deleting customer: {err}")
        connection.close()
        return jsonify({"error": "Error deleting customer"}), 500

if __name__ == "__main__":
    logger.info("Starting Flask application...")
    app.run(host='0.0.0.0', port=5002)
