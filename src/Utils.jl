"""
# OpenEng.Utils

Utility functions, I/O operations, and unit conversions.

This module provides auxiliary tools for file I/O, unit conversions,
physical constants, and performance monitoring.

## Main Functions

- `read_csv`, `write_csv`: CSV file I/O
- `read_mat`, `write_mat`: MATLAB file I/O
- `read_hdf5`, `write_hdf5`: HDF5 file I/O
- `convert_units`: Unit conversion
- Physical constants: `SPEED_OF_LIGHT`, `GRAVITY`, etc.

## Examples

```julia
using OpenEng.Utils

# File I/O
data = read_csv("data.csv")
write_mat("output.mat", Dict("data" => data))

# Unit conversion
meters = convert_units(5.0, :km, :m)  # 5000.0

# Constants
c = SPEED_OF_LIGHT  # m/s
```
"""
module Utils

using CSV
using DataFrames
using MAT
using HDF5
using Unitful

# Re-export useful functions
export CSV, DataFrames, DataFrame

# Custom exports
export read_csv, write_csv
export read_mat, write_mat
export read_hdf5, write_hdf5
export convert_units, parse_unit
export PhysicalConstants
export timer, @timed_section

# Physical constants (SI units)
module PhysicalConstants
    const SPEED_OF_LIGHT = 299792458.0  # m/s
    const GRAVITY = 9.80665  # m/s²
    const PLANCK = 6.62607015e-34  # J⋅s
    const BOLTZMANN = 1.380649e-23  # J/K
    const AVOGADRO = 6.02214076e23  # mol⁻¹
    const GAS_CONSTANT = 8.314462618  # J/(mol⋅K)
    const ELEMENTARY_CHARGE = 1.602176634e-19  # C
    const ELECTRON_MASS = 9.1093837015e-31  # kg
    const PROTON_MASS = 1.67262192369e-27  # kg
    const VACUUM_PERMITTIVITY = 8.8541878128e-12  # F/m
    const VACUUM_PERMEABILITY = 1.25663706212e-6  # H/m
end

export PhysicalConstants

"""
    read_csv(filename; kwargs...) -> DataFrame

Read data from a CSV file.

# Arguments
- `filename`: Path to CSV file
- `kwargs...`: Additional arguments passed to CSV.File

# Returns
- DataFrame containing the data

# Examples
```julia
df = read_csv("data.csv")
```
"""
function read_csv(filename::String; kwargs...)
    return CSV.read(filename, DataFrame; kwargs...)
end

"""
    write_csv(filename, data; kwargs...)

Write data to a CSV file.

# Arguments
- `filename`: Path to output CSV file
- `data`: DataFrame or matrix to write
- `kwargs...`: Additional arguments passed to CSV.write

# Examples
```julia
df = DataFrame(x=1:10, y=rand(10))
write_csv("output.csv", df)
```
"""
function write_csv(filename::String, data; kwargs...)
    if !(data isa DataFrame)
        data = DataFrame(data, :auto)
    end
    CSV.write(filename, data; kwargs...)
    @info "Data written to $filename"
end

"""
    read_mat(filename) -> Dict

Read data from a MATLAB .mat file.

# Arguments
- `filename`: Path to .mat file

# Returns
- Dictionary with variable names as keys

# Examples
```julia
data = read_mat("data.mat")
A = data["A"]
```
"""
function read_mat(filename::String)
    return matread(filename)
end

"""
    write_mat(filename, data::Dict)

Write data to a MATLAB .mat file.

# Arguments
- `filename`: Path to output .mat file
- `data`: Dictionary with variable names and values

# Examples
```julia
data = Dict("A" => rand(10, 10), "b" => rand(10))
write_mat("output.mat", data)
```
"""
function write_mat(filename::String, data::Dict)
    matwrite(filename, data)
    @info "Data written to $filename"
end

"""
    read_hdf5(filename, dataset) -> Array

Read a dataset from an HDF5 file.

# Arguments
- `filename`: Path to HDF5 file
- `dataset`: Name of dataset to read

# Returns
- Array containing the dataset

# Examples
```julia
data = read_hdf5("data.h5", "dataset1")
```
"""
function read_hdf5(filename::String, dataset::String)
    h5open(filename, "r") do file
        return read(file, dataset)
    end
