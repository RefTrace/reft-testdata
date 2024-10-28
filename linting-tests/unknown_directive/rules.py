def rule_check_cpu_directive(module):
    for process in module.processes:
        unknown_directives = process.directives.unknown
        for unknown_directive in unknown_directives:
            fatal("Unknown directive found: %s" % (unknown_directive.name))