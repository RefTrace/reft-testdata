# List of allowed GPU types
ALLOWED_GPU_TYPES = [
    "nvidia-tesla-v100",
    "nvidia-tesla-p100",
    "nvidia-tesla-k80",
    "nvidia-tesla-a100",
    # Add other allowed GPU types as needed
]

def rule_check_gpu_type(module):
    for process in module.processes:
        accelerator_directives = process.directives.accelerator
        if not accelerator_directives:
            # No accelerator directive, so we skip this process
            continue
        
        for acc_directive in accelerator_directives:
            if acc_directive.gpu_type and acc_directive.gpu_type not in ALLOWED_GPU_TYPES:
                fatal("Process %s specifies invalid GPU type '%s'. Allowed types are: %s" % 
                      (process.name, acc_directive.gpu_type, ", ".join(ALLOWED_GPU_TYPES)))

def rule_check_gpu_count(module):
    for process in module.processes:
        accelerator_directives = process.directives.accelerator
        if not accelerator_directives:
            # No accelerator directive, so we skip this process
            continue
        
        for acc_directive in accelerator_directives:
            if acc_directive.num_gpus < 2 or acc_directive.num_gpus > 8:
                error("Process %s requests invalid number of GPUs: %d. Value must be between 1 and 8" % 
                      (process.name, acc_directive.num_gpus))