/* File matching module | 文件匹配模块 */

#include <stdio.h>
#include <windows.h>
#include <stdbool.h>
#include <shlwapi.h>
#include "copyutil.h"

/* Create directory recursively | 递归创建目录 */
static bool create_directory_recursive(const char* path) {
    char temp[MAX_PATH];
    const char* p = path;
    size_t len;
    
    /* Skip drive letter or UNC path prefix | 跳过驱动器号或UNC路径前缀 */
    if (strlen(path) > 2 && path[1] == ':') {
        p += 2;
    }
    
    while (*p) {
        if (*p == '\\' || *p == '/') {
            len = p - path;
            if (len > 0) {
                strncpy(temp, path, len);
                temp[len] = '\0';
                WCHAR wtemp[MAX_PATH];
                MultiByteToWideChar(CP_UTF8, 0, temp, -1, wtemp, MAX_PATH);
                if (!CreateDirectoryW(wtemp, NULL) && 
                    GetLastError() != ERROR_ALREADY_EXISTS) {
                    /* Ignore the error if directory already exists | 如果目录已存在则忽略错误 */
                    if (GetLastError() != ERROR_PATH_NOT_FOUND) {
                        return false;
                    }
                }
            }
        }
        p++;
    }
    
    /* Create the final directory | 创建最终目录 */
    WCHAR wpath[MAX_PATH];
    MultiByteToWideChar(CP_UTF8, 0, path, -1, wpath, MAX_PATH);
    if (!CreateDirectoryW(wpath, NULL) && 
        GetLastError() != ERROR_ALREADY_EXISTS) {
        return false;
    }
    
    return true;
}

/* Process single file | 处理单个文件 */
static bool process_file(const char* src_path, const char* dest_path,
                        const CopyOptions* options, CopyStats* stats) {
    stats->total_files++;

    /* Check if destination file exists | 检查目标文件是否存在 */
    WIN32_FIND_DATA dest_file_data;
    HANDLE dest_handle = FindFirstFile(dest_path, &dest_file_data);
    bool dest_exists = (dest_handle != INVALID_HANDLE_VALUE);
    if (dest_handle != INVALID_HANDLE_VALUE) {
        FindClose(dest_handle);
    }

    /* Handle overwrite case | 处理覆盖情况 */
    if (dest_exists && !options->force_overwrite) {
        return true; /* Skip file | 跳过文件 */
    }

    /* Copy file and update stats | 复制文件并更新统计信息 */
    if (copy_file(src_path, dest_path, options->force_overwrite)) {
        stats->success_count++;
        if (dest_exists) {
            stats->overwrite_count++;
        }
        update_progress(src_path, stats);
        return true;
    } else {
        stats->fail_count++;
        return false;
    }
}

/* Create directory recursively | 递归创建目录 */
static bool create_directory_recursive(const char* path);


/* Match files in directory | 匹配目录中的文件 */
static bool match_files_in_dir(const char* src_dir, const char* dest_dir,
                              const CopyOptions* options, CopyStats* stats) {
    char src_pattern[MAX_PATH];
    char src_path[MAX_PATH];
    char dest_path[MAX_PATH];
    WIN32_FIND_DATAW find_data;
    bool success = true;

    /* Create search pattern | 创建搜索模式 */
    if ((size_t)snprintf(src_pattern, sizeof(src_pattern), "%s\\*", src_dir) >= sizeof(src_pattern)) {
        display_error("Source path too long");
        return false;
    }

    /* Convert pattern to wide characters | 转换模式为宽字符 */
    WCHAR wsrc_pattern[MAX_PATH];
    MultiByteToWideChar(CP_UTF8, 0, src_pattern, -1, wsrc_pattern, MAX_PATH);

    /* Start directory enumeration | 开始目录枚举 */
    HANDLE find_handle = FindFirstFileW(wsrc_pattern, &find_data);
    if (find_handle == INVALID_HANDLE_VALUE) {
        display_error("Failed to access directory");
        return false;
    }

    do {
        /* Skip . and .. | 跳过 . 和 .. */
        if (wcscmp(find_data.cFileName, L".") == 0 ||
            wcscmp(find_data.cFileName, L"..") == 0) {
            continue;
        }

        /* Build full source path | 构建完整源路径 */
        char filename[MAX_PATH];
        WideCharToMultiByte(CP_UTF8, 0, find_data.cFileName, -1, filename, MAX_PATH, NULL, NULL);
        if (snprintf(src_path, sizeof(src_path), "%s\\%s",
                 src_dir, filename) >= (int)sizeof(src_path)) {
            display_error("Source path too long");
            FindClose(find_handle);
            return false;
        }

        /* Build full destination path | 构建完整目标路径 */
        if (snprintf(dest_path, sizeof(dest_path), "%s\\%s",
                 dest_dir, filename) >= (int)sizeof(dest_path)) {
            display_error("Destination path too long");
            FindClose(find_handle);
            return false;
        }

        if (find_data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
            /* Handle directory | 处理目录 */
            if (options->recursive) {
                stats->dir_count++;
                /* Create destination directory | 创建目标目录 */
                /* Convert destination path to wide characters | 转换目标路径为宽字符 */
                WCHAR wdest_path[MAX_PATH];
                MultiByteToWideChar(CP_UTF8, 0, dest_path, -1, wdest_path, MAX_PATH);
                CreateDirectoryW(wdest_path, NULL);
                /* Recursively process directory | 递归处理目录 */
                if (!match_files_in_dir(src_path, dest_path, options, stats)) {
                    success = false;
                }
            }
        } else {
            /* Handle file | 处理文件 */
            if (PathMatchSpecW(find_data.cFileName, L"*")) {
                WCHAR wdest_path[MAX_PATH];
                MultiByteToWideChar(CP_UTF8, 0, options->pattern, -1, wdest_path, MAX_PATH);
                if (PathMatchSpecW(find_data.cFileName, wdest_path)) {
                    if (!process_file(src_path, dest_path, options, stats)) {
                        success = false;
                    }
                }
            }
        }
    } while (FindNextFileW(find_handle, &find_data));

    FindClose(find_handle);
    return success;
}

/* Match files according to pattern | 根据模式匹配文件 */
bool match_files(const CopyOptions* options, CopyStats* stats) {
    /* Create destination directory if it doesn't exist | 如果目标目录不存在则创建 */
    if (!create_directory_recursive(options->dest_dir)) {
        display_error("Failed to create destination directory");
        return false;
    }

    return match_files_in_dir(options->source_dir, options->dest_dir, options, stats);
}