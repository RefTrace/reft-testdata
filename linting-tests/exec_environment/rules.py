def rule_check_execution_environment(module):
    valid_directives = ['container', 'label', 'conda', 'module', 'spack']
    
    for process in module.processes:
        # Check if any of the valid directives exist
        has_valid_directive = False
        for directive in valid_directives:
            if getattr(process.directives, directive):
                has_valid_directive = True
                break
        
        if not has_valid_directive:
            fatal(
                "Process %s must specify at least one of: %s" % 
                (process.name, ', '.join(valid_directives))
            )