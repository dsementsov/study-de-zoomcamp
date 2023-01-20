# Data Engineering Zoomcamp homework assignment Week 1:

## Locations

Question 1 & 2: data_exploration_questions_12.md
Question 3 & 4 & 5 & 6: data_exploration_questions_3456.ipynb

## Data setup

Disclaimer: I am skipping volume setup because docker compose is going to download the data anyway and name the containers; also since I am on windows,
I don't want to expose my PC name.

1. Build Docker container by running

```bash
docker build -t download_taxi_data .
```

2. Create docker network

```bash
docker network create taxi_network
```

3. Run postgres

```bash
docker run -it -p 5432:5432 --name pg_taxi_data --network taxi_network postgres
```

4. Run the pipeline

```bash
docker run -p 8080:80 --network taxi_network download_taxi_data postgres postgres pg_taxi_data postgres
```

5. (Optional) Spin jupyter lab notebook in the same network

```bash
docker run -p 8888:8888 --network taxi_network jupyter/datascience-notebook
```

and push the notebook

6. Open exploration notebook, execute

7. (Optional) Spin pgadmin container in the same network

```bash
docker run -p 80:80 \
-e 'PGADMIN_DEFAULT_EMAIL=user@domain.com' \
-e 'PGADMIN_DEFAULT_PASSWORD=SuperSecret' \
--network taxi_network
-d dpage/pgadmin4
```

8. (Optional) Execute SQL queries directly in pgadmin or dbeaver, so sql file attached
