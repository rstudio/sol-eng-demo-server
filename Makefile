RSP_VERSION ?= 1.4.1717-3
CODE_SERVER_VERSION ?= 3.2.0

update-versions:  ## Update the version files for all products
	@sed -i '' "s/^.*/${RSP_VERSION}/g" rsp-version.txt
	@sed -i '' "s/^ARG RSP_VERSION=.*/ARG RSP_VERSION=${RSP_VERSION}/g" Dockerfile
	@sed -i '' "s/^ARG RSP_VERSION=.*/ARG RSP_VERSION=${RSP_VERSION}/g" Dockerfile_multi
	@sed -i '' "s/^ARG RSP_VERSION=.*/ARG RSP_VERSION=${RSP_VERSION}/g" helper/launcher/Dockerfile
	@sed -i '' "s/^ARG RSP_VERSION=.*/ARG RSP_VERSION=${RSP_VERSION}/g" helper/workbench/Dockerfile

vars:
	echo "packages:" > goss_vars.yaml && \
	cat pkg_names.csv | tail -n +2 | grep -v -f pkg_failing.txt | sort | uniq | sed -E 's/(^.*)/  - "\1"/g' >> goss_vars.yaml

test:
	GOSS_VARS=goss_vars.yaml dgoss run -it -e R_VERSION=3.6.1 075258722956.dkr.ecr.us-east-1.amazonaws.com/sol-eng-demo-server:1.2.5019-6-3.6

edit:
	GOSS_VARS=goss_vars.yaml dgoss edit -it -e R_VERSION=3.6.1 075258722956.dkr.ecr.us-east-1.amazonaws.com/sol-eng-demo-server:1.2.5019-6-3.6

build-apache:
	docker build ./helper/apache-proxy/

build-%:
	docker build -t rstudio-test/$* ./helper/$*/
