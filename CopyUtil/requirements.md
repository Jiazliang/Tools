# CopyUtil 工具设计需求文档

## 1. 项目概述
开发一个基于命令行的文件复制工具，用于在 Windows 系统下将符合特定模式的文件从源目录复制到目标目录。默认会递归遍历所有子目录，并强制覆盖目标位置的同名文件。

## 2. 功能需求

### 2.1 基本功能
- 支持通过命令行参数指定源目录和目标目录
- 支持通过通配符模式匹配文件
- 默认递归遍历源目录及其所有子目录
- 默认强制覆盖目标位置的同名文件
- 支持文件复制操作
- 支持显示复制进度和结果

### 2.2 命令行格式
```plaintext
copyutil.exe -s <源目录> -d <目标目录> -p <文件匹配模式>
参数说明：

- -s : 指定源目录路径
- -d : 指定目标目录路径
- -p : 指定文件匹配模式
- -nr : （可选）不递归遍历子目录
- -nf : （可选）不强制覆盖已存在的文件
示例：

```plaintext
copyutil.exe -s C:\source -d D:\target -p *.c
 ```

### 2.3 可选功能扩展
建议后续添加的可选参数：

- -v : 显示详细信息
- -h : 显示帮助信息
- -b : 复制前备份已存在的文件
## 3. 技术需求
### 3.1 开发环境
- 编程语言：C语言
- 操作系统：Windows
- 编译器：使用MinGW-w64
### 3.2 核心功能模块
1. 参数解析模块
   
   - 解析命令行参数
   - 验证参数完整性和有效性
   - 支持短参数和长参数形式
2. 文件匹配模块
   
   - 支持 Windows 文件通配符
   - 默认递归遍历源目录及其子目录
   - 匹配符合模式的文件
   - 维护目录结构
3. 文件复制模块
   
   - 在目标位置创建相应的目录结构
   - 检查目标文件是否存在
   - 执行文件复制（默认覆盖）
   - 保持原文件属性
   - 保持源目录的层级结构
4. 错误处理模块
   
   - 处理文件访问权限错误
   - 处理磁盘空间不足错误
   - 处理路径无效错误
   - 处理文件占用错误
5. 进度显示模块
   
   - 显示当前复制的文件名及其相对路径
   - 显示复制进度
   - 显示操作结果统计
   - 显示覆盖文件的统计信息
### 3.3 代码规范
1. 注释要求
   
   - 采用 /* English | 中文 */ 的双语注释格式
   - 注释单独成行
   - 关键功能必须有注释说明
2. 错误处理
   
   - 所有系统调用都需要错误检查
   - 提供清晰的错误信息输出
## 4. 输出要求
### 4.1 正常输出
- 显示程序启动信息
- 显示当前正在复制的文件名和路径
- 显示覆盖文件的信息
- 显示复制完成的统计信息（总文件数、成功数、失败数、覆盖数）
- 显示处理的目录数量
### 4.2 错误输出
- 参数错误提示
- 文件操作错误提示
- 系统错误提示
## 5. 注意事项
- 确保源目录和目标目录路径的有效性
- 处理文件名中的特殊字符
- 考虑大文件复制的性能优化
- 确保程序在复制过程中的稳定性
- 正确处理目录层级结构
- 正确处理文件覆盖操作
- 提供友好的用户提示信息
## 6. 后续扩展建议
- 支持更复杂的正则表达式匹配
- 添加复制速度显示
- 支持断点续传
- 添加文件校验功能
- 支持并行复制以提高性能
- 添加进度条显示
- 添加文件备份功能