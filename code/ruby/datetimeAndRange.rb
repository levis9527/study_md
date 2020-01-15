#!/usr/bin/ruby
# ruby的日期时间类和范围

time = Time.new # 当前时间，等同于Time.now
puts time
puts time.year # 年
puts time.month # 月
puts time.day # 日
puts time.wday # 周几，周日为0
puts time.hour%12 # 小时，24小时制

puts Time.local(2012,12,12,0,21,21) # 指定时间初始化
puts "------"
puts "#{time.to_a}"

puts "ruby中的范围--------"
# ruby中的范围
puts "#{(1...5).to_a}" # 范围2个点包头包尾，3个点包头不保尾
# 范围做为条件
score = 70
result = case score
when 0..40
	"糟糕的分数"
when 41..60
	"快要及格"
when 61..70
	"及格分数"
when 71..100
   	"良好分数"
else
	"错误的分数"
end
puts result
# 范围判断必须使用===
puts (0...5) === 4
