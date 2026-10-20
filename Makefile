.PHONY: up down stop clean prune

up:
	sudo tailscale serve --bg --https=2284 2283
	docker compose up &
	socat TCP-LISTEN:2285,bind=100.106.199.81,reuseaddr,fork \
	  EXEC:$(PWD)/backup-trigger.sh &

down:
	docker compose down
	sudo tailscale serve --https=2284 off

stop:
	docker compose stop

clean:
	docker compose down -v

prune:
	docker volume prune -f
