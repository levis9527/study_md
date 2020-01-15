# require语句，使用require语句导入其他模块
$LOAD_PATH << "."
require "module"

# 不想使用$LOAD_PATH << "."指定搜索路径可以用下面这种方式指定相对迷路引入
# require_relative "./module"

puts Tring.sin(3)

class Decade
# include之后可以使用该模块里面的方法，include之前必须require相关文件
# 因为include之前必须require，所以能include也就能本文件随意调用该模块了
include Week
	no_of_year = 10
	def no_of_month
		# puts "#{Week::FIRST_DAY}"
		# include模块之后，就可以直接调用模块的方法或者属性了而不需要指定模块名
		aaa # 调用模块中的非静态方法
		puts "#{FIRST_DAY}"
		number = 10 * 12
		puts 12
	end
end
d1 = Decade.new
puts Week::FIRST_DAY
d1.aaa # 类似继承，使类对象也能调用模块中定义的方法

# include可以做成类似继承的功能，可以做到多重继承，类似组合但是有不是组合，ruby叫这个Mixins
