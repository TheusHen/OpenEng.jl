# Utilities

The `OpenEng.Utils` module provides utility functions, file I/O, unit conversions, and physical constants.

## File I/O

### CSV Files

```julia
using OpenEng.Utils

# Write CSV
df = DataFrame(x=1:10, y=rand(10))
write_csv("data.csv", df)

# Read CSV
df = read_csv("data.csv")
```

### MATLAB Files

```julia
# Write .mat file
data = Dict("A" => rand(10, 10), "b" => rand(10))
write_mat("data.mat", data)

# Read .mat file
data = read_mat("data.mat")
A = data["A"]
```

### HDF5 Files

```julia
# Write HDF5
data = rand(100, 100)
write_hdf5("data.h5", "dataset1", data)

# Read HDF5
data = read_hdf5("data.h5", "dataset1")
```

## Unit Conversion

```julia
# Length conversions
meters = convert_units(5.0, :km, :m)  # 5000.0
km = convert_units(1000.0, :m, :km)   # 1.0

# Time conversions
ms = convert_units(1.0, :s, :ms)      # 1000.0

# Frequency conversions
Hz = convert_units(1.0, :kHz, :Hz)    # 1000.0
```

### Supported Units

**Length**: `:m`, `:km`, `:cm`, `:mm`, `:ft`, `:inch`

**Time**: `:s`, `:ms`, `:μs`, `:ns`

**Frequency**: `:Hz`, `:kHz`, `:MHz`, `:GHz`

**Mass**: `:g`, `:kg`, `:mg`

**Others**: `:N`, `:J`, `:W`, `:A`, `:V`, `:Ω`, `:°C`, `:K`, `:rad`, `:°`

## Physical Constants

```julia
using OpenEng.Utils.PhysicalConstants

c = SPEED_OF_LIGHT      # 299792458.0 m/s
g = GRAVITY             # 9.80665 m/s²
h = PLANCK              # 6.62607015e-34 J⋅s
k = BOLTZMANN           # 1.380649e-23 J/K
NA = AVOGADRO           # 6.02214076e23 mol⁻¹
R = GAS_CONSTANT        # 8.314462618 J/(mol⋅K)
e = ELEMENTARY_CHARGE   # 1.602176634e-19 C
me = ELECTRON_MASS      # 9.1093837015e-31 kg
mp = PROTON_MASS        # 1.67262192369e-27 kg
```

## Performance Timing

### Timer Object

```julia
t = Utils.Timer()
# ... do work ...
elapsed_time = elapsed(t)
println("Elapsed: ", elapsed_time, " seconds")

# Reset timer
reset!(t)
```

### Timed Sections

```julia
result = @timed_section "Matrix multiplication" begin
    C = A * B
end
```

## DataFrame Operations

```julia
using OpenEng.Utils

# Create DataFrame
df = DataFrame(a=1:5, b=rand(5))

# Access columns
x = df.a
y = df.b
```

## Main Functions

**File I/O**:
- `read_csv`, `write_csv` - CSV files
- `read_mat`, `write_mat` - MATLAB files  
- `read_hdf5`, `write_hdf5` - HDF5 files

**Unit Conversion**:
- `convert_units` - Convert between units
- `parse_unit` - Parse unit symbol

**Physical Constants**:
- `PhysicalConstants` module with all constants

**Timing**:
- `Timer` - Timer object
- `elapsed` - Get elapsed time
- `reset!` - Reset timer
- `@timed_section` - Time code block

## Examples

Complete workflows for data processing, file conversion, and performance measurement can be found in the examples directory.
