# Include Python
FROM python:3.10-alpine

# Label your image with metadata
LABEL maintainer="davidkgp@gmail.com"
LABEL org.opencontainers.image.source https://github.com/davidkgp/invokeai_training
LABEL org.opencontainers.image.description "Runpod custom worker for invokeai training"

# Define your working directory
WORKDIR /

RUN apt-get update && apt-get install -y \
    git \
    wget

COPY builder/requirements.txt /requirements.txt
RUN pip install --upgrade pip && \
    pip install -r /requirements.txt && \
    rm /requirements.txt

RUN git clone https://github.com/invoke-ai/invoke-training.git && \
    cd invoke-training && \
    python -m venv invoketraining && \
    source invoketraining/bin/activate && \
    python -m pip install --upgrade pip && \
    pip install ".[test]" --extra-index-url https://download.pytorch.org/whl/cu121

# Add src files (Worker Template)
ADD src .

CMD [ "python", "-u", "/rp_handler.py" ]
