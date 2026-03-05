import os
import re

def _write_file_to_output(file_path, output_handle):
    """
    辅助函数，用于将单个文件的内容写入到输出文件。
    Helper function to write a single file's content to the output handle.
    """
    # 从完整路径中获取文件名
    # Get the file name from the full path
    file_name = os.path.basename(file_path)

    # 跳过隐藏文件，例如 .DS_Store
    # Skip hidden files like .DS_Store
    if file_name.startswith('.'):
        return

    try:
        # 打开并读取源文件
        # Open and read the source file
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as file:
            # 写入一个清晰的标题，包含完整文件路径，以便更好地了解上下文
            # Write a clear header with the full file path for better context
            output_handle.write(f"--- File: {file_path} ---\n")
            
            # 提取文件扩展名用于 markdown 代码块
            # Extract the file extension for markdown code block
            file_extension = os.path.splitext(file_name)[1].lstrip('.')
            
            # 将内容写入 markdown 代码块中
            # Write the content inside a markdown code block
            output_handle.write(f"```{file_extension}\n")
            output_handle.write(file.read())
            output_handle.write('\n```\n\n')
            print(f"Processed: {file_path}") # 打印进度 / Print progress
    except Exception as e:
        # 如果文件无法处理，则打印错误信息
        # Print an error message if a file cannot be processed
        print(f"Error processing file: {file_path} - {e}")

def natural_sort_key(s):
    """
    生成自然排序的键值，使 'Chapter_2' 排在 'Chapter_10' 之前。
    Generates a key for natural sorting (e.g., Chapter_2 before Chapter_10).
    """
    # 将字符串拆分为数字和非数字部分
    # Split string into numeric and non-numeric parts
    # 如果是数字字符串，转换为整数进行比较，否则转为小写比较
    # Convert numeric strings to integers for comparison, keep others as lowercase strings
    return [int(text) if text.isdigit() else text.lower() for text in re.split(r'(\d+)', s)]

def consolidate_files(input_paths, output_file, prompt=None):
    """
    将来自文件和/或目录列表的内容合并到单个输出文件中。
    Consolidates content from a list of files and/or directories into a single output file.

    :param input_paths: 一个包含文件和/或目录路径的列表 (A list of file and/or directory paths.)
    :param output_file: 合并后输出文件的路径 (The path for the consolidated output file.)
    :param prompt: 在文件开头添加的初始提示文本 (An optional initial prompt to add at the beginning of the file.)
    """
    
    # --- 第一步：收集所有文件路径 (Step 1: Collect all file paths) ---
    all_files_to_process = []

    for path in input_paths:
        # 检查路径是否存在
        if not os.path.exists(path):
            print(f"Warning: Path does not exist and will be skipped: {path}")
            continue

        if os.path.isfile(path):
            # 如果是文件，直接添加
            all_files_to_process.append(path)
        
        elif os.path.isdir(path):
            # 如果是目录，遍历所有子目录
            for root, dirs, files in os.walk(path):
                for file_name in files:
                    full_path = os.path.join(root, file_name)
                    all_files_to_process.append(full_path)
    
    # --- 第二步：自然排序 (Step 2: Natural Sort) ---
    # 使用 natural_sort_key 进行排序，正确处理文件名中的数字
    # Use natural_sort_key to handle numbers in file names correctly
    all_files_to_process.sort(key=natural_sort_key)

    print(f"Found {len(all_files_to_process)} files. Starting consolidation...")

    # --- 第三步：写入 (Step 3: Write) ---
    # 以写入模式打开输出文件
    with open(output_file, 'w', encoding='utf-8') as output:
        # 如果提供了提示，首先将其写入文件
        if prompt:
            output.write(prompt + "\n\n---\n\n") # 添加分隔线以提高可读性

        # 遍历排序后的文件列表进行写入
        for file_path in all_files_to_process:
            _write_file_to_output(file_path, output)

# --- 使用示例 (Usage Example) ---

# 在这里定义你想要的提示文本
my_prompt = ""
# my_prompt = "你是一个专业的flutter ios app开发者。如果代码有新增或者修改, ,请给我修改或新增后完整的代码，每个文件分别给我.没有修改的不用给我。请在下面代码中补充完善todo的功能，以及子页面的功能。如果代码完善了，请优化app的ui，让他更加好看，更加用户友好。以及单个dart文件不宜过长，建议每个文件不超过1000行，过长的尽量要分多个文件。index.html是游戏demo"
my_prompt = "你是一个专业的flutter ios app开发者。如果代码有新增或者修改, 少量的情况下:请生成一行用mac os的终端命令行,输入后将原始文件更新成最新文件,例如:sed、awk.如果修改量多,请给我修改后完整的文件内容.没有修改的不用给我。请在下面代码中补充完善todo的功能，以及子页面的功能。如果代码完善了，请优化app的ui，让他更加好看，更加用户友好。以及单个dart文件不宜过长，建议每个文件不超过1000行，过长的尽量要分多个文件。index.html是游戏demo"

# 创建一个包含所有您想包括的路径的列表。
paths_to_consolidate = [
    '/Users/admin/Desktop/Flutter_app/20250227-yijielv/yijielv/lib',
    # '/Users/admin/Desktop/Flutter_app/20250227-yijielv/yijielv/README.md',
    # '/Users/admin/Desktop/Flutter_app/20260226-Dawns/dawn/index.html',
    # '/Volumes/L/量化/eastmoney-extractor'
]

# 定义输出文件的路径
output_file_path = '/Users/admin/Desktop/Flutter_app/20250227-yijielv/yijielv/已有代码汇总.txt'

# 调用函数
consolidate_files(paths_to_consolidate, output_file_path, prompt=my_prompt)

print(f"Consolidation complete. Output saved to {output_file_path}")