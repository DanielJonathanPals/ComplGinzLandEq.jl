using ComplGinzLandEq
using Documenter

DocMeta.setdocmeta!(ComplGinzLandEq, :DocTestSetup, :(using ComplGinzLandEq); recursive=true)

makedocs(;
    modules=[ComplGinzLandEq],
    authors="Daniel Pals <Daniel.Pals@tum.de>",
    repo="https://github.com/DanielJonathanPals/ComplGinzLandEq.jl/blob/{commit}{path}#{line}",
    sitename="ComplGinzLandEq.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Functions" => "function.md"
    ],
)

deploydocs(
    repo = "github.com/DanielJonathanPals/ComplGinzLandEq.jl.git",
)
