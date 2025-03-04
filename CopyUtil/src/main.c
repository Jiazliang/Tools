/* Main program file for CopyUtil | CopyUtil 主程序文件 */

#include <stdio.h>
#include <stdlib.h>
#include "copyutil.h"

/* Main function | 主函数 */
int main(int argc, char* argv[]) {
    CopyOptions options;
    CopyStats stats = {0}; /* Initialize all stats to 0 | 初始化所有统计数据为0 */

    /* Display startup message | 显示启动信息 */
    printf("CopyUtil - File Copy Utility\n");
    printf("Version 1.0\n\n");

    /* Parse command line arguments | 解析命令行参数 */
    if (!parse_arguments(argc, argv, &options)) {
        printf("Usage: copyutil -s <source_dir> -d <dest_dir> -p <pattern> [-nr] [-nf]\n");
        printf("Options:\n");
        printf("  -s : Source directory path\n");
        printf("  -d : Destination directory path\n");
        printf("  -p : File matching pattern\n");
        printf("  -nr: Do not traverse subdirectories recursively\n");
        printf("  -nf: Do not force overwrite existing files\n");
        return EXIT_FAILURE;
    }

    /* Match and copy files | 匹配并复制文件 */
    if (!match_files(&options, &stats)) {
        display_error("Failed to process files");
        return EXIT_FAILURE;
    }

    /* Display final statistics | 显示最终统计信息 */
    printf("\nOperation completed:\n");
    printf("Total files processed: %d\n", stats.total_files);
    printf("Successfully copied: %d\n", stats.success_count);
    printf("Failed: %d\n", stats.fail_count);
    printf("Files overwritten: %d\n", stats.overwrite_count);
    printf("Directories processed: %d\n", stats.dir_count);

    return EXIT_SUCCESS;
}