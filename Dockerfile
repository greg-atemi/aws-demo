# Use the official Python Alpine image as a base
FROM python:3.11-alpine

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install build dependencies for Postgres
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    && pip install --no-cache-dir psycopg2-binary

# Set the working directory
WORKDIR /app

# Copy requirements.txt and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Django project files
COPY . .

# Expose the port your app runs on
EXPOSE 8000

# Start the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

