FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

WORKDIR /workspace

# System dependencies
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3-pip \
    python3.11-dev \
    build-essential \
    git \
    curl \
    pandoc \
    texlive-latex-base \
    texlive-fonts-recommended \
    texlive-latex-extra \
    texlive-xetex \
    && rm -rf /var/lib/apt/lists/*

# Make python3.11 default python
RUN ln -s /usr/bin/python3.11 /usr/bin/python || true

# Python tooling
RUN pip install --upgrade pip && pip install uv

# Python dependencies
COPY requirements.txt .
RUN uv pip install --system -r requirements.txt


# Jupyter settings
ENV JUPYTER_CONFIG_DIR=/root/.jupyter
ENV JUPYTERLAB_SETTINGS_DIR=/root/.jupyter/lab/user-settings

COPY jupyter-settings/ /root/.jupyter/


EXPOSE 8888

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.token=", "--ServerApp.password=","--ServerApp.disable_check_xsrf=True"]
