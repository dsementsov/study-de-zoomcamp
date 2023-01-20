# Docker exploration

## Question 1: Which tag has the following text? - Write the image ID to the file

1. Open terminal, make sure that the docker installed
2. Run following commands (Windows powershell):

```bash
    docker --help
    docker build --help | Select-String -Pattern "Write"
```

3. The output will look like that

```bash
   --iidfile string          Write the image ID to the file
```

Answer: --iidfile string

## Question 2: How many python packages/modules are installed?

Execute following steps

1. Spin docker python:3.9 container, make it interactive with entry point bash
2. Run pip list
3. Count the number of libraries

```bash
    docker run -it --entrypoint=bash python:3.9
    pip list
```

Answer: 3 libraries
