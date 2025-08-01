.PHONY: build-local build templ notify-templ-proxy run install init

BINARY_NAME=gotailwinds
-include .env

install:
	@go install github.com/a-h/templ/cmd/templ@latest
	@go get -u github.com/a-h/templ
	@npm init -y
	@npm install -D tailwindcss
	@mkdir -p bin

init:
	@npx tailwindcss init
	@mkdir -p static/css
	@printf "@tailwind base;\n@tailwind components;\n@tailwind utilities;\n" > static/css/input.css
	@npm run dev

build-local:
	@go build -o ./bin/main cmd/main/main.go

build:
	@npm run build
	@go build -o ./bin/${BINARY_NAME} cmd/main/main.go

templ:
	@TEMPL_EXPERIMENT=rawgo templ generate --watch --proxy=http://localhost:$(APP_PORT) --proxyport=$(TEMPL_PROXY_PORT) --open-browser=false --proxybind="0.0.0.0"

tailwind:
	@npx tailwindcss -i ./static/css/input.css -o ./static/css/tailwind.css --watch

notify:
	@templ generate --notify-proxy --proxyport=$(TEMPL_PROXY_PORT)

run:
	@make templ & sleep 1
	@air
