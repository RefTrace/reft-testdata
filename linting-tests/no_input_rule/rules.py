def has_any_input(inputs):
    # Check all possible input types
    return (len(inputs.vals) > 0 or 
            len(inputs.files) > 0 or 
            len(inputs.paths) > 0 or 
            len(inputs.envs) > 0 or 
            len(inputs.stdins) > 0 or 
            len(inputs.tuples) > 0)

def rule_has_input(module):
    for process in module.processes:
        if not has_any_input(process.inputs):
            fatal("Process '%s' has no inputs defined" % process.name)