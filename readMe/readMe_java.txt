
# Set JAVA_HOME to Corretto 11
export JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto

# Add JAVA bin directory to the PATH variable
# Like we have added JAVA_HOME path, we will now update the PATH variable as well. To do that, enter the following command on the terminal.
export PATH=$PATH:$JAVA_HOME/bin

== Check Java version and set it on Arch ==
╭─bakerg@DEEPFRI3-V1000 ~
╰─$ java -version
openjdk version "1.8.0_265"
OpenJDK Runtime Environment (build 1.8.0_265-b01)
OpenJDK 64-Bit Server VM (build 25.265-b01, mixed mode)
╭─bakerg@DEEPFRI3-V1000 ~
╰─$ sudo archlinux-java
archlinux-java <COMMAND>
    COMMAND:
    status          List installed Java environments and enabled one
    get             Return the short name of the Java environment set as default
    set <JAVA_ENV>  Force <JAVA_ENV> as default
    unset           Unset current default Java environment
    fix             Fix an invalid/broken default Java environment configuration
╭─bakerg@DEEPFRI3-V1000 ~
╰─$ sudo archlinux status
sudo: archlinux: command not found
╭─bakerg@DEEPFRI3-V1000 ~
╰─$ sudo archlinux-java status                                                                                                                                                  1 ↵
Available Java environments:
java-11-amazon-corretto
java-8-openjdk (default)
╭─bakerg@DEEPFRI3-V1000 ~
╰─$ sudo archlinux-java set java-11-amazon-corretto
╭─bakerg@DEEPFRI3-V1000 ~
╰─$ java -version
openjdk version "11.0.9.1" 2020-11-04 LTS
OpenJDK Runtime Environment Corretto-11.0.9.12.1 (build 11.0.9.1+12-LTS)
OpenJDK 64-Bit Server VM Corretto-11.0.9.12.1 (build 11.0.9.1+12-LTS, mixed mode)
╭─bakerg@DEEPFRI3-V1000 ~
╰─$ javac -version
javac 11.0.9.1

