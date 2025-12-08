import numpy as np
import numpy.ctypeslib as npct
import ctypes as ct

odinlib = npct.load_library('centroiding', '.')

def define_arguments():
    ''' Convenience function for defining the arguments of the functions
        inside the imported module. '''

    # Define the arguments accepted by the C functions. This is not strictly necessary,
    # but it is good practice for avoiding segmentation faults. 
    npflags = ['C_CONTIGUOUS']   # Require a C contiguous array in memory
    uint16_type = npct.ndpointer(dtype=np.uint16, ndim=2, flags=npflags)
    uint32_type = npct.ndpointer(dtype=np.uint32, ndim=1, flags=npflags)
    proc_args = [
        uint16_type,
        uint32_type,
        uint32_type,
        uint32_type,
    ]
    odinlib.process_searchbox.argtypes = proc_args
    odinlib.process_searchbox.restype = ct.c_int

    
define_arguments()

# Generate some numpy array
N = 5
arr_in = np.arange(N**2, dtype=np.uint16).reshape(N, N)
shape = np.array(arr_in.shape, dtype=np.uint32)
searchbox_offset = np.array([1, 1], dtype=np.uint32)
searchbox_shape = np.array([3, 3], dtype=np.uint32)

print(arr_in)
print(shape)
print(searchbox_offset)
print(searchbox_shape)

# Call functions
stat = odinlib.process_searchbox(arr_in, shape, searchbox_offset, searchbox_shape)


