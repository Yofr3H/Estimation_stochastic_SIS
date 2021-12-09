using PackageCompiler
create_sysimage([:Pluto, :PlutoUI, :Distributions, :Plots,:LaTeXStrings,:Random, :PlotlyJS, :DataFrames, :CSV];
                precompile_execution_file = "/notebooks/SIS_stochastic/notebook_SIS.jl",
                replace_default = true,
                cpu_target = PackageCompiler.default_app_cpu_target())
