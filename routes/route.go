// file: routes/router.go
package routes

import (
	"net/http"

	"go_tailwindws/view"
	"github.com/a-h/templ"
	"github.com/go-chi/chi/v5"
)

func NewRouter() http.Handler {
	r := chi.NewRouter()

	// Serve static files
	fs := http.FileServer(http.Dir("./static"))
	r.Handle("/static/*", http.StripPrefix("/static/", fs))

	// Routes
	r.Method("GET", "/", templ.Handler(view.Index()))



	return r
}
