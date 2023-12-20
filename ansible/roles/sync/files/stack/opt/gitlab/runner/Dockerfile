FROM gitlab/gitlab-runner:v16.5.0

RUN apt update && \
    apt install -y python3-pip git curl dnsutils ansible software-properties-common && \
    pip3 install docker-compose && \
    pip3 install ansible-lint
    