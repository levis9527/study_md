#!/usr/bin/ruby
# ruby模块

# 模块module定义了一个命名空间，类似一个沙盒，里面方法和常量与其他地方不会冲突
# 模块与类的区别
# 1. 模块不能被实例化
# 2. 模块没有子类
# 3. 模块只能被另一个模块定义
module Tring
	PI = 3.141592653
	def Tring.show_PI
		puts PI
	end
	def Tring.sin(x)
		return "sin(#{x})"
	end
	# 因为模块不能实例化，所以里面的方法不能被外部调用，一般没有意义
	def aa
		puts "aaaaaaaa"
	end
end

def main
	Tring.show_PI
	puts Tring::PI
	puts Tring.sin(3)
end

module Week
	FIRST_DAY = "Sunday"
	def Week.weeks_in_month
		puts "you have 4 weeks in a month"
	end
	def aaa
		puts "aaa11"
	end
end




