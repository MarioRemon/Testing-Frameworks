# Use the official Python slim image
FROM python:3.13-bookworm

# Set the working directory in the container
WORKDIR /app

# Copy necessary files to the working directory
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy the test files after installing dependencies to leverage Docker caching
COPY tests ./tests

# Default command to run pytest
CMD ["pytest", "--maxfail=1", "--disable-warnings", "--tb=short"]
