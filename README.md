![Alt text](images/Screenshot_1_level.png)  
# Docker Mini Project: Timetable Webpage with PostgreSQL
This project creates a simple webpage to check timetables using resources from Docker. It includes setting up PostgreSQL in Docker, building a Flask application, and configuring multi-container Docker setups.

Guides

## Instructions

### 1. Install Docker and Start PostgreSQL in Docker

First, you need to install Docker and set up a PostgreSQL database in a Docker container.

```bash
# Pull the PostgreSQL Docker Image
docker pull postgres:15

# Create and Run a PostgreSQL Container
docker run --name Altusha-db -e POSTGRES_USER=student -e POSTGRES_PASSWORD=student_pass -d -p 5432:5432 postgres:15

# Verify the container is running
docker ps

# Access the PostgreSQL Database
docker exec -it Altusha-db psql -U student
```

### 2. **Set Up the PostgreSQL Database and Tables**

```sql

-- Create the Timetable table
CREATE TABLE Timetable (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(255),
    day VARCHAR(50),
    time VARCHAR(50),
    room VARCHAR(50),
    level INT
);

-- Insert Sample Data into the Timetable table
INSERT INTO Timetable (course_name, day, time, room, level) VALUES
('Computer and Information Security', 'Thursday', '4:30 PM - 06:50 PM', 'Room 114', 2),
('Database Concepts', 'Tuesday', '09:00 AM - 11:20 AM', 'Room 115', 1),
('Discrete Mathematics', 'Thursday', '02:00 PM - 04:20 PM', 'Room 403', 3),
('Principles of Programming', 'Monday', '04:30 PM - 06:50 PM', 'Room 114', 3),
('Operating Systems', 'Wednesday', '11:30 AM - 01:50 PM', 'Room 114', 2),
('IT Project Management', 'Monday', '11:30 AM - 01:50 PM', 'Room 105', 2);

```

### 3. **Install Python and Flask Dependencies**

```bash
# Create and activate a virtual environment
python -m venv venv
source venv/bin/activate  

# Install Flask and pg8000 for database connection
pip install flask pg8000
```
### Visual Studio Code

### 4. **Create Flask Application**

```python

from flask import Flask, render_template, request
import psycopg2
import os

template_dir = os.path.abspath('templates/')
app = Flask(__name__, template_folder=template_dir)


conn = psycopg2.connect(
    host="db",  
    database="ALTUSHA", 
    user="student",
    password="student_pass"  
)

cur = conn.cursor()

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        level = request.form.get("level", "")
        return render_template("timetable.html", level=level, data=[], message="Loading timetable...")
    return render_template("index.html")

@app.route("/timetable", methods=["GET"])
def timetable():
    level = request.args.get("level")
    if not level:
        return render_template("timetable.html", data=[], message="Level is required.")

    query = "SELECT * FROM Timetable WHERE level = %s;"  
    cur.execute(query, (level,))
    rows = cur.fetchall()
    message = "No data found for this level." if not rows else None
    return render_template("timetable.html", data=rows, message=message)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)

```

### 5. **Create in the folder templates: HTML Templates for Flask**

#### **`index.html` (Form for Level Input)**

```html
<!DOCTYPE html>
<html>
<head>
    <title>Mini docker project of  </title>
</head>
<body>
    <h1>Welcome to the Altynay's Webster University Timetable!</h1>
    <form action="/timetable" method="GET">
        <label for="level">Select Level:</label>
        <select name="level" id="level">
            <option value="1">Level 1</option>
            <option value="2">Level 2</option>
            <option value="3">Level 3</option>
        </select>
        <button type="submit">Submit</button>
    </form>
</body>
</html>
```

#### Create in folder templates:**`timetable.html` (Displaying Timetable)**

```html
<!DOCTYPE html>
<html>
<head>
    <title>Timetable</title>
</head>
<body>
    <h2>Timetable for level {{ level }}</h2>
    {% if data %}
    <table border="1">
        <tr>
            <th>Course ID</th>
            <th>Course Name</th>
            <th>Day</th>
            <th>Time</th>
            <th>Room</th>
        </tr>
        {% for row in data %}
        <tr>
            <td>{{ row[0] }}</td>
            <td>{{ row[1] }}</td>
            <td>{{ row[2] }}</td>
            <td>{{ row[3] }}</td>
            <td>{{ row[4] }}</td>
        </tr>
        {% endfor %}
    </table>
    {% else %}
    <p>{{ message }}</p>
    {% endif %}
</body>
</html>
```

### 6.Build a Docker image for a Python application***

## Multi-container Docker applications
docker-compose.yaml
```yaml

version: '3'
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_USER: student
      POSTGRES_PASSWORD: student_pass
      POSTGRES_DB: ALTUSHA
    ports:
      - "5432:5432"
    volumes:
      - ./db-scripts:/docker-entrypoint-initdb.d

  web:
    build: .
    ports:
      - "8000:8000"
    depends_on:
      - db

```
## Dockerfile
```Dockerfile

FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file to the container
COPY requirements.txt /app/

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code into the container
COPY . /app/

# Set the default command to run the application
CMD ["python", "app.py"]

```
## Dependencies needed:
```bash
blinker==1.9.0
click==8.1.7
Flask==3.1.0
itsdangerous==2.2.0
Jinja2==3.1.4
MarkupSafe==3.0.2
Werkzeug==3.1.3
psycopg2-binary
```
# To Start the Services:
```bash
docker-compose up --build
```

### 7. **Accessing the Application**

- Navigate to `http://127.0.0.1:8000` in your web browser to see the application in action.

