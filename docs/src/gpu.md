# GPU Computing

The `OpenEng.GPU` module provides GPU acceleration with automatic CPU fallback.

## Overview

This module uses CUDA.jl for NVIDIA GPU acceleration, automatically falling back to optimized CPU operations when GPU is unavailable.

## GPU Availability

```julia
using OpenEng.GPU

if gpu_available()
    println("GPU acceleration enabled")
else
    println("Using CPU fallback")
end
```

## Data Transfer

```julia
# Transfer to GPU
A = rand(1000, 1000)
A_gpu = to_gpu(A)

# Transfer back to CPU
A_cpu = to_cpu(A_gpu)
```

## GPU Operations

### Matrix Multiplication

```julia
A = rand(1000, 1000)
B = rand(1000, 1000)

# Automatically uses GPU if available
C = gpu_matmul(A, B)
```

### Element-wise Operations

```julia
# Element-wise multiplication
C = gpu_multiply(A, B)

# Element-wise addition
C = gpu_add(A, B)

# Element-wise subtraction
C = gpu_subtract(A, B)
```

### Matrix Operations

```julia
# Transpose
At = gpu_transpose(A)
```

## Device Arrays

```julia
# Ensure array is on appropriate device
A = device_array(rand(100, 100))
```

## Conditional GPU Code

```julia
@maybe_gpu begin
    # This code runs only if GPU is available
    A_gpu = CuArray(A)
    B_gpu = A_gpu * A_gpu
end
```

## Main Functions

- `gpu_available`, `has_cuda`, `gpu_enabled` - Check GPU availability
- `to_gpu` - Transfer to GPU memory
- `to_cpu` - Transfer to CPU memory
- `device_array` - Ensure on appropriate device
- `gpu_matmul` - GPU matrix multiplication
- `gpu_multiply` - Element-wise multiplication
- `gpu_add` - Element-wise addition
- `gpu_subtract` - Element-wise subtraction
- `gpu_transpose` - Matrix transpose
- `@maybe_gpu` - Conditional GPU execution

## Performance Notes

When GPU is not available:
- All operations automatically fall back to optimized CPU code
- Uses multi-threaded BLAS for matrix operations
- No code changes required for portability

To enable GPU support:
```julia
using Pkg
Pkg.add("CUDA")
```
