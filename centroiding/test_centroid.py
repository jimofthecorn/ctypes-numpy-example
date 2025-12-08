import numpy as np
import numpy.ctypeslib as npct
import ctypes as ct

odinlib = npct.load_library('reference', '.')

def define_arguments():
    ''' Convenience function for defining the arguments of the functions
        inside the imported module. '''

    # Define the arguments accepted by the C functions. This is not strictly necessary,
    # but it is good practice for avoiding segmentation faults. 
    npflags = ['C_CONTIGUOUS']   # Require a C contiguous array in memory
    uint_1d_type = npct.ndpointer(dtype=np.uint32, ndim=1, flags=npflags)
    int_2d_type = npct.ndpointer(dtype=np.int32, ndim=2, flags=npflags)
    print_args = [
        int_2d_type,
        uint_1d_type,
    ]
    odinlib.apply_print.argtypes = print_args
    odinlib.apply_print.restype = ct.c_int
    odinlib.cpp_print.argtypes = print_args
    odinlib.cpp_print.restype = ct.c_int

    mult_args = [
        int_2d_type,
        uint_1d_type,
        ct.c_int      # Integer type
    ]
    odinlib.apply_multiply.argtypes = mult_args
    odinlib.apply_multiply.restype = ct.c_int
    
define_arguments()

# Generate some numpy array
N = 5
arr_in = np.arange(N**2, dtype=np.int32).reshape(N, N)

# Allocate the output array in memory, and get the shape of the array
shape = np.array(arr_in.shape, dtype=np.uint32)

# Call functions
odinlib.apply_print(arr_in, shape)
factor = -2
odinlib.apply_multiply(arr_in, shape, factor)

print(arr_in)
arr_in = np.ascontiguousarray(arr_in.transpose())
odinlib.apply_print(arr_in, shape)
odinlib.cpp_print(arr_in, shape)

