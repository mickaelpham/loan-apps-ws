package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/loan", loanHandler)
	log.Println("Server is ready to serve request at 0.0.0.0:80")
	log.Fatal(http.ListenAndServe("0.0.0.0:80", nil))
}

type loanRequest struct {
	CreditScore int `json:"creditScore"`
	Amount      int `json:"amount"`
}

type loanResponse struct {
	Accepted     bool    `json:"accepted"`
	InterestRate float64 `json:"interestRate"`
}

func loanHandler(w http.ResponseWriter, req *http.Request) {
	if req.Method != "POST" {
		http.Error(w, "", http.StatusNotFound)
		return
	}

	var loanRequest loanRequest

	err := json.NewDecoder(req.Body).Decode(&loanRequest)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	fmt.Println("Received a loan request for", loanRequest.Amount, "and a credit score of", loanRequest.CreditScore)

	interestRate := float64(loanRequest.CreditScore) / 10_000
	fmt.Println("Decided on a base interest rate of", interestRate)

	if loanRequest.Amount > 1000 {
		interestRate *= 5
		fmt.Println("Since the amount is greather than $1,000 we are raising the interests")
	}

	response := loanResponse{
		Accepted:     true,
		InterestRate: interestRate,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}
