
# Use Python base image
FROM python:3.6

# Set the working directory
WORKDIR /flask

# Add the current directory to the container as /app
COPY . /flask

# Install all the dependencies - pip as package manager
RUN pip install --upgrade --requirement requirements.txt

# Expose the default flask port to container
EXPOSE 8080


# Execute the flask App
ENTRYPOINT [ "python" ]
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "curl --fail http://localhost:8080/ || exit 1" ]
CMD [ "/flask/app.py" ]