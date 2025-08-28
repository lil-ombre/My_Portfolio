from flask import Flask, jsonify, request
import mysql.connector

### creating app
app = Flask(__name__)

### setting up mysql connection
def get_db_connection():
    connection = mysql.connector.connect(
        host = 'mdsmysql.sci.pitt.edu',
        user = 'adl171',
        password = 'Mds_4813819@',
        database = 'adl171',
    )
    return connection

### creating home route
@app.route('/')
def home():
    return 'API is Live!!!'

### creating get all books books route
@app.route('/books', methods = ['GET'])
def get_all_books():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute('SELECT * FROM books')
        books = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(books)
    except Exception as e:
        return jsonify({'error': str(e)})
    
### Creating post books route
@app.route('/books', methods = ['POST'])
def post_new_book():
    try:
        data = request.get_json()

        # validating required fields
        required_fields = ['title', 'isbn', 'published_year', 'price', 'publisher_id', 'quantity', 'location']
        for field in required_fields:
            if field not in data:
                return jsonify({'error': f'missing field: {field}'}), 400
            
        # this next part checks to see if user entered one of the already existing publisher_id's
        # were doing this to keep the database consistent and because were not making new publisher entries
        if data['publisher_id'] not in [1,2,3]:
            return jsonify({'error': 'Invalid publisher_id. Use ID 1, 2, or 3'}), 400
        
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Inserting into books table
        cursor.execute(
            'INSERT INTO books (title, isbn, published_year, price, publisher_id) VALUES (%s, %s, %s, %s, %s)',
            (data['title'], data['isbn'], data['published_year'], data['price'], data['publisher_id'])
        )
        book_id = cursor.lastrowid

        #inserting into inventory table
        cursor.execute(
            'INSERT INTO inventory (book_id, quantity, location) VALUES (%s, %s, %s)',
            (book_id, data['quantity'], data['location'])
        )

        conn.commit()

        cursor.execute('SELECT * FROM books WHERE book_id = %s', (book_id,))
        new_book = cursor.fetchone()

        cursor.close()
        conn.close()

        return jsonify({
        'message': 'Book added successfully!!!',
        'book': new_book
        }), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

### Creating route to get details for specific books using their ID's
@app.route('/books/<int:book_id>', methods = ['GET'])
def get_one_book(book_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary = True)

        cursor.execute('SELECT * FROM books WHERE book_id = %s', (book_id,))

        book = cursor.fetchone()

        cursor.close()
        conn.close()

        if book:
            return jsonify(book)
        else:
            return jsonify({'message': 'Book not found'}), 404
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
### Creating route to change details for a particular book in the inventory
@app.route('/books/<int:book_id>', methods = ['PATCH'])
def update_book_inventory(book_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary = True)

        data = request.get_json()

        # check if book_id exists in iventory table
        cursor.execute('SELECT * FROM inventory WHERE book_id = %s',(book_id,))
        if not cursor.fetchone():
            return jsonify({'error': 'Book not found in inventory'}), 404
        
        # update fields
        if 'quantity' not in data and 'location' not in data:
            return jsonify({'error': 'No valid fields (quantity or location) provided'}), 400
        
        if 'quantity' in data:
            cursor.execute('UPDATE inventory SET quantity = %s WHERE book_id = %s', (data['quantity'],book_id))

        if 'location' in data:
            cursor.execute('UPDATE inventory SET location = %s WHERE book_id = %s', (data['location'],book_id))
        
        conn.commit()

        # Fetch and return the updated row
        cursor.execute('SELECT * FROM inventory WHERE book_id = %s', (book_id,))
        updated_book = cursor.fetchone()

        cursor.close()
        conn.close()

        return jsonify({'message': 'Book updated successfully', 'book': updated_book}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
### Creating route to delete book by book_id
@app.route('/books/<int:book_id>', methods = ['DELETE'])
def delete_book(book_id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary = True)

        data = request.get_json()

        # Check if book exists in both tables
        cursor.execute('SELECT * FROM books WHERE book_id = %s', (book_id,))
        book_exists = cursor.fetchone()

        cursor.execute('SELECT * FROM inventory WHERE book_id = %s', (book_id,))
        inventory_exists = cursor.fetchone()

        if not book_exists or not inventory_exists:
            return jsonify({'message': 'Book not found'}), 404
        
        # delete book from both books and inventory table
        cursor.execute('DELETE FROM inventory WHERE book_id = %s', (book_id,))
        cursor.execute('DELETE FROM books WHERE book_id = %s', (book_id,))

        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({'message': 'Book deleted successfully'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

### create route to test database connection
@app.route('/test-db')
def test_db():
    try:
        conn = get_db_connection()
        conn.close()
        return 'Connected to DB Succesfully!!'
    except Exception as e:
        return f'Database connection failed: {str(e)}'

### run app
if __name__ == '__main__':
    app.run(debug=True, host ="0.0.0.0")