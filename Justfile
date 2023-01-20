set positional-arguments

cmd_vars := "-i ''"
sed_vars := if os() == "macos" { "-i ''" } else { "-i" }

BUILDX_PATH := ""

RSW_VERSION := "2022.12.0"

# just RSW_VERSION=1.2.3 update-rsw-versions
update-versions:
  #!/usr/bin/env bash
  set -euxo pipefail
  if [[ `echo "{{ RSW_VERSION }}" | grep '+'` ]]; then
    echo "ERROR: Make sure that there is no '+' sign in the version you define. Got: {{ RSW_VERSION }}"
    exit 1
  fi
    sed {{ sed_vars }} "s/^.*/{{ RSW_VERSION }}/g" rsp-version.txt
    sed {{ sed_vars }} "s/^ARG RSP_VERSION=.*/ARG RSP_VERSION={{ RSW_VERSION }}/g" Dockerfile
    sed {{ sed_vars }} "s/^ARG RSP_VERSION=.*/ARG RSP_VERSION={{ RSW_VERSION }}/g" multi.Dockerfile
    #sed {{ sed_vars }} "s/^ARG RSP_VERSION=.*/ARG RSP_VERSION={{ RSW_VERSION }}/g" helper/launcher/Dockerfile
    #sed {{ sed_vars }} "s/^ARG RSP_VERSION=.*/ARG RSP_VERSION={{ RSW_VERSION }}/g" helper/workbench/Dockerfile

# just vars
vars:
    #!/usr/bin/env bash
    set -euxo pipefail
    echo "packages:" > goss_vars.yaml && \
    cat pkg_names.csv | tail -n +2 | grep -v -f pkg_failing.txt | sort | uniq | sed -E 's/(^.*)/  - "\1"/g' >> goss_vars.yaml

# just test
test:
    GOSS_VARS=goss_vars.yaml dgoss run -it -e R_VERSION=3.6.1 075258722956.dkr.ecr.us-east-1.amazonaws.com/sol-eng-demo-server:1.2.5019-6-3.6

# just edit
edit:
    GOSS_VARS=goss_vars.yaml dgoss edit -it -e R_VERSION=3.6.1 075258722956.dkr.ecr.us-east-1.amazonaws.com/sol-eng-demo-server:1.2.5019-6-3.6

# just build-apache
build-apache:
    #!/usr/bin/env bash
    set -euxo pipefail
    docker build ./helper/apache-proxy/

# just build-%
build-all:
    #!/usr/bin/env bash
    set -euxo pipefail
    docker build -t rstudio-test/$* ./helper/$*/
