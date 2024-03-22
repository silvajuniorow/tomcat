#!/bin/bash
cp -r /usr/local/tomcat/webapps.dist/docs/ /usr/local/tomcat/webapps/
cp -r /usr/local/tomcat/webapps.dist/examples/ /usr/local/tomcat/webapps/
cp -r /usr/local/tomcat/webapps.dist/manager/ /usr/local/tomcat/webapps/
cp -r /usr/local/tomcat/webapps.dist/ROOT/ /usr/local/tomcat/webapps/

mv /usr/local/tomcat/conf/tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml_bkp
mv /usr/local/tomcat/webapps/docs/META-INF/context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml_bkp
mv /usr/local/tomcat/webapps/examples/META-INF/context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml_bkp
mv /usr/local/tomcat/webapps/manager/META-INF/context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml_bkp

#wget -P /usr/local/tomcat/webapps https://github.com/psi-probe/psi-probe/releases/download/psi-probe-3.7.2/probe.war

# Define o caminho para o arquivo server.xml
server_xml="/usr/local/tomcat/conf/server.xml"

if [ ! -f /usr/local/tomcat/webapps/probe.war ]; then
    echo "probe.war não encontrado, realizando download."
    wget -P /usr/local/tomcat/webapps https://github.com/psi-probe/psi-probe/releases/download/psi-probe-3.7.2/probe.war
else
    echo "probe.war já instalado!"
fi

file_users="/usr/local/tomcat/conf/tomcat-users.xml"

cat > $file_users << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
<!--
  NOTE:  By default, no user is included in the "manager-gui" role required
  to operate the "/manager/html" web application.  If you wish to use this app,
  you must define such a user - the username and password are arbitrary. It is
  strongly recommended that you do NOT use one of the users in the commented out
  section below since they are intended for use with the examples web
  application.
-->
<!--
  NOTE:  The sample user and role entries below are intended for use with the
  examples web application. They are wrapped in a comment and thus are ignored
  when reading this file. If you wish to configure these users for use with the
  examples web application, do not forget to remove the <!.. ..> that surrounds
  them. You will also need to set the passwords to something appropriate.
-->


  <role rolename="role1"/>
  <role rolename="manager-gui"/>
  <user username="tomcat" password="s3cret" roles="tomcat,role1,manager-gui"/>
  <user username="role1" password="tomcat" roles="role1"/>

</tomcat-users>
EOF

context_docs="/usr/local/tomcat/webapps/docs/META-INF/context.xml"
cat > $context_docs << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<Context antiResourceLocking="false" >
  <!--Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /-->
</Context>
EOF

context_examples="/usr/local/tomcat/webapps/examples/META-INF/context.xml"
cat > $context_examples << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<Context>
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
                   sameSiteCookies="strict" />
  <!--Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /-->
</Context>
EOF

context_mng="/usr/local/tomcat/webapps/manager/META-INF/context.xml"
cat > $context_mng << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<Context antiResourceLocking="false" privileged="true" >
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
                   sameSiteCookies="strict" />
  <!--Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /-->
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>
</Context>
EOF
