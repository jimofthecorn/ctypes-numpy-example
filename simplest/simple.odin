package simplest

import "core:c"

 @(export, link_name="multiply")
multiply :: proc "c" (arr_in: [^]c.int, factor: c.int, arr_out: [^]c.int, shape: [^]c.uint) -> c.int {
    num_rows := shape[0]
    num_cols := shape[1]

    for row in 0..<num_rows {
        for col in 0..<num_cols {
            offset: = row * num_cols + col
            arr_out[offset] = factor * arr_in[offset]
        }
    }
    return 0
}

