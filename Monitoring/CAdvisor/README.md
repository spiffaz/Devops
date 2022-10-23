CAdvisor is maintained by google and can be used to scrape metrics from all running docker containers.

Steps to setup can be gotten from the official documentation here - ``` https://github.com/google/cadvisor ```. Or you can just run the docker compose.

Personal preference: I prefer to deploy all my monitoring stack in the same docker network so that I do not have to expose any ports by just using the docker network.
