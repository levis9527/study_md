## Go程
* Go 程（goroutine）是由 Go 运行时管理的轻量级线程
* 关键字`go`, 采用`go fun(para)`开启一个go程
* 如果你不处理返回值，默认go程会丢掉返回值
## 信道

* 可以用信道隐式的实现同步，在传入chan T参数并且代码中使用<-处理参数时，会实现同步，类似于返回值
* 信道使用前必须创建`ch := make(chan int)`
* 默认情况下，发送和接收操作在另一端准备好之前都会阻塞。这使得 Go 程可以在没有显式的锁或竞态变量的情况下进行同步。
* 代码示例如下:

```

package main

import (
	"fmt"
	"time"
)

func sum(s []int, c chan int) {
	time.Sleep(1000 * time.Millisecond)
	sum := 0
	for _, v := range(s) {
		sum += v
	}
	c <- sum // 将和送入 c
}

func main() {
	s := []int{7, 2, 8, -9, 4, 0}

	c := make(chan int)
	d := make(chan int)
	go sum(s[:len(s)/2], c)
	go sum(s[len(s)/2:], d)
	var x int
	x = <-c // 从 c 中接收
	y := <-d

	fmt.Println(x, y, x+y)
	fmt.Println(s)
}
```
## 带缓冲的信道
* 信道可以是 带缓冲的。将缓冲长度作为第二个参数提供给 make 来初始化一个带缓冲的信道
* `ch := make(chan int, 100)`
* 仅当信道的缓冲区填满后，向其发送数据时才会阻塞。当缓冲区为空时，接受方会阻塞
* 带参数时为同步信道，接发消息不会阻塞，不带参数时为异步，接发消息立即阻塞
* 不带参数时接收消息或者发送消息必须开一个Go程，否则会阻塞主线程，导致主线程无法继续。

## 信道的range和close
* 发送者可以通过`close`关闭信道，接收者可以接收时多指定一个参数`v, ok := <- ch`，如果信道的值取完被关闭的话，ok会返回false
* 循环`for v := range(ch)`会一直从信道取值直到信道被关闭，简化遍历信道的操作
* 只有发送者才能关闭信道，向一个已经关闭的信道发送数据会引发程序恐慌（panic）
* 信道与文件不同，通常情况下无需关闭它们。只有在必须告诉接收者不再有需要发送的值时才有必要关闭，例如终止一个 range 循环

## 信道的select语句
* select语句使一个Go程可以等待多个通信操作
* select会阻塞到某个分支可以继续为止，这时候就会执行该分支。当多个分支都准备好时会随机选择一个执行

## 信道select的默认选择default
* 和switch case的default一样，select也拥有default
* 当select中的其他分支没有准备好的时候，就会执行default
* 示例代码，为了在尝试发送或者接受时不发生阻塞，可以使用default分支：

```
select {
case i := <-c:
    // 使用 i
default:
    // 从 c 中接收会阻塞时执行
}
```

## 等价查找二叉树注意事项
* **如果是不带参数的信道必须放在新建的协程里面**，取值和设置值不能存在于一个协程里，这点特别重要！！
* 把2个二叉树的值都写入到信道里面后，遍历一个信道时顺便取另一个信道，直到遍历完某个信道，可以用range，如果2个数大小不一样要判断是否完全一样也可以用for循环，每次取一个ok判断ok是否一样，如果ok不同表示2个信道不一样大，可以返回false
* 代码如下

```
package main

import "golang.org/x/tour/tree"
import "fmt"

func rangeTree(t *tree.Tree, ch chan int) {
	if t != nil {
		rangeTree(t.Left, ch)
		ch <- t.Value
		rangeTree(t.Right, ch)
	}
}

// Walk 步进 tree t 将所有的值从 tree 发送到 channel ch。
func Walk(t *tree.Tree, ch chan int){
	rangeTree(t, ch)
	close(ch)
	v, ok := <- ch
	fmt.Println(v, ok)
	
}

// Same 检测树 t1 和 t2 是否含有相同的值。
func Same(t1, t2 *tree.Tree) bool{
	ch1 := make(chan int)
	ch2 := make(chan int)
	go Walk(t1, ch1)
	go Walk(t2, ch2)
	//for v := range(ch1) {
		//if v != <- ch2 {
			//return false
		//}
	//}
	for {
		v1, ok1 := <-ch1
		v2, ok2 := <-ch2
		
		if ok1 != ok2 {
			return false
		}
		if v1 != v2 {
			return false
		}
		if ok1 == false && ok2 == false {
			break
		}
	}
	
	return true
}

func main() {
	fmt.Println(Same(tree.New(1), tree.New(2)))
	fmt.Println(Same(tree.New(2), tree.New(2)))
	
}
```

## sync.Mutex互斥锁
* Go标准库中提供`sync.Mutex`用来管理互斥锁
* `sync.Mutex`拥有2个方法，Lock和Unlock，用法和java的类似用于同步代码块，保证只有一个Go程能够进入执行代码块的数据，当然会有性能的损耗
* 我们可以使用`defer`语句来保证互斥锁一定会被解锁
* 声明sync.Mutex不用赋值，直接`var mux sync.Mutex`就能直接使用了，代码如下：

```
package main

import "fmt"
import "time"
import "sync"


func main() {
	var mux sync.Mutex
	
	i := 0
	for j := 0; j < 1000000; j++{
		go func(){
			//time.Sleep(10)
			defer mux.Unlock()
			mux.Lock()
			i = i+1
			//mux.Unlock()
		}()
	}
	time.Sleep(10 * time.Second)
	fmt.Print(i)
}
```

## 自我调试tips
* go同一个目录下的go文件里面不能有多个package，否则会报错`found packages ttt1 (t3.go) and ttt (ttt.go) in D:\Desktop\go_project\src\ttt\ttt`