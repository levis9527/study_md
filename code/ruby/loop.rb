#!/usr/bin/ruby
# 循环迭代

a = 0
while a < 3
	a += 1
	puts a
end
# 一行内写法
while a < 5 do a += 1 end

# while 修饰符
$b = 0
$b += 1 while $b < 10
puts $b

# 类似do while循环的结构
i, num = 0, 5
begin
	puts "在循环语句中 i = #{i}"
	i += 1
end while i < num

# 与while相反，没啥好介绍的，差不多，逻辑相反就对了，下面省略
c = 1
until c > 2
	puts "until c = #{c}"
	c += 1
end

# for in循环
for j in 0..5
	if j > 2
		break # break跳出循环
	end
	puts "j 的值为#{j}"

end
# 等价于each循环
(0..5).each do |v|
	puts "show"
	if v > 2
		next # 类似其他语言的continue
	end
	puts "v 的值为#{v}"
end

# redo语句表示重新开始循环，大多数情况下会进入死循环，谨慎使用
# for i in 0..5
#    if i < 2 then
#       puts "局部变量的值为 #{i}"
#       redo
#    end
# end

j = 0
begin
	puts 6/j
rescue Exception => e
	puts e
	j = 2
	retry # 异常处理后重新执行代码段，但是处理不善会进入死循环
end


