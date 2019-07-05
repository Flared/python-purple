
venv: requirements.txt
	rm -rf venv
	virtualenv -p python3 venv
	venv/bin/pip install -r requirements.txt
	venv/bin/python setup.py install

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
	rm -rf build
	rm -f purple.c
