/* Error handling module | 错误处理模块 */

#include <stdio.h>
#include <windows.h>
#include "copyutil.h"

/* Display error message | 显示错误信息 */
void display_error(const char* message) {
    DWORD error_code = GetLastError();
    char system_message[256];
    DWORD msg_len;

    /* Get system error message | 获取系统错误信息 */
    msg_len = FormatMessage(
        FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
        NULL,
        error_code,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        system_message,
        sizeof(system_message),
        NULL
    );

    /* Remove trailing newline and carriage return | 移除尾部的换行和回车 */
    if (msg_len > 0) {
        while (msg_len > 0 && (system_message[msg_len-1] == '\n' ||
               system_message[msg_len-1] == '\r')) {
            system_message[--msg_len] = '\0';
        }
    }

    /* Display error message | 显示错误信息 */
    if (error_code != 0 && msg_len > 0) {
        fprintf(stderr, "Error: %s\nSystem error: %s (code: %lu)\n",
                message, system_message, error_code);
    } else {
        fprintf(stderr, "Error: %s\n", message);
    }
}