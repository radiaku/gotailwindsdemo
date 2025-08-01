// file: main.go
package main

import (
	"log"
	"net/http"
	"os"

	"go_tailwindws/view"
	"go_tailwindws/view/partial"

	"github.com/a-h/templ"
	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	port := os.Getenv("APP_PORT")
	if port == "" {
		port = "8080" // fallback default
	}
	fs := http.FileServer(http.Dir("./static"))
	http.Handle("/static/", http.StripPrefix("/static/", fs))

	http.Handle("/", templ.Handler(view.Index()))

	http.Handle("/foo", templ.Handler(partial.Foo()))

	log.Fatal(http.ListenAndServe(":"+port, nil))
}
