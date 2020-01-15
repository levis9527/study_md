#!/usr/bin/ruby
# ruby的条件判断语句

# 语法
a = 6
if a > 5
	puts "a>5"
elsif a < 5
	puts "a<5"
else
	puts "other"
end
# 如果要在一行内写完表达式，带上then，不是一行写完就可以不带
if a == 5 then puts "a == 5" else puts "a != 5" end

# ruby的if修饰符，类似于sql的后置条件判断，打印***如果***，符合人类语法
puts "a == 6" if a == 5
$debug = 1 # 这里可以采用简写，做个标记，因为ruby里面nil 0这些值在条件判断里和false表现形式一样
puts "debug" if $debug

# unless和if相反，比较少使用，可以作为修饰符使用，但是不如if使用可读性好
b = 3
unless b > 2
	puts "b 不大于 2"
else
	puts "b 大于 2"
end

# case语句，类似switch case语句，如果要一行写完，when 4 then puts a end
c = 5
case c when 4 then puts "c4" when 5 then puts "c5" end # 一行写完表达式版本
case c
when 4
	puts "c === 4"
when 5
	puts "c === 5"
end
# example，根据年龄判断是什么人
age = 2
case age
when 0..2
	puts "婴儿"
when 3..6
	puts "小学生"
when 7..12
	puts "中学生"
else
	puts "其他年龄"
end

