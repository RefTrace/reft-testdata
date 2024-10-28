process FOO {
    accelerator 2, type: 'foo'
}

process TOO_SMALL {
    accelerator 1, type: 'nvidia-tesla-a100'
}

process TOO_BIG {
    accelerator 100, type: 'nvidia-tesla-a100'
}