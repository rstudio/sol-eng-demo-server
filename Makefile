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
