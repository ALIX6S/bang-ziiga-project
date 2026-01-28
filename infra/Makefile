# Raccourcis. Tout s'exécute dans Docker ; seul adb (hôte) parle au téléphone.
DC = docker compose -f docker-compose.yml
.PHONY: up seed apk test phone down clean logs

up:        ## MongoDB + API sur http://localhost:3000
	$(DC) up -d --build --wait
seed:      ## Données de démo (sites, itinéraires, culture, 2 comptes)
	$(DC) --profile tools run --rm seed
apk:       ## Compile l'APK -> infra/out/bang-ziiga.apk (long la 1re fois)
	@mkdir -p out
	$(DC) --profile mobile run --rm --build mobile-build
test:      ## flutter analyze + flutter test (sur une copie du code)
	$(DC) --profile mobile run --rm --build mobile-build bash -euc 'cp -r /src /app && cd /app && flutter pub get && flutter analyze && flutter test'
phone:     ## Installe et lance l'APK sur le téléphone en USB
	./scripts/install-on-phone.sh
logs:
	$(DC) logs -f api
down:      ## Arrête (garde les données)
	$(DC) --profile tools --profile mobile down
clean:     ## Supprime TOUT : conteneurs, données, caches de build
	$(DC) --profile tools --profile mobile down -v --rmi local
	rm -rf out
