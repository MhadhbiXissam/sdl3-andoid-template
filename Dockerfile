FROM ubuntu:22.04

ENV HOME=/root
ENV DEBIAN_FRONTEND=noninteractive
ENV force_color_prompt=yes
ENV color_prompt=yes
ENV PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
ENV PATH="/root/.local/bin/:${PATH}"

##################################################
#             Configure tzdata                   #
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
    && apt-get install -y --no-install-recommends software-properties-common kbd \
    && echo "export PS1=\"$PS1\"" >> /root/.bashrc

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
RUN apt install -y tree lsof sudo nano unzip curl git build-essential cmake wget unzip ninja-build wget 

##################################################
#              install Nim                       #
##################################################
RUN curl https://nim-lang.org/choosenim/init.sh -sSf | sh -s -- -y
ENV PATH=/root/.nimble/bin:$PATH

##################################################
#              devic dri iris                     #
##################################################
RUN sudo apt install -y mesa-utils libgl1-mesa-dri

#################################################
#           install code-server                  #
##################################################
ENV VSCODE_SETTINGS='{"workbench.colorTheme": "Monokai Pro", "workbench.iconTheme": "Monokai Pro Icons", "window.customTitleBarVisibility": "auto", "workbench.sideBar.location": "left", "files.autoSave": "afterDelay", "window.commandCenter": false, "workbench.layoutControl.enabled": false, "workbench.activityBar.location": "top", "workbench.panel.alignment": "justify", "python.defaultInterpreterPath": "/opt/base/bin/python", "jupyter.jupyterServerType": "local", "python.terminal.activateEnvInCurrentTerminal": true}'

RUN curl -fsSL https://code-server.dev/install.sh | sh \
    && code-server --install-extension monokai.theme-monokai-pro-vscode \
    && code-server --install-extension ms-python.python \
    && code-server --install-extension ms-python.debugpy \
    && code-server --install-extension nimsaem.nimvscode \
    && mkdir -p /root/.config/code-server \
    && mkdir -p /root/.local/share/code-server/User \
    && mkdir -p $HOME/workspace \
    && echo $VSCODE_SETTINGS > /root/.local/share/code-server/User/settings.json \
    && mkdir /root/project

EXPOSE 8000

##################################################
#           install git-setup                    #
##################################################
ENV GIT_USER=example
ENV GIT_EMAIL=example@gmail.com 
ENV GIT_TOKEN=1265465121sd5sf

##################################################
#         Download OpenJDK 17 (Linux x64)        #
##################################################
run wget https://download.java.net/openjdk/jdk17.0.0.1/ri/openjdk-17.0.0.1+2_linux-x64_bin.tar.gz -O /root/openjdk-17.0.0.1+2_linux-x64_bin.tar.gz
RUN mkdir -p /root/jvm 
RUN tar -xzf /root/openjdk-17.0.0.1+2_linux-x64_bin.tar.gz -C /root/jvm 
RUN rm /root/openjdk-17.0.0.1+2_linux-x64_bin.tar.gz
#   Set JAVA_HOME and PATH
ENV JAVA_HOME="/root/jvm/jdk-17.0.0.1"
ENV PATH="/root/jvm/jdk-17.0.0.1/bin:${PATH}"



##################################################
#           install Android NDK & SDK            #
##################################################



ENV ANDROID_NDK_VERSION=r26d
ENV ANDROID_NDK_HOME=/opt/android-ndk
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"
run wget -q https://dl.google.com/android/repository/android-ndk-r26d-linux.zip  -O /root/android-ndk-r26d-linux.zip
run cd /root && unzip /root/android-ndk-${ANDROID_NDK_VERSION}-linux.zip
run mv /root/android-ndk-${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME} 
run rm /root/android-ndk-${ANDROID_NDK_VERSION}-linux.zip
env PATH="$ANDROID_NDK_HOME:$PATH"

# Install SDK command-line tools
RUN mkdir -p /opt/android-sdk && cd /opt/android-sdk 
run wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /opt/android-sdk/cmd.zip 
run cd /opt/android-sdk && unzip -q cmd.zip -d cmdline-tools \
    && rm cmd.zip \
    && mkdir -p cmdline-tools/latest \
    && mv cmdline-tools/cmdline-tools/* cmdline-tools/latest/ \
    && rm -rf cmdline-tools/cmdline-tools \
    && chmod +x cmdline-tools/latest/bin/* \
    && yes | cmdline-tools/latest/bin/sdkmanager --licenses \
    && cmdline-tools/latest/bin/sdkmanager "platform-tools" "build-tools;34.0.0" "platforms;android-34"
run $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --list

# Install graddle
run wget -q https://services.gradle.org/distributions/gradle-8.7-bin.zip -O  /root/gradle-8.7-bin.zip
run  cd /root && unzip gradle-8.7-bin.zip
ENV  GRADLE_HOME=/root/gradle-8.7
ENV  PATH=$GRADLE_HOME/bin:$PATH


##################################################
#              copy project                      #
##################################################
RUN mkdir -p /root/project
##################################################
#              entrypoint script                 #
##################################################
ADD docker-files/entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
