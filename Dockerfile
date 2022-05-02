FROM continuumio/miniconda3

# RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
#     bash miniconda.sh -b -p miniconda && \
#     rm -f Miniconda3-latest-Linux-x86_64.sh && \
#     conda initialize bash

RUN git clone --branch 5.3.1 --depth 1 https://github.com/pcdshub/pcds-envs && \
    cd pcds-envs && \
    cp -f condarc $HOME/.condarc

WORKDIR pcds-envs

RUN conda config --set always_yes yes --set changeps1 no && \
    conda install conda-build anaconda-client packaging mamba && \
    conda info -a

# TODO build-essential is definitely required; the WM and libxkb are likely not
RUN apt update -y && \
    apt install -y build-essential libxkbcommon-x11-0 herbstluftwm

# Always create the environment from yaml
RUN mamba env create -q -n pcds-test -f envs/pcds/env.yaml

RUN conda init bash && \
    echo "source ~/.bashrc" >> ~/.bash_profile && \
    echo "conda activate pcds-test" >> ~/.bashrc && \
    echo 'export PS1="(conda env \$(basename \$CONDA_DEFAULT_ENV)) $PS1"' >> ~/.bashrc

# Subsequent "RUN" commands use the pcds-test env:
SHELL ["conda", "run", "-n", "pcds-test", "/bin/bash", "-c"]

# RUN cd scripts && \
#     python test_setup.py pcds --tag

SHELL ["/bin/bash", "--login", "-c"]

ENTRYPOINT /bin/bash
