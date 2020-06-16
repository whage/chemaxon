package main

import (
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
	"github.com/whage/chemaxon/mirror"
)

const (
	port = 61023
)

func getTimeFromMirrorImageHandler(w http.ResponseWriter, req *http.Request) {
	hoursQueryParams, ok := req.URL.Query()["hours"]
	if !ok {
		fmt.Fprintf(w, "Query string must contain an `hours` parameter!\n")
		return
	}

	if len(hoursQueryParams) != 1 {
		fmt.Fprintf(w, "Ambiguous `hours` query parameter!\n")
		return
	}

	hours, err := strconv.Atoi(hoursQueryParams[0])
	if err != nil {
		fmt.Fprintf(w, "Invalid `hours` parameter: %v. Must be an integer!\n", hoursQueryParams[0])
		return
	}

	minutesQueryParams, ok := req.URL.Query()["minutes"]
	if !ok {
		fmt.Fprintf(w, "Query string must contain a `minutes` parameter!\n")
		return
	}

	if len(minutesQueryParams) != 1 {
		fmt.Fprintf(w, "Ambiguous `minutes` query parameter!\n")
		return
	}

	minutes, err := strconv.Atoi(minutesQueryParams[0])
	if err != nil {
		fmt.Fprintf(w, "Invalid `minutes` parameter: %v. Must be an integer!\n", minutesQueryParams[0])
		return
	}

	decoded := mirror.DecodeMirrorImage(mirror.ClockReading{hours, minutes})
	fmt.Fprintf(w, "%d:%d\n", decoded.Hours, decoded.Minutes)
}

func main() {
	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/getTimeFromMirrorImage", getTimeFromMirrorImageHandler)
	fmt.Printf("Listening on port %d\n", port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", port), router))
}
