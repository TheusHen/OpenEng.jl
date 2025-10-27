using Documenter
using OpenEng

makedocs(
    sitename = "OpenEng.jl",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        canonical = "https://TheusHen.github.io/OpenEng.jl",
        assets = String[],
    ),
    modules = [OpenEng],
    pages = [
        "Home" => "index.md",
        "API Reference" => "api.md",
    ],
)

deploydocs(
    repo = "github.com/TheusHen/OpenEng.jl.git",
    devbranch = "main",
)
