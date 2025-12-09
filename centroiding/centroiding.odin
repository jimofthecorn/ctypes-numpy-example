package reference

import "base:runtime"
import "core:c"
import "core:slice"
import "core:fmt"
import "core:time"
import "core:simd"
import "core:math/rand"

NUM_REPETITIONS :: #config(REP, 100) // The number of times to run each proc, for performance measurement

ImageSlice :: []c.uint16_t
Image :: struct {
    data: ImageSlice,
    num_rows: int,
    num_cols: int,
}
SearchBox :: struct {
    start_row: int,
    start_col: int,
    num_rows: int,
    num_cols: int,
}

@export
process_searchbox :: proc "c" (
    arr_in : [^]c.uint16_t, shape : [^]c.uint, box_offset: [^]c.uint, box_shape: [^]c.uint
    ) -> int {

    context = runtime.default_context()

    input_rows := int(shape[0])
    input_cols := int(shape[1])
    input_image := Image {
        num_rows = input_rows,
        num_cols = input_cols,
        data = slice.from_ptr(arr_in, input_rows * input_cols),
    }

    box := SearchBox {
        start_row = int(box_offset[0]),
        start_col = int(box_offset[1]),
        num_rows = int(box_shape[0]),
        num_cols = int(box_shape[1]),
    }

    if box.start_row < 0 || box.start_col < 0 ||
        box.start_row + box.num_rows >= input_rows ||
        box.start_col + box.num_cols >= input_cols {
        return 0
    }
    
    box_slice := extract_searchbox(input_image, box)
    fmt.println(box_slice)

    return 1
}

make_random_image :: proc(shape: [2]c.uint, allocator: mem.Allocator) -> (img: Image, err: mem.Allocator_Error) {

    num_rows := int(shape[0])
    num_cols := int(shape[1])

    img := Image {
        num_rows = num_rows,
        num_cols = num_cols,
    }
    img.data := make([]c.uint16_t, num_rows * num_cols, allocator) or_return
}

extract_searchbox :: proc(input_image: Image, box: SearchBox) -> ImageSlice {
    rows := make([dynamic]ImageSlice, box.num_rows)
    defer delete(rows)

    row_start_offset := box.start_row * input_image.num_cols
    for i in 0..<box.num_rows {
        box_start := row_start_offset + box.start_col
        box_end := box_start + box.num_cols
        rows[i] = input_image.data[box_start:box_end]
        row_start_offset += input_image.num_cols
    }

    sbslice := slice.concatenate(rows[:]) 

    fmt.println(sbslice)

	fmt.printfln("Max (Scalar): %d (%v)", benchmark(max_scalar, sbslice))

    return sbslice
}

max_scalar :: proc (box: ImageSlice) -> c.uint16_t {
    val := min(c.uint16_t)

    for x in box {
        val = max(val, x)
    }
    return val
}


benchmark :: proc (p: proc (ImageSlice) -> c.uint16_t, s: ImageSlice) -> (c.uint16_t, time.Duration) {
	best_elapsed := max(time.Duration)
	result : c.uint16_t
	for _ in 0..<NUM_REPETITIONS {
		start := time.tick_now()
		result = p(s)
		best_elapsed = min(time.tick_since(start), best_elapsed)
	}
	return result, best_elapsed
}
