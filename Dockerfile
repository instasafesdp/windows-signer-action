FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386
RUN sed -i "s/main/main contrib non-free/" etc/apt/sources.list
RUN apt-get update && apt-get install -yq wine curl unrar unzip libcurl4-openssl-dev autoconf gcc make libssl-dev p7zip-full || apt-get install -yq wine curl unrar unzip libcurl4-openssl-dev autoconf gcc make libssl-dev p7zip-full || apt-get install -yq wine curl unrar unzip libcurl4-openssl-dev autoconf gcc make libssl-dev p7zip-full

# innosetup
RUN mkdir innosetup && \
    cd innosetup && \
    curl -fsSL -o innounp045.rar "https://downloads.sourceforge.net/project/innounp/innounp/innounp%200.45/innounp045.rar?r=&ts=1439566551&use_mirror=skylineservers" && \
    unrar e innounp045.rar

RUN cd innosetup && \
    curl -fsSL -o is-unicode.exe http://files.jrsoftware.org/is/5/isetup-5.5.8-unicode.exe && \
    wine "./innounp.exe" -e "is-unicode.exe"

RUN apt-get update && apt-get install libgsf-1-dev -y

RUN mkdir /osslsigncode && \
    cd /osslsigncode && \
    curl -fsSL -o osslsigncode-1.7.1.tar.gz "http://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.7.1.tar.gz?r=&ts=1469050502&use_mirror=skylineservers" && \
    tar -xzf osslsigncode-1.7.1.tar.gz && \
    cd osslsigncode-1.7.1 && \
    ./configure && \
    make

LABEL "name"="Windows Signing Utility"
LABEL "maintainer"="Jon Friesen"
LABEL "version"="0.1.0"

LABEL "com.github.actions.name"="Windows Signing Utility"
LABEL "com.github.actions.description"="Windows Signing Utility"
LABEL "com.github.actions.icon"="key"
LABEL "com.github.actions.color"="green"


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]