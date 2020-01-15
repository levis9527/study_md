#!/usr/bin/ruby
# ruby中的迭代器以及文件操作

map = Hash["a", 1, "b", 2]
# each迭代，必须要end，不写一行do可以省
map.each do |k,v|
	puts "key is #{k}, v is #{v}"
end

# 同样迭代，使用collect更简洁
map.collect { |k, v| puts "key is #{k}, v is #{v}" }

# 使用collect遍历数据赋值给另一个数组
arr = [1, 2, 3]
arr2 = arr.collect { |i| i * 10 }
puts "#{arr2}"

puts "-------------ruby中的文件操作--------------"
# puts处理输出，gets处理输入
# val = gets
# puts val
putc "He" # putc只会输出第一个字符