package simplest

import "core:c"

// pointers to arrays are handled as multi-pointers
// (https://odin-lang.org/docs/overview/#multi-pointers)

@export
multiply :: proc "c" (arr_in: [^]c.int, factor: c.int, arr_out: [^]c.int, shape: [^]c.uint) {
    num_rows := shape[0]
    num_cols := shape[1]

    for row in 0..<num_rows {
        for col in 0..<num_cols {
            offset: = row * num_cols + col
            arr_out[offset] = factor * arr_in[offset]
        }
    }
}

