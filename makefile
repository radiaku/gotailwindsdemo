.PHONY: build-local build templ notify-templ-proxy run install init

BINARY_NAME=spendings
-include .env

install:
	@go install github.com/a-h/templ/cmd/templ@latest
	@npm install -D tailwindcss

init:
	@npx tailwindcss init
	@echo "Creating tailwind.css..."
	@mkdir -p assets/css
	@echo "@tailwind base;\n@tailwind components;\n@tailwind utilities;" > assets/css/tailwind.css

build-local:
	@go build -o ./bin/main cmd/main/main.go

build:
	@npm run build
	@go build -o ./bin/${BINARY_NAME} cmd/main/main.go

templ:
	@TEMPL_EXPERIMENT=rawgo templ generate --watch --proxy=http://localhost:$(APP_PORT) --proxyport=$(TEMPL_PROXY_PORT) --open-browser=false --proxybind="0.0.0.0"

notify-templ-proxy:
	@templ generate --notify-proxy --proxyport=$(TEMPL_PROXY_PORT)

run:
	@make templ & sleep 1
	@air
