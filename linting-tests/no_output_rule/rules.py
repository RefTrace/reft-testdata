def has_any_output(outputs):
    # Check all possible output types
    return (len(outputs.vals) > 0 or 
            len(outputs.files) > 0 or 
            len(outputs.paths) > 0 or 
            len(outputs.envs) > 0 or 
            len(outputs.stdouts) > 0 or 
            len(outputs.tuples) > 0)

def rule_has_output(module):
    for process in module.processes:
        if not has_any_output(process.outputs):
            fatal("Process '%s' has no outputs defined" % process.name)
