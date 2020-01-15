#!/usr/bin/ruby
# 字符串内建方法，ruby中的字符串
class Obj
	def hi
		puts "hi"
	end
end
obj = Obj.new

# 字符串的内建方法
myStr = String.new("HEllo")
puts myStr
puts myStr.downcase
puts myStr.upcase
puts "abcbcd" =~ /bc/ # 正则匹配字符串，返回第一次出现的位置，否则返回nil
puts "aaa%dww%s" % [32, 45] # 格式化字符串，后面如果不止一个参数必须使用数组
puts myStr << "obj" # 连接对象与字符串，与+号类似
puts "ab" <=> "b" # 返回-1，字符串相比较
puts myStr.capitalize # 字符串首字母大写，不改变字符串本身
puts myStr.capitalize!# 字符串首字母大写，并且会改变字符串本身
puts myStr.chomp # 去掉字符串尾部空格
puts "  hhh\n".chomp! # 同上，并且改变字符串
puts "myStr".chop # 去掉最后一个字符
puts "123456".crypt("24") # 单向加密哈希，参数为2个字符，短了报错，长了只取前2位，取值范围a.z、 A.Z、 0.9、 . 或 /

# 遍历连续值，以 str 开始，以 other_str 结束（包含），轮流传递每个值给 block。String#succ 方法用于生成每个值。
# "1".upto("10") { |n| puts n } # str.upto(other_str) { |s| block }

puts "12.8".to_i # 返回int，非合法int返回0
puts "a12".to_f # 返回浮点数12.0，不合法返回0.0
puts "abcd".tr("b", "1") # 字符串替换
puts "abcd".tr!("b", "1") # 字符串替换，并且改变原对象
puts "abcd".sum # 所有字符二进制值加起来
puts "abc".next # 返回str下一个值abd
puts "1234".reverse # 返回4321
puts "1234".length # 字符长度
# 其他api参考文档