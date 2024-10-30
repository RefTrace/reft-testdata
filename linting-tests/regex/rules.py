def rule_check_container_name(module):
    # Compile the ECR pattern
    ecr_pattern = re.compile(r"\d{12}\.dkr\.ecr\..+\.amazonaws\.com/.*")

    for process in module.processes:
        container_directives = process.directives.container
        if not container_directives:
            # No container directive, skip this process
            continue
            
        for container in container_directives:
            match = ecr_pattern.match(container.name)
            if not match:
                fatal("Process %s has invalid container name '%s'. Must match ECR pattern: %s" % 
                      (process.name, container.name, ecr_pattern.pattern))