FROM debian:buster-slim

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y \
    python3-pip gnupg software-properties-common curl openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
  apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
  apt-get update && apt-get install -y terraform

RUN pip3 install \
    ansible==2.10.7 boto3 && \
    rm -rf /root/.cache/pip

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

WORKDIR /ansible

COPY . /ansible

EXPOSE 22

CMD [ "ansible-playbook", "--version" ]