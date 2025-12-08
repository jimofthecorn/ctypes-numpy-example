package reference

import "vendor:box2d"
import "base:runtime"
import "core:c"
import "core:slice"
import "core:fmt"

ImageSlice :: []c.uint16_t
Image :: struct {
    data: ImageSlice,
    num_rows: uint,
    num_cols: uint,
}
SearchBox :: struct {
    start_row: uint,
    start_col: uint,
    num_rows: uint,
    num_cols: uint,
}

@export
process_searchbox :: proc "c" (
    arr_in : [^]c.uint16_t, shape : [^]c.uint, box_offset: [^]c.uint, box_shape: [^]c.uint
    ) -> bool {

    context = runtime.default_context()

    input_rows := cast(uint)shape[0]
    input_cols := cast(uint)shape[1]
    input_image := Image {
        num_rows = input_rows,
        num_cols = input_cols,
        data = slice.from_ptr(arr_in, input_rows * input_cols),
    }

    box := SearchBox {
        start_row = cast(uint)box_offset[0],
        start_col = cast(uint)box_offset[1],
        num_rows = cast(uint)box_shape[0],
        num_cols = cast(uint)box_shape[1],
    }

    if box.start_row + box.num_rows >= input_rows ||
        box.start_col + box.num_cols >= input_cols {
        return false
    }
    
    return true
}

extract_searchbox :: proc(input_image: Image, box: SearchBox) -> ImageSlice {
    rows := [dynamic]ImageSlice

    row_start_offset := box.start_row * input_image.num_cols
    for i in 0..<box.num_rows {
        box_start := row_start_offset + box.start_col
        box_end := box_start + box.num_cols
        rows[i] = input_image.data[box_start:box_end]
    }
}
