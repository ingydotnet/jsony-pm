TMP := /tmp/readme
README := README.md.erb

readme:
	rm -fr $(TMP)
	cp -r . $(TMP)
	(cd $(TMP); git reset --hard; git checkout master)
	cp -f $(README) $(TMP)
	(cd $(TMP); erbit $(README); rm $(README))