end

"""
    write_hdf5(filename, dataset, data)

Write data to an HDF5 file.

# Arguments
- `filename`: Path to output HDF5 file
- `dataset`: Name of dataset
- `data`: Data to write

# Examples
```julia
write_hdf5("output.h5", "mydata", rand(100, 100))
```
"""
function write_hdf5(filename::String, dataset::String, data)
    h5open(filename, "cw") do file
        if haskey(file, dataset)
            delete_object(file, dataset)
        end
        write(file, dataset, data)
    end
    @info "Data written to $filename:$dataset"
end

"""
    convert_units(value, from_unit, to_unit) -> converted_value

Convert between units using Unitful.jl.

# Arguments
- `value`: Numeric value
- `from_unit`: Source unit (symbol)
- `to_unit`: Target unit (symbol)

# Returns
- Converted value (unitless)

# Examples
```julia
km_to_m = convert_units(5.0, :km, :m)  # 5000.0
s_to_ms = convert_units(1.0, :s, :ms)  # 1000.0
```
"""
function convert_units(value::Real, from_unit::Symbol, to_unit::Symbol)
    from = parse_unit(from_unit)
    to = parse_unit(to_unit)
    
    quantity = value * from
    converted = uconvert(to, quantity)
    
    return ustrip(converted)
end

"""
    parse_unit(unit_symbol) -> Unitful.Unit

Parse a unit symbol into a Unitful unit.

# Arguments
- `unit_symbol`: Unit as a symbol (e.g., `:m`, `:km`, `:s`)

# Returns
- Unitful.Unit object

# Examples
```julia
m = parse_unit(:m)
km = parse_unit(:km)
```
"""
function parse_unit(unit_symbol::Symbol)
    unit_str = string(unit_symbol)
    
    # Handle compound units like :m/s
    if occursin("/", unit_str)
        parts = split(unit_str, "/")
        numerator = parse_unit(Symbol(parts[1]))
        denominator = parse_unit(Symbol(parts[2]))
        return numerator / denominator
    end
    
    # Map common units
    unit_map = Dict(
        :m => u"m", :km => u"km", :cm => u"cm", :mm => u"mm",
        :s => u"s", :ms => u"ms", :μs => u"μs", :ns => u"ns",
        :Hz => u"Hz", :kHz => u"kHz", :MHz => u"MHz", :GHz => u"GHz",
        :g => u"g", :kg => u"kg", :mg => u"mg",
        :N => u"N", :J => u"J", :W => u"W",
        :A => u"A", :V => u"V", :Ω => u"Ω",
        :°C => u"°C", :K => u"K",
        :rad => u"rad", :° => u"°",
        :ft => u"ft", :inch => u"inch"
    )
    
    if haskey(unit_map, unit_symbol)
        return unit_map[unit_symbol]
    else
        error("Unknown unit: $unit_symbol")
    end
end

"""
    timer() -> Timer

Create a simple timer for performance measurement.

# Returns
- Timer object

# Examples
```julia
t = timer()
# ... do work ...
elapsed = t.elapsed()
```
"""
mutable struct Timer
    start_time::Float64
    
    Timer() = new(time())
end

function elapsed(t::Timer)
    return time() - t.start_time
end

function reset!(t::Timer)
    t.start_time = time()
end

# Don't export Timer to avoid conflict with Base.Timer
# Users can access it as Utils.Timer
export elapsed, reset!

"""
    @timed_section name expr

Execute a code block and report execution time.

# Arguments
- `name`: Description of the timed section
- `expr`: Code to execute

# Examples
```julia
@timed_section "Matrix multiplication" begin
    C = A * B
end
```
"""
macro timed_section(name, expr)
    quote
        local t0 = time()
        local result = $(esc(expr))
        local elapsed = time() - t0
        @info "$($(esc(name))) completed in $(round(elapsed, digits=3)) seconds"
        result
    end
end

end # module Utils
