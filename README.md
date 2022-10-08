# Monitoring
This is a repo to show how to setup infrastructure monitoring on servers and docker containers using Prometheus and Grafana

How to setup Prometheus:
1. Copy the config template (prometheus.yml) into /etc/prometheus/prometheus.yml on the host machine.
2. Copy the docker-compose.yml file into the project folder and start the container. (Note that the compose file also includes Grafana.)
3. Configure your settings in the Prometheus config file. Details on how to do this can be gotten from the official Prometheus documentation.

How to setup Grafana:
1. Go to the web ui on http://localhost:3000
2. Login with the default username and password (admin)
