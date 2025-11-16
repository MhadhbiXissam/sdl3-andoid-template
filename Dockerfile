FROM ubuntu:22.04

ENV HOME=/root
ENV DEBIAN_FRONTEND=noninteractive
ENV force_color_prompt=yes
ENV color_prompt=yes
ENV PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
ENV PATH="/root/.local/bin/:${PATH}"

##################################################
#             Configure tzdata & Keyboard        #
##################################################
RUN <<EOF
echo -n '
XKBMODEL="pc105"
XKBLAYOUT="fr"
XKBVARIANT="azerty"
XKBOPTIONS=""
BACKSPACE="guess"
' > /etc/default/keyboard
EOF

RUN apt-get update && apt-get install -y locales tzdata \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 \
    && echo 'Europe/Paris' > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get install -y --no-install-recommends software-properties-common kbd

RUN echo "export PS1=\"$PS1\"" >> /root/.bashrc

##################################################
#              Setup Python 3.11                 #
##################################################
RUN apt update && apt install -y \
        python3.11 python3.11-venv python3.11-distutils \
        python3-pip \
    && ln -sf /usr/bin/python3.11 /usr/bin/python \
    && python3.11 -m pip install --upgrade pip \
    && python3.11 -m pip install virtualenv \
    && python3.11 -m virtualenv /opt/base
ENV PATH="/opt/base/bin:${PATH}"

##################################################
#                install linux tools             #
##################################################
RUN apt install -y tree lsof sudo nano unzip curl git build-essential cmake wget ninja-build mesa-utils libgl1-mesa-dri

##################################################
#              install Nim                       #
##################################################
RUN curl https://nim-lang.org/choosenim/init.sh -sSf | sh -s -- -y
ENV PATH="/root/.nimble/bin:${PATH}"

#################################################
#           install code-server                  #
##################################################
ENV VSCODE_SETTINGS='{"workbench.colorTheme": "Monokai Pro", "workbench.iconTheme": "Monokai Pro Icons", "window.customTitleBarVisibility": "auto", "workbench.sideBar.location": "left", "files.autoSave": "afterDelay", "window.commandCenter": false, "workbench.layoutControl.enabled": false, "workbench.activityBar.location": "top", "workbench.panel.alignment": "justify", "python.defaultInterpreterPath": "/opt/base/bin/python", "jupyter.jupyterServerType": "local", "python.terminal.activateEnvInCurrentTerminal": true}'

RUN curl -fsSL https://code-server.dev/install.sh | sh \
    && code-server --install-extension monokai.theme-monokai-pro-vscode \
    && code-server --install-extension ms-python.python \
    && code-server --install-extension ms-python.debugpy \
    && code-server --install-extension nimsaem.nimvscode \
    && mkdir -p /root/.local/share/code-server/User \
    && echo $VSCODE_SETTINGS > /root/.local/share/code-server/User/settings.json \
    && mkdir -p /root/project

EXPOSE 8000

##################################################
#           install git-setup                    #
##################################################
ENV GIT_USER=example
ENV GIT_EMAIL=example@gmail.com 
ENV GIT_TOKEN=1265465121sd5sf

##################################################
#         Install OpenJDK 17                     #
##################################################
RUN wget https://download.java.net/openjdk/jdk17.0.0.1/ri/openjdk-17.0.0.1+2_linux-x64_bin.tar.gz \
    -O /root/openjdk.tar.gz \
    && mkdir -p /root/jvm \
    && tar -xzf /root/openjdk.tar.gz -C /root/jvm \
    && rm /root/openjdk.tar.gz

ENV JAVA_HOME="/root/jvm/jdk-17.0.0.1"
ENV PATH="${JAVA_HOME}/bin:${PATH}"

##################################################
#           install Android SDK + NDK            #
##################################################
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"

RUN mkdir -p /opt/android-sdk/cmdline-tools

# Download command-line tools
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
    -O /tmp/cmd.zip \
    && unzip -q /tmp/cmd.zip -d /opt/android-sdk/cmdline-tools \
    && rm /tmp/cmd.zip

# Move into correct folder
RUN mkdir -p /opt/android-sdk/cmdline-tools/latest \
    && mv /opt/android-sdk/cmdline-tools/cmdline-tools/* /opt/android-sdk/cmdline-tools/latest/ \
    && rm -rf /opt/android-sdk/cmdline-tools/cmdline-tools

# Accept licenses
RUN yes | sdkmanager --licenses

# Install SDK packages
RUN sdkmanager --install \
    "platform-tools" \
    "build-tools;34.0.0" \
    "platforms;android-34"

# Install NDK 27
RUN sdkmanager --install "ndk;27.0.12077973"

ENV ANDROID_NDK_HOME=/opt/android-sdk/ndk/27.0.12077973
ENV PATH="${ANDROID_NDK_HOME}:${PATH}"

##################################################
#           Install Gradle 8.7                   #
##################################################
RUN wget -q https://services.gradle.org/distributions/gradle-8.7-bin.zip \
    -O /root/gradle.zip \
    && unzip /root/gradle.zip -d /root \
    && rm /root/gradle.zip

ENV GRADLE_HOME=/root/gradle-8.7
ENV PATH="${GRADLE_HOME}/bin:${PATH}"

##################################################
#              entrypoint script                 #
##################################################
ENTRYPOINT ["bash","/root/workspace/entrypoint.sh"]
