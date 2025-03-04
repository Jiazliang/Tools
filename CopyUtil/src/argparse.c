/* Command line argument parsing module | 命令行参数解析模块 */

#include <stdio.h>
#include <string.h>
#include "copyutil.h"

/* Parse command line arguments | 解析命令行参数 */
bool parse_arguments(int argc, char* argv[], CopyOptions* options) {
    if (argc < 7 || !options) {
        return false;
    }

    /* Initialize default values | 初始化默认值 */
    options->source_dir = NULL;
    options->dest_dir = NULL;
    options->pattern = NULL;
    options->recursive = true;        /* Default to recursive | 默认递归 */
    options->force_overwrite = true;  /* Default to force overwrite | 默认强制覆盖 */

    /* Parse arguments | 解析参数 */
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-s") == 0 && i + 1 < argc) {
            options->source_dir = argv[++i];
        }
        else if (strcmp(argv[i], "-d") == 0 && i + 1 < argc) {
            options->dest_dir = argv[++i];
        }
        else if (strcmp(argv[i], "-p") == 0 && i + 1 < argc) {
            options->pattern = argv[++i];
        }
        else if (strcmp(argv[i], "-nr") == 0) {
            options->recursive = false;
        }
        else if (strcmp(argv[i], "-nf") == 0) {
            options->force_overwrite = false;
        }
    }

    /* Validate required arguments | 验证必需参数 */
    if (!options->source_dir || !options->dest_dir || !options->pattern) {
        return false;
    }

    return true;
}