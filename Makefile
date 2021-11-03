.PHONY: up
up:
	docker compose up -d
	-docker compose logs --follow

.PHONY: down
down:
	docker compose down

.PHONY: down
clean: down
	docker compose rm
	docker volume ls --format '{{- .Name -}}' | grep -e "^$(notdir $(PWD))" | xargs docker volume rm
	docker builder prune --filter type=exec.cachemount --force
	[ ! -d service-foo/target ] || rm -rfv service-foo/target/
	[ ! -d service-bar/target ] || rm -rfv service-bar/target/