package cpp_ref

import "core:c"

when ODIN_OS == .Windows {
    foreign import cppref "cppref.lib"
}
when ODIN_OS == .Linux {
    foreign import cppref "libcppref.a"
}

foreign cppref {
	@(link_name="print")
    cpp_print :: proc(arr_in: [^]c.int, shape: [^]c.uint) -> c.int ---
}
