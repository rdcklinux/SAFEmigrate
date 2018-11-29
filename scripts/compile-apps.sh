#!/bin/bash

test_install(){
  if ! test -x ~/safe_project/src; then
    mkdir -p ~/safe_project/src;
    cd ~/safe_project/src;
    git clone https://github.com/fzunigad/administradorSAFE.git web.net;
    git clone https://github.com/rodedition/WS_APP_SAFE.git ws.java;
    wget https://github.com/NuGet/Home/releases/download/3.3/NuGet.exe -O ../nuget
    wget https://www-eu.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz -O ../maven.tar.gz;
    tar -xzf ../maven.tar.gz -C /opt/apps/;
    wget https://github.com/rdcklinux/SAFEDesktop/raw/master/ojdbc8.jar -O /opt/apps/ojdbc8.jar;
  fi
}

compile_dotnet(){
  cd ~/safe_project/src/web.net;
  git pull origin master;
  mono ~/safe_project/nuget restore .
  msbuild administradorSAFE /p:Configuration=Release;

  rm -rf /opt/apps/web/safews;
  cp -r administradorSAFE /opt/apps/web/safews;
}

compile_angular(){
  cd ~/safe_project/src/web.net;
  git pull origin master;
  cd administradorSAFE/Angular;
  npm install;
  ng build --output-path=/opt/apps/web/front;
}

compile_java(){
  cd ~/safe_project/src/ws.java;
  git pull origin master;
  cd APP_SAFE;
  if ! test -x src/main/java; then
    ln -s Java src/main/java;
  fi
  export M2_HOME=/opt/apps/apache-maven-3.6.0/;
  export PATH=${M2_HOME}/bin:${PATH};
  export JAVA_HOME=/opt/apps/jdk1.8.0_144;
  mvn install:install-file -Dfile=/opt/apps/ojdbc8.jar -DgroupId=unknown.binary -DartifactId=ojdbc8 -Dversion=SNAPSHOT -Dpackaging=jar;
  mvn -Dfile.encoding=windows-1250 clean;
  mvn -Dfile.encoding=windows-1250 install;
  rm /opt/apps/weblogic/domain/autodeploy/APP_SAFE.war;
  cp target/APP_SAFE.war /opt/apps/weblogic/domain/autodeploy/;
}

compile_all(){
 compile_dotnet;
 compile_angular;
 compile_java;
}


app=$1;

test_install;

if [[ $app == 'net' ]]; then
 echo "Compiling .NET app";
 compile_dotnet;
fi

if [[ $app == 'ng' ]]; then
 echo "Compiling Angular app";
 compile_angular;
fi

if [[ $app == 'java' ]]; then
 echo "Compiling Java app";
 compile_java;
fi

if [[ $app == 'all' ]]; then
 echo "Compiling ALL apps";
 compile_all;
fi

if [[ $app == '' ]]; then
 echo "Usage: compile-apps.sh <net|ng|java|all>"
else
 echo "Process finished!"
fi

exit 0;

