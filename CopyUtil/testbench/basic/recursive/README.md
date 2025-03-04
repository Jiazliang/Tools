# 递归复制测试说明

此目录用于测试CopyUtil的递归复制功能，包含以下测试场景：

1. 多层目录结构
2. 不同类型的文件
3. 空目录
4. 隐藏文件
5. 只读文件

## 目录结构
```
recursive/
├── level1/
│   ├── level2/
│   │   └── test.txt
│   ├── empty/
│   └── data.bin
├── .hidden
└── readonly.txt
```

## 测试文件说明

- test.txt: 普通文本文件
- data.bin: 二进制数据文件
- .hidden: 隐藏文件
- readonly.txt: 只读文件
- empty/: 空目录