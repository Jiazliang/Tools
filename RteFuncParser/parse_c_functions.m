% MATLAB 脚本：解析 C 文件并提取 FUNC 函数体
% MATLAB Script: Parse C file and extract FUNC function bodies

% C 文件路径 | C file path
cFilePath = 'c:\Users\Jiaz\Desktop\Code\practice\Rte_Core0_QM.c';

% 检查文件是否存在 | Check if the file exists
if ~isfile(cFilePath)
    error('指定的 C 文件不存在: %s | Specified C file does not exist: %s', cFilePath);
end

% 读取 C 文件内容 | Read C file content
try
    content = fileread(cFilePath);
catch ME
    error('无法读取 C 文件: %s\n错误信息: %s | Cannot read C file: %s\nError message: %s', cFilePath, ME.message);
end

% 使用单一正则表达式匹配整个 FUNC 函数体，假设最外层花括号在行首
% Use a single regex to match the entire FUNC function body, assuming outermost braces are at line start


% 正则表达式模式分解 | Regular Expression Pattern Breakdown
% FUNC宏匹配：\s*允许任意空白，\([^)]*\)匹配宏参数
% FUNC macro matching: \s* allows any whitespace, \([^)]*\) matches macro arguments
% (?<name>\w+) 命名捕获组：提取函数名 | Named group for function name extraction
% \s*\(.*?\n 匹配参数列表：非贪婪模式直到换行前 | Matches parameter list with non-greedy mode until newline
% \{(?<body>.*?)\n\} 捕获函数体：非贪婪匹配直到单独花括号 | Captures function body with non-greedy match until closing brace
% 特殊说明：\n确保花括号单独成行，.*?使用DOTALL模式
% Special notes: \n ensures brace isolation, .*? requires 'dotall' mode
pattern = 'FUNC\s*\([^)]*\)\s*(?<name>\w+)\s*\(.*?\n\{(?<body>.*?)\n\}';

% 使用 'names' 选项提取捕获的组 (函数名和函数体) | Use 'names' option to extract captured groups (function name and body)
tokens = regexp(content, pattern, 'names');

% 检查提取结果 | Check extraction results
if ~isempty(tokens)
    disp('提取到的函数名和函数体：| Extracted function names and bodies:');
    for k = 1:length(tokens)
        % 检查结构体是否包含预期的字段 | Check if the struct contains expected fields
        if isfield(tokens(k), 'name') && isfield(tokens(k), 'body')
            fprintf('--- 函数 %d ---\n', k);
            % 使用点表示法访问结构体字段 | Use dot notation to access struct fields
            fprintf('名称 | Name: %s\n', tokens(k).name);
            fprintf('函数体 | Body:\n%s\n', strtrim(tokens(k).body));
        else
            fprintf('警告：函数 %d 的匹配结果不完整。 | Warning: Match result for function %d is incomplete.\n', k);
        end
    end
else
    disp('未找到符合条件的 FUNC 函数。 | No matching FUNC functions found.');
end