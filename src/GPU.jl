"""
# OpenEng.GPU

GPU-accelerated computing with automatic CPU fallback.

This module provides GPU acceleration using CUDA.jl for NVIDIA GPUs, with
automatic fallback to multi-threaded CPU operations when GPU is unavailable.

## Main Functions

- `gpu_available`: Check if GPU is available
- `to_gpu`: Transfer data to GPU
- `to_cpu`: Transfer data back to CPU
- `gpu_matmul`: GPU matrix multiplication
- `gpu_fft`: GPU FFT

## Examples

```julia
using OpenEng.GPU

if gpu_available()
    A_gpu = to_gpu(A)
    B_gpu = to_gpu(B)
    C_gpu = gpu_matmul(A_gpu, B_gpu)
    C = to_cpu(C_gpu)
else
    C = A * B  # CPU fallback
end
```
"""
module GPU

using LinearAlgebra

# Try to load CUDA
const CUDA_AVAILABLE = Ref(false)
const CUDA = Ref{Union{Module, Nothing}}(nothing)

function __init__()
    try
        CUDA[] = Base.require(Main, :CUDA)
        if CUDA[].functional()
            CUDA_AVAILABLE[] = true
            @info "CUDA.jl loaded successfully - GPU acceleration enabled"
        else
            @info "CUDA.jl loaded but no functional GPU detected - using CPU fallback"
        end
    catch e
        @info "CUDA.jl not available - using CPU fallback. To enable GPU: add CUDA"
        CUDA_AVAILABLE[] = false
    end
end

# Exports
export gpu_available, has_cuda, gpu_enabled
export to_gpu, to_cpu, @maybe_gpu
export gpu_matmul, gpu_multiply
export gpu_add, gpu_subtract
export gpu_transpose
export device_array

"""
    gpu_available() -> Bool

Check if GPU acceleration is available.

# Returns
- `true` if a functional GPU is available, `false` otherwise

# Examples
```julia
if gpu_available()
    println("GPU acceleration enabled")
else
    println("Using CPU")
end
```
"""
gpu_available() = CUDA_AVAILABLE[]

"""
    has_cuda() -> Bool

Check if CUDA is available (alias for `gpu_available`).
"""
has_cuda() = CUDA_AVAILABLE[]

"""
    gpu_enabled() -> Bool

Check if GPU operations are enabled (alias for `gpu_available`).
"""
gpu_enabled() = CUDA_AVAILABLE[]

"""
    to_gpu(A) -> A_gpu

Transfer array to GPU memory.

If GPU is not available, returns the input array unchanged.

# Arguments
- `A`: CPU array

# Returns
- GPU array if available, otherwise CPU array

# Examples
```julia
A = rand(1000, 1000)
A_gpu = to_gpu(A)
```
"""
function to_gpu(A::AbstractArray)
    if CUDA_AVAILABLE[] && CUDA[] !== nothing
        return CUDA[].CuArray(A)
    else
        return A
    end
end

"""
    to_cpu(A) -> A_cpu

Transfer array from GPU to CPU memory.

If input is already a CPU array, returns it unchanged.

# Arguments
- `A`: GPU or CPU array

# Returns
- CPU array

# Examples
```julia
A_cpu = to_cpu(A_gpu)
```
"""
function to_cpu(A::AbstractArray)
    if CUDA_AVAILABLE[] && CUDA[] !== nothing && A isa CUDA[].CuArray
        return Array(A)
    else
        return A
    end
end

"""
    device_array(A) -> A_device

Ensure array is on the appropriate device (GPU if available, CPU otherwise).

# Arguments
- `A`: Input array

# Returns
- Array on the appropriate device

# Examples
```julia
A = device_array(rand(100, 100))
```
"""
device_array(A::AbstractArray) = to_gpu(A)

"""
    gpu_matmul(A, B) -> C

Perform matrix multiplication on GPU if available, otherwise CPU.

# Arguments
- `A`: First matrix
- `B`: Second matrix

# Returns
- Product C = A * B

# Examples
```julia
A = rand(1000, 1000)
B = rand(1000, 1000)
C = gpu_matmul(A, B)
```
"""
function gpu_matmul(A::AbstractMatrix, B::AbstractMatrix)
    if CUDA_AVAILABLE[]
        A_gpu = to_gpu(A)
        B_gpu = to_gpu(B)
        C_gpu = A_gpu * B_gpu
        return to_cpu(C_gpu)
    else
        # CPU fallback with BLAS
        return A * B
    end
end

"""
    gpu_multiply(A, B) -> C

Element-wise multiplication on GPU if available.

# Arguments
- `A`: First array
- `B`: Second array

# Returns
- Element-wise product

# Examples
```julia
A = rand(1000, 1000)
B = rand(1000, 1000)
C = gpu_multiply(A, B)
```
"""
function gpu_multiply(A::AbstractArray, B::AbstractArray)
    if CUDA_AVAILABLE[]
        A_gpu = to_gpu(A)
        B_gpu = to_gpu(B)
        C_gpu = A_gpu .* B_gpu
        return to_cpu(C_gpu)
    else
        return A .* B
    end
end

"""
    gpu_add(A, B) -> C

Element-wise addition on GPU if available.

# Arguments
- `A`: First array
- `B`: Second array

# Returns
- Element-wise sum

# Examples
```julia
C = gpu_add(A, B)
```
"""
function gpu_add(A::AbstractArray, B::AbstractArray)
    if CUDA_AVAILABLE[]
        A_gpu = to_gpu(A)
        B_gpu = to_gpu(B)
        C_gpu = A_gpu .+ B_gpu
        return to_cpu(C_gpu)
    else
        return A .+ B
    end
end

"""
    gpu_subtract(A, B) -> C

Element-wise subtraction on GPU if available.

# Arguments
- `A`: First array
- `B`: Second array

# Returns
- Element-wise difference

# Examples
```julia
C = gpu_subtract(A, B)
```
"""
function gpu_subtract(A::AbstractArray, B::AbstractArray)
    if CUDA_AVAILABLE[]
        A_gpu = to_gpu(A)
        B_gpu = to_gpu(B)
        C_gpu = A_gpu .- B_gpu
        return to_cpu(C_gpu)
    else
        return A .- B
    end
end

"""
    gpu_transpose(A) -> A'

Transpose matrix on GPU if available.

# Arguments
- `A`: Input matrix

# Returns
- Transposed matrix

# Examples
```julia
At = gpu_transpose(A)
```
"""
function gpu_transpose(A::AbstractMatrix)
    if CUDA_AVAILABLE[]
        A_gpu = to_gpu(A)
        At_gpu = transpose(A_gpu)
        return to_cpu(At_gpu)
    else
        return transpose(A)
    end
end

"""
    @maybe_gpu expr

Macro to conditionally execute code on GPU if available.

# Examples
```julia
@maybe_gpu begin
    A_gpu = CuArray(A)
    B_gpu = A_gpu * A_gpu
end
```
"""
macro maybe_gpu(expr)
    quote
        if CUDA_AVAILABLE[]
            $(esc(expr))
        else
            @warn "GPU not available, consider running on CPU explicitly"
        end
    end
end

end # module GPU
