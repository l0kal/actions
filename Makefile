packages := $(dir $(wildcard */package.json))

install:
	@$(foreach dir, . $(packages), npm install --prefix $(dir) || exit 1;)

install-ci:
	@$(foreach dir, . $(packages), npm ci --prefix $(dir) || exit 1;)

lint:
	npm run lint:js

test:
	@$(foreach dir, $(packages), npm test --prefix $(dir) || exit 1;)

build: $(packages)

$(packages):
	@rm -rf $(@)dist
	@docker run --rm -t -v $(shell pwd):/work -w /work node:12-alpine sh -c "npm run build --prefix $(@)"

license-summary:
	@npm i license-checker --no-save --production
	@$(foreach dir, $(packages), echo "Licenses for $(dir)" && node_modules/.bin/license-checker --production --direct --summary --excludePrivatePackages --start $(dir);)

.PHONY: install install-ci lint test build $(packages) license-summary
