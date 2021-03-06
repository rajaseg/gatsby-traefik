# Gatsby Docker Container

Gatsby Docker Container for production deployment. Static website using Gatsby with Nginx to serve static files

Run this image behind Traefik proxy. (Traefik acts as a reverse proxy for micro-services in swarm mode)

## Docker Compose

		version: "3.7"

		services:
		  gatsby:
		  image: rajaseg/gatsby-traefik
		  volumes:
		    - /mnt/gatsby:/app
		  networks:
		    - proxy
		  deploy:
		    placement:
		      constraints: [node.role == worker]
		    replicas: 1
		    update_config:
		      parallelism: 2
		      delay: 10s
		    restart_policy:
                      condition: on-failure
		    labels:
		      - "traefik.enable=true"
		      - "traefik.docker.network=proxy"
		      - "traefik.http.routers.gatsby.rule=Host(`gatsby.example.com`)"
		      - "traefik.http.routers.gatsby.tls=true"
		      - "traefik.http.routers.gatsby.tls.certresolver=default"
		      - "traefik.http.routers.gatsby.entrypoints=websecure"
		      - "traefik.http.services.gatsby.loadbalancer.server.port=80"
		volumes:
		  gatsby:
	            driver: "local"
		networks:
		  proxy:
		    external: true
