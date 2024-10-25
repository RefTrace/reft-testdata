process foo {
    output:
    env VER, emit: tool_version
    env DBVER,  emit: db_version, optional: true, topic: 'report'
}