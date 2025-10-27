using Documenter
using OpenEng

makedocs(;
    modules=[OpenEng],
    authors="OpenEng.jl Contributors",
    repo="https://github.com/TheusHen/OpenEng.jl/blob/{commit}{path}#L{line}",
    sitename="OpenEng.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://theushen.github.io/OpenEng.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Getting Started" => "getting_started.md",
        "Modules" => [
            "Linear Algebra" => "linear_algebra.md",
            "Simulation" => "simulation.md",
            "Signal Processing" => "signal.md",
            "Optimization" => "optimization.md",
            "Visualization" => "viz.md",
            "GPU Computing" => "gpu.md",
            "Utilities" => "utils.md",
        ],
        "Examples" => "examples.md",
        "API Reference" => "api.md",
    ],
)

deploydocs(;
    repo="github.com/TheusHen/OpenEng.jl",
    devbranch="main",
)
