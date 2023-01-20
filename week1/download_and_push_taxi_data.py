import pandas as pd
from sqlalchemy import create_engine
import gzip
import shutil
import argparse
import os


def download_file(url):
	fname = url.split("/")[-1]
	os.system(f"wget {url}")
	return fname


def main(params):
	username = params.username
	password = params.password
	hostname = params.hostname
	dbschema = params.dbschema

	print("Testing dabatase connection...")
	engine = create_engine(f"postgresql://{username}:{password}@{hostname}:5432/{dbschema}")

	print("Downloading zones...")
	taxi_zones_fname = download_file("https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv")
	print("Injesting zones...")
	# it is always small enough to just push it like that
	df = pd.read_csv(taxi_zones_fname)
	df.to_sql("taxi_zones", con=engine, index=False)
	del df

	print("Downloading trips...")
	dataset_fname = download_file("https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-01.csv.gz")
	print("Unzipping...")
	with gzip.open(dataset_fname, 'rb') as f_in:
		with open('green_taxi_data.csv', 'wb') as f_out:
			shutil.copyfileobj(f_in, f_out)

	print("Injesting trips...")
	large_df = pd.read_csv("green_taxi_data.csv", chunksize=100000)

	for chunk in large_df:
		chunk["lpep_pickup_datetime"] = pd.to_datetime(chunk["lpep_pickup_datetime"])
		chunk["lpep_dropoff_datetime"] = pd.to_datetime(chunk["lpep_dropoff_datetime"])

		chunk.to_sql("taxi_trips", con=engine, if_exists="append", index=False)
	print("Done...")



if __name__ == "__main__":
	parser = argparse.ArgumentParser(description="Download and inject taxi data")

	parser.add_argument("--username", help="database username")
	parser.add_argument("--password", help="database password")
	parser.add_argument("--hostname", help="database hostname (docker container name in the same network)")
	parser.add_argument("--dbschema", help="database dbschema")

	params = parser.parse_args()

	main(params)
