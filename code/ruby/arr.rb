#!/usr/bin/ruby
# ruby中的数组

# 创建数组
arr = Array.new
arr = Array.new(3)
puts arr.size # 数组大小，等同于arr.length

# 初始化给默认值，不设置默认值默认为nil
arr = Array.new(3, "default")
puts "#{arr}"
# 使用计算模式填充数组
nums = Array.new(10) {|n| n = n * 2}
puts "#{nums}"
# 显示的给所有值初始化
nums = Array[1, 2, 3, 4]
puts "#{nums}"
# 通过范围初始化
nums = Array(11...15)
puts "#{nums}"

# 数组内建方法
puts nums.at(3) # 查询下标，等同于nums[3]，不存才返回nil
puts "#{[1,2] & [2,3]}" # 数组并集，| 用来取数组并集
puts "#{[1,2,3] << 4}" # 数组追加元素
puts "#{[1, 2] <=> [2, 5]}" # 逐个元素比较大小，相同就下一个
puts "#{[1,2,3].reverse}" # 数组逆序


# 其他api参考官方文档
# 略......
