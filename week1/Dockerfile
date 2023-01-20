from python:3.9

WORKDIR /app
COPY download_and_push_taxi_data.py app.py
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

ENTRYPOINT ["python", "app.py"]