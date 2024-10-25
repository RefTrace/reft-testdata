# params is passed automatically by RefTrace
# it is a list of parameter names for the pipeline

# includes is passed automatically by RefTrace
# it is a list of modules included in the pipeline

def main(params, includes):
    # Sort params by line number
    sorted_params = sorted(params, key=lambda p: p.line)
    
    outliers = []
    for i in range(1, len(sorted_params)):
        if sorted_params[i].line - sorted_params[i-1].line > 1:
            outliers.append(sorted_params[i-1])
            outliers.append(sorted_params[i])
    
    if outliers:
        print("Outlier parameters:\n")
        # Remove duplicates while maintaining order
        unique_outliers = [p for i, p in enumerate(outliers) if p not in outliers[:i]]
        # Sort unique outliers by name
        for param in sorted(unique_outliers, key=lambda p: p.name):
            print(param.name)
    else:
        print("No outlier parameters found.")

    # Collect 'from' values and their counts
    from_values = []
    from_counts = []
    for include in includes:
        if include.from_ in from_values:
            index = from_values.index(include.from_)
            from_counts[index] += 1
        else:
            from_values.append(include.from_)
            from_counts.append(1)
    
    # Find and print 'from' values that appear more than once
    multiple_includes = [from_values[i] for i in range(len(from_values)) if from_counts[i] > 1]
    if multiple_includes:
        print("\nSources with multiple includes:")
        for source in sorted(multiple_includes):
            print(source)
    else:
        print("\nNo sources with multiple includes found.")