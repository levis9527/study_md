#!/usr/bin/ruby
# ruby关于类的一些测试
# 全局变量
$g = 0

class Customer
	# 常量大写字母开头，定义了不能修改，常量不能定义在局部
	Const1 = 10086

	@@no_of_customers = 0

	# 构造方法，初始化对象
	def initialize(id, name, addr)
		@id, @name, @addr = id, name, addr
		@@no_of_customers += 1
		$g += 1
	end
	# 显示对象详细信息
	def display_datail
		puts "id is #{@id}"
		puts "name is #{@name}"
		puts "addr is #{@addr}"
	end
	# 现实创建了多少对象
	def total_customer_created
		puts "has #{@@no_of_customers} customer was created"
	end
end

class B
	def initialize()
		$g += 1
	end
	def show_global
		# 全局变量可以在所有类里面修改他的状态并且显示
		puts "#{$g}"
	end
end

# 创建对象
c1 = Customer.new(2, "jack", "beijing")
c1.total_customer_created
c2 = Customer.new(3, "jack", "beijing")

# 调用方法
c1.display_datail
c2.display_datail
c1.total_customer_created

b = B.new
b.show_global

# ruby伪变量
puts self # 当前方法的接收器对象
puts true # 代表 true 的值
puts false # 代表 false 的值
puts nil # 代表 undefined 的值
puts __FILE__ # 当前源文件的名称
puts __LINE__ # 当前行在源文件中的编号
# ruby特殊全局变量
puts $$ # 运行的当前进程，kill -9 #{$$}可以杀死自己
puts $? # 最近一个子进程的状态
# 异常和错误里的全局变量
puts $1 # 引起异常的信息
puts $@ # 完整的引起错误的栈调用信息
# 字符串和分隔符全局变量
puts $; # 表示 String.split 里的分隔符，默认是空格
puts $/ # 输入的行分隔符
puts $\ # 输出的行分隔符
# 文件操作里面的全局变量
puts $. # 文件操作里面这个表示当前读取的行号
puts $_ # 文件操作里表示最后读取的行
# 正则表达式里面的全局变量
"abc" =~ /b/
puts $~ # 返回最近一次匹配到的值
puts $& # 返回最近一次匹配到的字符串，几乎等同于$~.to_s
puts $' # 返回最后匹配部分后面的字符串，比如abc =~ /b/，$'返回c

puts $* # 最常用的全局变量，调用脚本文件时后面跟的参数，是一个数组arr


# ruby比较特殊的一些运算符
puts 1 <=> 2 # 1小于等于大于2分别返回-1，0，1
puts (0..2) === 2 # 判断2是否在区间里面
puts 1.eql?(1.0) # 返回false，但是1==1.0返回true
# ruby的equal?()比较混乱，之后再了解，暂时不管
c3 = c1
puts "c1 ==c2? #{c1==c2}"
puts "c1.equal?(c3) #{c1.equal?(c3)}"

# Ruby defined? 运算符
foo = 42
puts defined? foo # 返回local-variable
puts defined? $_ # 返回global-variable
puts defined? aa # 不存在的对象，方法，类名都返回nil
puts defined? puts # 返回method
puts defined? super # super是否可以调用
puts defined? yield # yield是否可以调用



