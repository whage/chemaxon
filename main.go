package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/whage/chemaxon/mirror"
)

const (
	port = 61023
)

func getTimeFromMirrorImageHandler(w http.ResponseWriter, req *http.Request) {
	decoded := mirror.DecodeMirrorImage()
	fmt.Fprintf(w, decoded)
}

func main() {
	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/getTimeFromMirrorImage", getTimeFromMirrorImageHandler)
	fmt.Printf("Listening on port %d\n", port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", port), router))
}
