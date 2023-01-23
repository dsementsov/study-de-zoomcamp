# Week 1 - terraform homework

1. Get your google credentials into json file
2. Put the json file in this folder, note the file name
3. Fill in variables.tf "credentials" variable with a file name (path will be figured out by docker)
4. Run `docker-compose run --rm terraform init`
5. Run `docker-compose run --rm terraform <your-command> -var="project<your-project-id>"`
6. Terraform might take a minute to create the entire thing, be patient. Mine worked weirdly on cntr+c

Note: valid commands are plan / apply / destroy

7. Don't forget to run `docker-compone run --rm terraform destroy -var="project<your-project-id>"` to avoid billing
