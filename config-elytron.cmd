
# Enable logging

/subsystem=logging/logger=org.wildfly.security:add(level=TRACE)
/subsystem=logging/logger=org.jboss.remoting.remote:add(level=TRACE)
/system-property=sun.security.krb5.debug:add(value=true)

# Configure GSSAPI and SPNEGO:

/subsystem=elytron/kerberos-security-factory=krbSFhttp:add(principal=HTTP/localhost@JBOSS.ORG, path=http.keytab, mechanism-names=[KRB5, SPNEGO])

/subsystem=elytron/kerberos-security-factory=krbSFremote:add(principal=remote/localhost@JBOSS.ORG, path=remote.keytab, mechanism-names=[KRB5])

/subsystem=elytron/sasl-authentication-factory=management-sasl-authentication:list-add(name=mechanism-configurations, value={mechanism-name=GSSAPI, credential-security-factory=krbSFremote})

/subsystem=elytron/http-authentication-factory=management-http-authentication:list-add(name=mechanism-configurations, value={mechanism-name=SPNEGO, mechanism-realm-configurations=[{realm-name=exampleFsSD}], credential-security-factory=krbSFhttp})

# Enable Elytron for management

/core-service=management/management-interface=http-interface:write-attribute(name=http-authentication-factory,value=management-http-authentication)
/core-service=management/management-interface=http-interface:write-attribute(name=http-upgrade.sasl-authentication-factory, value=management-sasl-authentication)
/core-service=management/management-interface=http-interface:undefine-attribute(name=security-realm)



