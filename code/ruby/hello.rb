#!/usr/bin/ruby
# -*- coding: UTF-8 -*-

# 开始时调用
BEGIN {
	puts 123
}
# 结束时调用
END {
	puts "END"
}

# 打印基础类型
puts "你好世界"; # 打印字符串
puts 234 # 打印数字
puts 2**10 # 指数运算
puts 0xFF # 十六进制255
puts 2 ** 1.5 * 2.828 # 非整数指数

# 数组
b = [1, 1, 2, 3]
puts "b[0] is #{b[0]}"
b += [4] # 数组相加，结果为[1，1， 2，3， 4]
b -= [1] # 数组相减，结果为[2， 3， 4]，注：所有同样的元素都去掉，2个1都减掉
b << "1" # 通过<< 向数组添加元素
puts "b is #{b * 3}" # 数组乘法，表示数组重复次数
arr1, arr2 = [1, 2, 3, 3], [3, 4, 5]
puts "#{arr1|arr2}" # 并集结果[1, 2, 3, 4, 5]
puts "#{arr1&arr2}" # 交集结果[3]
puts "#{[1,2,3,4,1] | []}" # 和空数组并集可以达到去重的效果
# 数组遍历
arr = ["fred", 10, 3.14]
arr.each do |v|
	puts "value is #{v}"
end

# hash类型
hsh = {"name" => "zhangsan", "age" => 20} # hash键只能为字符串，通过=>表示对应关系，都好分隔不同属性
puts "#{hsh}"
# hash遍历
hsh.each do |k, v|
	puts "key is #{k}, value is #{v}"
end
puts "aa#{hsh["name1"]}bbb"  # 获取键的值（键不存在返回nil，在if条件里面为false）

# 范围类型，范围类型表示一个区间
(0...10).each do |v| # 注意，(0..2)表示0,1,2，而(0...2)表示0,1，2个点包括头尾，3个点包头不包尾
	puts "#{v}"
end