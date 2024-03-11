FROM runpod/pytorch:3.10-2.0.0-117

# Label your image with metadata
LABEL maintainer="davidkgp@gmail.com"
LABEL org.opencontainers.image.source https://github.com/davidkgp/invokeai_training
LABEL org.opencontainers.image.description "Runpod custom worker for invokeai training"

SHELL ["/bin/bash", "-c"]

ENV SHELL=/bin/bash

WORKDIR /workspace

# Loosen up /workspace perms
RUN chmod a+rw /workspace && \
     useradd -ms /bin/bash disco
USER disco

# Install missing dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends apt-utils git wget bash && \
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen | bash

COPY builder/requirements.txt /requirements.txt
RUN pip install --upgrade pip && \
    pip install -r /requirements.txt && \
    rm /requirements.txt && \
    pip install jupyterlab && \
    echo 'export PATH="$HOME/.local/bin:$HOME/.local/bin/jupyter-lab:$PATH"' >> ~/.bashrc

RUN cd /workspace && git clone https://github.com/invoke-ai/invoke-training.git && \
    cd invoke-training && \
    python -m venv invoketraining && \
    source invoketraining/bin/activate

ADD builder/start.sh /start.sh
CMD [ "/start.sh" ]