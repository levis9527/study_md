#!/usr/bin/ruby
# -*- coding: UTF-8 -*-
# 学习class类

# 全局变量
$context_field

class HelloClass
	# ruby中变量分为局部变量，实例变量，类变量，全局变量
	# 作用域：全局>类>实例>局部
	# 类变量，类似于java中的静态变量
	@@class_static=0
	# 实例变量，类似java类中的非静态变量
	@name
	# 局部变量，方法变量，方法执行过程就是他的生命周期，方法变量
	a, _a = 0, 0

	def initialize(name)
		@name = name
	end
	# ruby的function，不需要参数时可以不包含参数，简化调用是也可以不用带括号
	def hello
		puts "hello\t#{@name}"
	end
end

# 创建对象使用new方法
# 如果没有显示的定义initialize方法，那么系统会默认有个无参方法直接ClassName.new就能创建对象
h1 = HelloClass.new("zhangsan")
h2 = HelloClass.new("lisi")

h1.hello
h2.hello
puts h1 == h2