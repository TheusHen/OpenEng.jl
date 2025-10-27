"""
    OpenEng

OpenEng.jl é uma toolbox científica open-source em Julia que substitui o MATLAB 
com desempenho superior. Inclui módulos para álgebra linear, simulação de sistemas, 
processamento de sinais, otimização e visualização 2D/3D. Suporta GPU, IA e controle, 
sendo ideal para estudantes, engenheiros e pesquisadores que buscam poder, velocidade 
e liberdade.

# Modules

* `LinearAlgebraExt` - Extended linear algebra operations
* `SignalProcessing` - Signal processing and analysis tools
* `ControlSystems` - Control systems simulation and analysis
* `Optimization` - Optimization algorithms and tools
* `Visualization` - 2D/3D plotting and visualization utilities

# Examples

```julia
using OpenEng

# Basic usage examples will be added as modules are developed
```
"""
module OpenEng

using LinearAlgebra
using Statistics

# Read version from Project.toml
function _get_version()
    project_toml = joinpath(dirname(@__DIR__), "Project.toml")
    if isfile(project_toml)
        for line in eachline(project_toml)
            if startswith(line, "version")
                m = match(r"version\s*=\s*\"(.+)\"", line)
                if m !== nothing
                    return VersionNumber(m.captures[1])
                end
            end
        end
    end
    return v"0.1.0"  # fallback version
end

# Version information
const VERSION = _get_version()

# Export main functionality
export greet

"""
    greet()

Welcome message for OpenEng.jl
"""
function greet()
    println("""
    ╔═══════════════════════════════════════════════════════════╗
    ║                    OpenEng.jl v$(VERSION)                    ║
    ║  Scientific Computing Toolbox for Julia                   ║
    ║                                                           ║
    ║  Substituindo MATLAB com desempenho superior!             ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Módulos disponíveis:
    • Álgebra Linear
    • Processamento de Sinais
    • Sistemas de Controle
    • Otimização
    • Visualização 2D/3D
    
    Para começar, use: ?OpenEng
    """)
end

# Include submodules (to be developed)
# include("LinearAlgebraExt.jl")
# include("SignalProcessing.jl")
# include("ControlSystems.jl")
# include("Optimization.jl")
# include("Visualization.jl")

end # module OpenEng
