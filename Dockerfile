FROM jupyter/scipy-notebook:latest

USER root
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.2-linux-x86_64.tar.gz && \
    tar -xvzf julia-1.6.2-linux-x86_64.tar.gz && \
    mv julia-1.6.2 /opt/ && \
    ln -s /opt/julia-1.6.2/bin/julia /usr/local/bin/julia && \
    rm julia-1.6.2-linux-x86_64.tar.gz 

USER ${NB_USER}

COPY --chown=${NB_USER}:users ./plutoserver ./plutoserver
COPY --chown=${NB_USER}:users ./environment.yml ./environment.yml
COPY --chown=${NB_USER}:users ./setup.py ./setup.py
COPY --chown=${NB_USER}:users ./runpluto.sh ./runpluto.sh

COPY --chown=${NB_USER}:users ./notebooks ./notebooks
COPY --chown=${NB_USER}:users ./Project.toml ./Project.toml
COPY --chown=${NB_USER}:users ./Manifest.toml ./Manifest.toml

ENV JULIA_PROJECT=/home/jovyan
RUN julia -e "import Pkg; Pkg.Registry.update(); Pkg.instantiate(); Pkg.add([Pkg.PackageSpec(name="Plots", version="0.29.9"),Pkg.PackageSpec(name="PlutoUI", version="0.7.1"), Pkg.PackageSpec(name="Distributions", version="0.23.8"), Pkg.PackageSpec(name="LaTeXStrings", version="1.3.0"),Pkg.PackageSpec(name="Random"),Pkg.PackageSpec(name="PlotlyJS", version="0.14.1"),Pkg.PackageSpec(name="DataFrames", version="0.21.8"),Pkg.PackageSpec(name="CSV", version="0.9.10"),Pkg.PackageSpec(name="ORCA", version="0.5.0"),Pkg.PackageSpec(name="Pluto", version="0.14.7")]); Pkg.status(); Pkg.precompile()"

RUN wget -q -O rate.csv http://github.com/Yofr3H/Estimation_stochastic_SIS/notebooks/SIS_stochastic/rate.csv

RUN jupyter labextension install @jupyterlab/server-proxy && \
    jupyter lab build && \
    jupyter lab clean && \
    pip install . --no-cache-dir && \
    rm -rf ~/.cache
