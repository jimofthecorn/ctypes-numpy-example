package reference

import "base:runtime"
import "core:c"
import "core:fmt"

import "cpp_ref"

@export
apply_print :: proc "c" (arr_in : [^]c.int, shape : [^]c.uint) {
    context = runtime.default_context()

    num_rows := shape[0]
    num_cols := shape[1]

    fmt.println("C array values (from Odin): ")
    for row in 0..<num_rows {
        for col in 0..<num_cols {
            offset: = row * num_cols + col
            fmt.printf("%d ", arr_in[offset])
        }
        fmt.println()
    }
    fmt.println()
}

@export
apply_multiply :: proc "c" (arr_in : [^]c.int, shape : [^]c.uint, factor : c.int) {

    context = runtime.default_context()

    num_rows := shape[0]
    num_cols := shape[1]

    for row in 0..<num_rows {
        for col in 0..<num_cols {
            offset: = row * num_cols + col
            arr_in[offset] *= factor
        }
    }

}

@export
cpp_print :: proc "c" (arr_in : [^]c.int, shape : [^]c.uint) {
    cpp_ref.cpp_print(arr_in, shape)
}
