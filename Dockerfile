FROM runpod/pytorch:3.10-2.0.0-117

# Label your image with metadata
LABEL maintainer="davidkgp@gmail.com"
LABEL org.opencontainers.image.source https://github.com/davidkgp/invokeai_training
LABEL org.opencontainers.image.description "Runpod custom worker for invokeai training"

SHELL ["/bin/bash", "-c"]

WORKDIR /workspace

# Install missing dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils git wget && \
    apt clean && rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen | bash

COPY builder/requirements.txt /requirements.txt
RUN pip install --upgrade pip && \
    pip install -r /requirements.txt && \
    rm /requirements.txt && \
    pip install jupyter notebook

RUN git clone https://github.com/invoke-ai/invoke-training.git && \
    cd invoke-training && \
    python -m venv invoketraining

# Add src files (Worker Template)
ADD src .

CMD ["jupyter", "notebook"]
