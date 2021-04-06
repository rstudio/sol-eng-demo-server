FROM quay.io/maksymbilenko/oracle-12c

COPY data /tmp/data
COPY setup.sql /docker-entrypoint-initdb.d/setup.sql
RUN chmod 755 /tmp/data
