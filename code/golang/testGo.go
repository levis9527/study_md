package main

import "fmt"
import "time"

func main(){
	
	fmt.Println(time.Now())
	ch := make(chan int)

	go ss(ch)

	fmt.Println(<- ch)
	fmt.Print(123)
}

func ss(ch chan int) string{
	time.Sleep(5 * time.Second)
	fmt.Println("ss()")
	ch <- 10010
	return "ss"
}