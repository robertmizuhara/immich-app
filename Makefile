.PHONY: up down stop clean

up:
	sudo tailscale serve --bg --https=2284 2283
	docker compose up

down:
	sudo tailscale serve --https=2284 off
	docker compose down

stop:
	docker compose stop

clean:
	docker compose down -v
