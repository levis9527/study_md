#!/usr/bin/ruby
# ruby中的hash，类似其他语言的map，元组

months = Hash.new("default_months")
puts "#{months}"
puts "#{months["ok"]}" # 键不存在时返回default_months，没设置默认值不存在时返回nil

# 给hash设置默认值，这里默认值是一个表达式，表示下标，后面是赋值语句，表示默认值与键的关系
h = Hash.new { |h, k| h[k] = k * 2 }
h["hello"] = 2
puts "#{h["hello"]}"

h = {"a" => "A", "b" => "B"} # 直接定义hash，也可以使用Hash["a" => "A", "b" => "B"]或者Hash["a", "A"]
puts h

h[[1, 2]] = 666 # 数组也能做为hash的键，但是现实中一般不会使用
puts h

puts "#{h.keys}" # 返回hash里面所有的键

puts "*****************hash常用方法api*****************"
hash = Hash["a", 1, "b", 2]
# hash常用方法api
# puts hash.clear # 清空hash
puts hash.default("b") # 返回某个键的默认值，不同的键可以有不同的默认值，未设置时为nil
puts hash.empty? # 返回hash是否为空
puts "------"
puts hash.fetch("a1") { |k| k*3 } # 未找到键对应的值返回block代码块
hash.each{|k,v| puts "key is #{k}, v is #{v}"} # 遍历hash
hash.each_key{|k| puts "key is #{k}"} #遍历键
hash.each_value{|v| puts "value is #{v}"} #遍历value
puts "------"
puts hash.has_value?("value") # 是否包含某些键
puts hash.to_s # 序列化成字符串输出

# 其他api参见官方文档
# 略......
# https://ruby-doc.org/core-2.7.0/Hash.htm

