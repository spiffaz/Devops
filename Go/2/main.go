package main

import (
	"fmt"
	"log"
	"encoding/json"
	"math/rand"
	"net/http"
	"strconv"
	"github.com/gorilla/mux"
)

type Movie struct {
	ID			string 		`json:"id`
	Isbn		string 		`json:"isbn`
	Title		string 		`json:"title`
	Director	*Director 	`json:"director` //a pointer to the director struct
}

type Director struct {
	Firstname 	string 	`json:"firstname`
	Lastname 	string	`json:"lastname`
}

var movies []Movie

func getMovies (w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(movies)
}

func deleteMovie (w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)
	for index, item := range movies {
		if item.ID == params["id"] {
			movies = append(movies[:index], movies[index+1:] ...) //from the id that matches the index, we are replacing and appending the values of all subsequent indexes
			break
		}
	}
	json.NewEncoder(w).Encode(movies)
}

func getMovie (w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)
	for _, item := range movies {
		if item.ID == params["id"] {
			json.NewEncoder(w).Encode(item)
			return
		}
	}
}

func createMovie (w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var movie Movie
	_ = json.NewDecoder(r.Body).Decode(&movie) // decoding the request we received
	movie.ID = strconv.Itoa(rand.Intn(100000000)) //create a random id between 1 and 100000000 and convert to string
	movies = append(movies, movie) //appending the new variable movie to movies
	json.NewEncoder(w).Encode(movie) 
}

func updateMovies (w http.ResponseWriter, r *http.Request) {
	//set json content type
	w.Header().Set("Content-Type", "application/json") 
	params := mux.Vars(r)
	//loop over our params
	for index, item := range movies { 
		if item.ID == params["id"] {
			//delete movie (because we arent using a db). If using db this would have been an update query
			movies = append(movies[:index], movies[index+1:] ...) 
			// add the record again from what was received as input from postman
			var movie Movie
			_ = json.NewDecoder(r.Body).Decode(&movie) // decoding the request we received
			movie.ID = params["id"] //we are maintaining the id from the request
			movies = append(movies, movie) //appending the new variable movie to movies
			json.NewEncoder(w).Encode(movie) 	
			return	
		}
	}
	

}

func main() {
	r := mux.NewRouter()

	movies = append(movies, Movie{ID : "1", Isbn : "000001", Title : "Movie One", Director : &Director{Firstname: "John", Lastname: "Doe"}})
	movies = append(movies, Movie{ID : "2", Isbn : "000002", Title : "Movie Two", Director : &Director{Firstname: "Jane", Lastname: "Janet"}})

	r.HandleFunc("/movies", getMovies).Methods("GET")
	r.HandleFunc("/movies/{id}", getMovie).Methods("GET")
	r.HandleFunc("/movies", createMovie).Methods("POST")
	r.HandleFunc("/movies/{id}", updateMovies).Methods("PUT")
	r.HandleFunc("/movies/{id}", deleteMovie).Methods("DELETE")

	fmt.Printf("Starting server at port 8000\n")
	log.Fatal(http.ListenAndServe(":8000",r))

}
