vars:
	echo "packages:" > goss_vars.yaml && \
	cat pkg_names.csv | tail -n +2 | grep -v -f pkg_failing.txt | sort | uniq | sed -E 's/(^.*)/  - "\1"/g' >> goss_vars.yaml
