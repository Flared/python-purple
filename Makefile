
venv: requirements.txt
	rm -rf venv
	virtualenv -p python3 venv
	venv/bin/pip install -r requirements.txt
	venv/bin/python setup.py install

venv-test: requirements.txt \
           requirements.tests.txt
	rm -rf venv-test
	virtualenv -p python3 venv-test
	venv-test/bin/pip \
		install \
		-r requirements.txt \
		-r requirements.tests.txt
	venv-test/bin/python setup.py install

.PONY: format
format:
	venv-test/bin/black \
		-t py37 \
		-l 80 \
		--exclude "(venv|venv-test)" \
		.

.PHONY: build
build: venv
	venv/bin/python setup.py build

.PHONY: install
install: build
	venv/bin/python setup.py install

.PHONY: run-nullclient
run-nullclient: install
	venv/bin/python nullclient.py

.PHONY: clean
clean:
	rm -rf venv
	rm -rf venv-test
	rm -rf build
	rm -f purple.c
