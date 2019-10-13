
	aria2配置文件名要求：aria2.conf
	aria2c主程序文件名：aria2c.exe（如果为其它，你需要更改run0.bat、run1.bat）

	aria2-trackers-update.exe 自动更新bt-tracker字段主程序
	run0.bat 运行前要执行的命令（比如 关闭aria2c）
	run1.bat 运行后要执行的命令（比如 启动aria2c）

1. 将所有文件放入Aria2配置文件（aria2.conf）所在文件夹下,运行aria2-trackers-update.exe即可

2. 默认任务计划从 0点开始 每隔8小时运行一次 如果需要更改原计划请在run1.bat里添加任务计划命令 任务名为aria2将覆盖原计划

3. 程序运行没有任何提示，可以打开aria2.conf查看“bt-trasker”字段是否更新成功。