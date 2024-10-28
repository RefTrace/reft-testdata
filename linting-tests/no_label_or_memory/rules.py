# This file should exist in the root of your pipeline directory
def has_label(directives):
    return len(directives.label) > 0

def has_memory(directives):
    return len(directives.memory) > 0

def rule_has_label_or_memory(module):
    for process in module.processes:
        if not (has_label(process.directives) or has_memory(process.directives)):
            fatal("process %s has no label or memory directive" % process.name)