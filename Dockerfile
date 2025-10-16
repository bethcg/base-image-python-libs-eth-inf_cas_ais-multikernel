FROM renku/renkulab-py:3.10-0.25.0
USER root

RUN apt-get update && \ 
    sudo apt-get install tesseract-ocr libgl1 --yes

USER ${NB_USER}

# install the python dependencies
COPY requirements*.txt environment.yml /tmp/
RUN mamba env update -q -f /tmp/environment.yml && \
    mamba clean -y --all && \
    mamba env export -n "root" && \
    rm -rf ${HOME}/.renku/venv
RUN virtualenv --system-site-packages ${HOME}/tensorflow-venv && \ 
    ${HOME}/tensorflow-venv/bin/pip install --no-cache-dir -r /tmp/requirements-tf.txt && \
    ${HOME}/tensorflow-venv/bin/python -m ipykernel install --user --name tensorflow --display-name Tensorflow && \
    virtualenv --system-site-packages ${HOME}/torch-venv && \ 
    ${HOME}/torch-venv/bin/pip install --no-cache-dir -r /tmp/requirements-torch.txt && \
    ${HOME}/torch-venv/bin/python -m ipykernel install --user --name torch --display-name Torch

RUN code-server --install-extension ms-python.python --install-extension ms-toolsai.jupyter