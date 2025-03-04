/* Progress display module | 进度显示模块 */

#include <stdio.h>
#include "copyutil.h"

/* Update and display progress | 更新并显示进度 */
void update_progress(const char* current_file, const CopyStats* stats) {
    /* Clear current line | 清除当前行 */
    printf("\r                                                                               \r");

    /* Display current file and statistics | 显示当前文件和统计信息 */
    printf("Copying: %s\n", current_file);
    printf("Progress: %d files processed (%d successful, %d failed, %d overwritten)\r",
           stats->total_files,
           stats->success_count,
           stats->fail_count,
           stats->overwrite_count);

    /* Flush output | 刷新输出 */
    fflush(stdout);
}