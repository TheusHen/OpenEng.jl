using Test
using OpenEng.Utils
using DataFrames
using Unitful  # Import Unitful for tests

@testset "Utils Module" begin
    @testset "Physical Constants" begin
        @test PhysicalConstants.SPEED_OF_LIGHT ≈ 299792458.0
        @test PhysicalConstants.GRAVITY ≈ 9.80665
        @test PhysicalConstants.PLANCK > 0
        @test PhysicalConstants.BOLTZMANN > 0
        @test PhysicalConstants.AVOGADRO > 0
    end
    
    @testset "CSV I/O" begin
        # Create temporary CSV file
        tmpfile = tempname() * ".csv"
        
        # Write data
        df = DataFrame(x=1:10, y=rand(10), z=randn(10))
        write_csv(tmpfile, df)
        @test isfile(tmpfile)
        
        # Read data back
        df_read = read_csv(tmpfile)
        @test size(df_read) == size(df)
        @test df_read.x == df.x
        @test df_read.y ≈ df.y
        
        # Clean up
        rm(tmpfile, force=true)
    end
    
    @testset "MAT File I/O" begin
        tmpfile = tempname() * ".mat"
        
        # Write data
        data = Dict("A" => rand(5, 5), "b" => rand(5), "scalar" => 42.0)
        write_mat(tmpfile, data)
        @test isfile(tmpfile)
        
        # Read data back
        data_read = read_mat(tmpfile)
        @test haskey(data_read, "A")
        @test haskey(data_read, "b")
        @test haskey(data_read, "scalar")
        @test data_read["A"] ≈ data["A"]
        @test data_read["b"] ≈ data["b"]
        @test data_read["scalar"] ≈ data["scalar"]
        
        # Clean up
        rm(tmpfile, force=true)
    end
    
    @testset "HDF5 I/O" begin
        tmpfile = tempname() * ".h5"
        
        # Write data
        data = rand(10, 10)
        write_hdf5(tmpfile, "dataset1", data)
        @test isfile(tmpfile)
        
        # Read data back
        data_read = read_hdf5(tmpfile, "dataset1")
        @test data_read ≈ data
        
        # Write another dataset
        data2 = randn(20)
        write_hdf5(tmpfile, "dataset2", data2)
        data2_read = read_hdf5(tmpfile, "dataset2")
        @test data2_read ≈ data2
        
        # Clean up
        rm(tmpfile, force=true)
    end
    
    @testset "Unit Conversion" begin
        # Length conversions
        @test convert_units(1.0, :km, :m) ≈ 1000.0
        @test convert_units(1000.0, :m, :km) ≈ 1.0
        @test convert_units(100.0, :cm, :m) ≈ 1.0
        
        # Time conversions
        @test convert_units(1.0, :s, :ms) ≈ 1000.0
        @test convert_units(1000.0, :ms, :s) ≈ 1.0
        
        # Frequency conversions
        @test convert_units(1.0, :kHz, :Hz) ≈ 1000.0
        @test convert_units(1000.0, :Hz, :kHz) ≈ 1.0
    end
    
    @testset "Unit Parsing" begin
        m = parse_unit(:m)
        @test m isa Unitful.Units
        
        km = parse_unit(:km)
        @test km isa Unitful.Units
        
        Hz = parse_unit(:Hz)
        @test Hz isa Unitful.Units
    end
    
    @testset "Timer" begin
        t = Utils.Timer()
        @test t isa Utils.Timer
        
        sleep(0.1)
        elapsed_time = elapsed(t)
        @test elapsed_time >= 0.09  # Allow small tolerance
        @test elapsed_time < 0.2
        
        reset!(t)
        elapsed_after_reset = elapsed(t)
        @test elapsed_after_reset < 0.05
    end
    
    @testset "Timed Section Macro" begin
        result = @timed_section "Test operation" begin
            sum(1:1000)
        end
        
        @test result == sum(1:1000)
    end
    
    @testset "DataFrame Creation" begin
        # Test that we can work with DataFrames
        df = DataFrame(a=1:5, b=rand(5))
        @test size(df) == (5, 2)
        @test names(df) == ["a", "b"]
    end
    
    @testset "Multiple File Format Workflow" begin
        # Test workflow: CSV -> DataFrame -> MAT
        tmpcsv = tempname() * ".csv"
        tmpmat = tempname() * ".mat"
        
        # Create and save CSV
        df = DataFrame(x=1:5, y=(1:5).^2)
        write_csv(tmpcsv, df)
        
        # Read CSV
        df_read = read_csv(tmpcsv)
        
        # Convert to MAT
        mat_data = Dict("x" => df_read.x, "y" => df_read.y)
        write_mat(tmpmat, mat_data)
        
        # Read MAT
        mat_read = read_mat(tmpmat)
        @test mat_read["x"] == df.x
        @test mat_read["y"] == df.y
        
        # Clean up
        rm(tmpcsv, force=true)
        rm(tmpmat, force=true)
    end
end
