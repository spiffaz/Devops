package main

import (
	"fmt"
	"log"
	"net/http" //this processes http requests
)

func formHandler (w http.ResponseWriter, r *http.Request){
	//return error if there is an error returned
	if err := r.ParseForm(); err!= nil {
		fmt.Fprintf(w, "Parseform(), err: %v", err)
		return
	}
	fmt.Fprintf(w, "POST request successful")
	name := r.FormValue("name")
	address := r.FormValue("address")
	fmt.Fprintf(w, "Name = %s\n", name)
	fmt.Fprintf(w, "Address = %s\n", address)
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	//return a 404 error if the path for some reason is not /hello
	if r.URL.Path != "/hello"{
		http.Error(w, "404 not found", http.StatusNotFound)
		return
	}
	//return an error if the method is not get
	if r.Method != "GET"{
		http.Error(w, "method is not supported", http.StatusNotFound)
		return
	}
	fmt.Fprintf(w, "hello!")
}

func main(){
	fileServer := http.FileServer(http.Dir("./static")) //telling golang to check the static directory
	http.Handle("/",fileServer) //telling go to route requests to the fileserver firectory
	http.HandleFunc("/form",formHandler)
	http.HandleFunc("/hello",helloHandler)

	fmt.Printf("Starting server at port 8070\n")
	if err := http.ListenAndServe(":8070",nil); err !=nil {
		log.Fatal(err)
	}
}
