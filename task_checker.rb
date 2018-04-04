require './stdout_cmp_template.rb'

COMPILATION_LOG_FILE = ARGV[0]
EXECUTION_LOG_FILE = ARGV[1]
SOLVE_STATUS_FILE = ARGV[2]
TASK_ID = ARGV[4]

custom_params = DEFAULT_KV_PARAMS.dup
custom_params[STUSOL][BUILD] = "true"
custom_params[INCLUDE_RUN_STDERR] = false
custom_params[REFSOL][BUILD] = "true"
custom_params[REFSOL][RUN] = "./checker.sh"
custom_params[REFSOL][CUSTOM_ENV] = {}

compare_stdout(COMPILATION_LOG_FILE, EXECUTION_LOG_FILE, SOLVE_STATUS_FILE, TASK_ID, BASH_COMPARE, custom_params)
