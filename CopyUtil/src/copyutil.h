/* Main header file for CopyUtil | CopyUtil 主头文件 */

#ifndef COPYUTIL_H
#define COPYUTIL_H

#include <stdbool.h>

/* Command line arguments structure | 命令行参数结构 */
typedef struct {
    char* source_dir;      /* Source directory path | 源目录路径 */
    char* dest_dir;        /* Destination directory path | 目标目录路径 */
    char* pattern;         /* File matching pattern | 文件匹配模式 */
    bool recursive;        /* Recursive directory traversal flag | 递归遍历标志 */
    bool force_overwrite;  /* Force overwrite flag | 强制覆盖标志 */
} CopyOptions;

/* Statistics structure | 统计信息结构 */
typedef struct {
    int total_files;      /* Total files processed | 处理的总文件数 */
    int success_count;    /* Successfully copied files | 成功复制的文件数 */
    int fail_count;       /* Failed copy operations | 失败的复制操作数 */
    int overwrite_count;  /* Overwritten files | 覆盖的文件数 */
    int dir_count;        /* Processed directories | 处理的目录数 */
} CopyStats;

/* Function declarations | 函数声明 */

/* Parse command line arguments | 解析命令行参数 */
bool parse_arguments(int argc, char* argv[], CopyOptions* options);

/* Match files according to pattern | 根据模式匹配文件 */
bool match_files(const CopyOptions* options, CopyStats* stats);

/* Copy file with progress display | 复制文件并显示进度 */
bool copy_file(const char* src, const char* dest, bool overwrite);

/* Display error message | 显示错误信息 */
void display_error(const char* message);

/* Update and display progress | 更新并显示进度 */
void update_progress(const char* current_file, const CopyStats* stats);

#endif /* COPYUTIL_H */