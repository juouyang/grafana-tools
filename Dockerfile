# 使用 OpenShift CLI 鏡像作為基礎
FROM quay.io/openshift/origin-cli:latest

# 安裝 yq
RUN curl -L https://github.com/mikefarah/yq/releases/download/v4.30.8/yq_linux_amd64 -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

# 安裝 jq
RUN curl -L -o /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod +x /usr/local/bin/jq

CMD ["sleep", "3600"]
