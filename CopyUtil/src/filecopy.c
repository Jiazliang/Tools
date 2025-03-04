/* File copy module | 文件复制模块 */

#include <stdio.h>
#include <windows.h>
#include <tchar.h>
#include "copyutil.h"

#define BUFFER_SIZE 8192

/* Copy file with progress display | 复制文件并显示进度 */
bool copy_file(const char* src, const char* dest, bool overwrite) {
    HANDLE src_handle, dest_handle;
    DWORD bytes_read, bytes_written;
    char buffer[BUFFER_SIZE];
    bool success = true;
    DWORD file_attributes;

    /* Convert paths to wide characters | 转换路径为宽字符 */
    WCHAR wsrc[MAX_PATH];
    MultiByteToWideChar(CP_UTF8, 0, src, -1, wsrc, MAX_PATH);

    /* Open source file | 打开源文件 */
    src_handle = CreateFileW(wsrc, GENERIC_READ, FILE_SHARE_READ,
                          NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (src_handle == INVALID_HANDLE_VALUE) {
        display_error("Failed to open source file");
        return false;
    }

    /* Get source file attributes | 获取源文件属性 */
    file_attributes = GetFileAttributesW(wsrc);
    if (file_attributes == INVALID_FILE_ATTRIBUTES) {
        CloseHandle(src_handle);
        display_error("Failed to get file attributes");
        return false;
    }

    /* Convert destination path to wide characters | 转换目标路径为宽字符 */
    WCHAR wdest[MAX_PATH];
    MultiByteToWideChar(CP_UTF8, 0, dest, -1, wdest, MAX_PATH);

    /* Create or open destination file | 创建或打开目标文件 */
    dest_handle = CreateFileW(wdest, GENERIC_WRITE, 0, NULL,
                           overwrite ? CREATE_ALWAYS : CREATE_NEW,
                           file_attributes, NULL);
    if (dest_handle == INVALID_HANDLE_VALUE) {
        CloseHandle(src_handle);
        display_error("Failed to create destination file");
        return false;
    }

    /* Copy file content | 复制文件内容 */
    while (ReadFile(src_handle, buffer, BUFFER_SIZE, &bytes_read, NULL)
           && bytes_read > 0) {
        if (!WriteFile(dest_handle, buffer, bytes_read, &bytes_written, NULL)
            || bytes_written != bytes_read) {
            display_error("Failed to write to destination file");
            success = false;
            break;
        }
    }

    /* Close handles | 关闭句柄 */
    CloseHandle(src_handle);
    CloseHandle(dest_handle);

    /* Set file attributes | 设置文件属性 */
    if (success && !SetFileAttributesW(wdest, file_attributes)) {
        display_error("Failed to set file attributes");
        success = false;
    }

    return success;
}