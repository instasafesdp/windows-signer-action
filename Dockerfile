FROM debian:bullseye

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386
RUN sed -i "s/main/main contrib non-free/" etc/apt/sources.list
RUN apt-get update && apt-get install -yq curl libcurl4-openssl-dev autoconf gcc make libssl-dev || apt-get install -yq curl libcurl4-openssl-dev autoconf gcc make libssl-dev || apt-get install -yq curl libcurl4-openssl-dev autoconf gcc make libssl-dev

# # innosetup
# RUN mkdir innosetup && \
#     cd innosetup && \
#     curl -fsSL -o innounp045.rar "https://downloads.sourceforge.net/project/innounp/innounp/innounp%200.45/innounp045.rar?r=&ts=1439566551&use_mirror=skylineservers" && \
#     unrar e innounp045.rar

# RUN cd innosetup && \
#     curl -fsSL -o is-unicode.exe http://files.jrsoftware.org/is/5/isetup-5.5.8-unicode.exe && \
#     wine "./innounp.exe" -e "is-unicode.exe"

RUN apt-get update && apt-get install libgsf-1-dev -y

RUN mkdir /osslsigncode && \
    cd /osslsigncode && \
    curl -fsSL -o osslsigncode-2.3.0.tar.gz "https://github.com/mtrojnar/osslsigncode/releases/download/2.3/osslsigncode-2.3.0.tar.gz" && \
    tar -xzf osslsigncode-2.3.0.tar.gz && \
    cd osslsigncode-2.3.0 && \
    ./configure && \
    make

LABEL "name"="Windows Signing Utility"
LABEL "maintainer"="Jon Friesen"
LABEL "version"="1.1.1"

LABEL "com.github.actions.name"="Windows Signing Utility"
LABEL "com.github.actions.description"="Windows Signing Utility"
LABEL "com.github.actions.icon"="key"
LABEL "com.github.actions.color"="green"


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]