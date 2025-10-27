#!/bin/bash
# OpenEng.jl Installation Script for Ubuntu/Debian

set -e

echo "=================================================="
echo "OpenEng.jl Installation Script"
echo "=================================================="

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Warning: This script is designed for Ubuntu/Debian Linux"
    echo "Please install Julia manually from https://julialang.org/downloads/"
    exit 1
fi

# Update package list
echo ""
echo "Step 1: Updating system packages..."
sudo apt-get update

# Install dependencies
echo ""
echo "Step 2: Installing system dependencies..."
sudo apt-get install -y wget tar gzip build-essential

# Install Julia if not already installed
if command -v julia &> /dev/null; then
    JULIA_VERSION=$(julia --version | awk '{print $3}')
    echo ""
    echo "Julia is already installed: version $JULIA_VERSION"
    
    # Check if version is >= 1.10
    MAJOR=$(echo $JULIA_VERSION | cut -d. -f1)
    MINOR=$(echo $JULIA_VERSION | cut -d. -f2)
    
    if [ "$MAJOR" -eq 1 ] && [ "$MINOR" -lt 10 ]; then
        echo "Warning: Julia version should be >= 1.10"
        echo "Consider upgrading Julia"
    fi
else
    echo ""
    echo "Step 3: Installing Julia 1.10..."
    
    # Download Julia
    JULIA_VERSION="1.10"
    JULIA_MINOR="1.10.1"
    JULIA_URL="https://julialang-s3.julialang.org/bin/linux/x64/${JULIA_VERSION}/julia-${JULIA_MINOR}-linux-x86_64.tar.gz"
    
    cd /tmp
    wget -q --show-progress $JULIA_URL -O julia.tar.gz
    
    # Extract
    tar -xzf julia.tar.gz
    
    # Install to /opt
    sudo mv julia-${JULIA_MINOR} /opt/julia
    
    # Create symlink
    sudo ln -sf /opt/julia/bin/julia /usr/local/bin/julia
    
    # Verify installation
    julia --version
    
    echo "Julia installed successfully!"
fi

# Navigate to OpenEng.jl directory
echo ""
echo "Step 4: Setting up OpenEng.jl..."

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

if [ ! -f "Project.toml" ]; then
    echo "Error: Project.toml not found in $PROJECT_DIR"
    exit 1
fi

echo "Working directory: $PROJECT_DIR"

# Instantiate the project (install dependencies)
echo ""
echo "Step 5: Installing Julia package dependencies..."
echo "This may take several minutes on first run..."

julia --project=. -e '
    using Pkg
    println("Instantiating project...")
    Pkg.instantiate()
    println("Precompiling packages...")
    Pkg.precompile()
    println("Installation complete!")
'

# Run a quick smoke test
echo ""
echo "Step 6: Running smoke tests..."

julia --project=. -e '
    using OpenEng
    println("OpenEng.jl loaded successfully!")
    OpenEng.info()
'

# Check if tests should be run
echo ""
read -p "Do you want to run the full test suite? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Running tests (this may take a while)..."
    julia --project=. -e 'using Pkg; Pkg.test()'
fi

echo ""
echo "=================================================="
echo "Installation Complete!"
echo "=================================================="
echo ""
echo "You can now use OpenEng.jl:"
echo ""
echo "  julia --project=/workspaces/OpenEng.jl"
echo "  julia> using OpenEng"
echo "  julia> OpenEng.info()"
echo ""
echo "To run examples:"
echo "  julia --project=/workspaces/OpenEng.jl examples/linear_algebra_examples.jl"
echo ""
echo "Documentation: docs/"
echo "Examples: examples/"
echo "Tests: test/"
echo ""
