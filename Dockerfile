FROM python:3.9-slim

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unzip \
    libx11-dev \
    libx11-6 \
    libgbm-dev \
    libnss3 \
    libgdk-pixbuf2.0-0 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libxcomposite1 \
    libxrandr2 \
    libasound2 \
    libxtst6 \
    libgtk-3-0 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome version 113.0.5672.63
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_113.0.5672.63-1_amd64.deb
RUN dpkg -i google-chrome-stable_113.0.5672.63-1_amd64.deb || apt --fix-broken install -y
RUN rm google-chrome-stable_113.0.5672.63-1_amd64.deb

# Download and install ChromeDriver version 113.0.5672.63
RUN wget -N https://chromedriver.storage.googleapis.com/113.0.5672.63/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d /usr/local/bin/
RUN rm chromedriver_linux64.zip

# Make chromedriver executable
RUN chmod +x /usr/local/bin/chromedriver

WORKDIR /app
COPY . /app

# Install Python dependencies
RUN pip install -r requirements.txt

# Clean up unnecessary files
RUN rm README.md
RUN rm requirements.txt

# Run your Python script by default
CMD ["python", "main.py"]
