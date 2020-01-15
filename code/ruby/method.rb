#!/usr/bin/ruby
# ruby的方法与其他语言的函数差不多，使用关键字def定义，最好使用小写字母开头定义

# 可以匹配任何调用错误的方法，为找到方法会走这个逻辑，然后里面判断怎么执行，可以让代码更灵活
# def method_missing(meth, *args, &blk)
# 	m = meth.to_s
# 	if m.start_with?("hello")
# 		puts "hello #{args}, #{blk}"
# 	else
# 		puts "方法错误#{m}#{blk}"
# 		super
# 	end
# end

# 方法可以给默认值，如果给了默认值，调用时最好指定参数名，不然可能造成混乱
def say_hello(name1="未传名字", age)
	puts "hello #{name1}, age #{age}"
end
say_hello(456, 123)
# 和很多脚本语言类似，可以返回多个数据，语法也类似，返回的是数组
def swap_num(a, b)
	return b, a
end
res = swap_num 1, 3
puts "res = #{res}"

def sample(*test)
	puts "The number of param is #{test.length}"
	for par in test
		puts par
	end
end
sample(1, 2, 3, 1)

class Accounts
	def show
		puts "show"
	end
	# 类方法
	def Accounts.hello
		puts "Accounts.hello"
	end
end
# 类方法不需要也不能实例化变量访问，直接使用类名访问
Accounts.hello
Accounts.new.show
# 最常用的全局变量，用户调用脚本输入的值
puts $*

# alias语句，别名，给方法，变量或者类重新取一个短小的名字，但是内置变量使用alias可能出现严重的问题
alias s sample
s(1, 2)
# undef取消方法定义，取消之后就不能调用这个方法了，小心使用，但是alias设置的别名依然可以访问
undef sample

# ruby中的代码块
def block()
	puts "block()"
	# yield会调让方法再次调用一下代码块，代码块是和方法绑定的
	yield 3, 4 # yield可以携带多个参数，灵活使用
end
# 代码块定义之后会默认调用一下
block{ 
	|k, v|
	puts "block1, value is #{k+v}"
}
# 最简单的代码块
def test
  yield
end
test{ puts "Hello world test1"}

# 最后一个参数前带有&表示该方法接收一个代码块，使用.call来运行该代码块
def test(&block)
   block.call
end
test { puts "Hello World!"} # 只能不带括号调用该方法




