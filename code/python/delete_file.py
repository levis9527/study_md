import os

m = {}

file_dir = "d:\\test_cmder\\"

# 删除文件
def delete_file(f_name):
	print(f_name)
	os.remove(file_dir + f_name)


# 存放所有头像文件名的文本文件，读取文件写入map m
with open("d://head_list.txt") as f:
	while True:
		line = f.readline()
		if not line:
			break
		m[line.strip()] = 1

# 遍历目标文件夹，如果map里面有就保留，没有就删除
file_list = os.listdir(file_dir)
for f_name in file_list:
	exists = m.get(f_name)
	if not exists:
		delete_file(f_name)


print("over")