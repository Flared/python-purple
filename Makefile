venv: requirements.txt
	rm -rf venv
	virtualenv -p python3 venv
	venv/bin/pip \
		install \
			-r requirements.txt \
			-r requirements.tests.txt
	venv/bin/python setup.py install

.PHONY: format
format: venv
	venv/bin/black .

.PHONY: lint
lint: venv
	venv/bin/black --check .

.PHONY: test
test: install
	venv/bin/pytest tests -v --forked

.PHONY: install
install: venv
	venv/bin/python setup.py install

.PHONY: run-nullclient
run-nullclient: install
	venv/bin/python examples/nullclient.py

.PHONY: clean
clean:
	rm -rf venv
	rm -rf build
	rm -f purple/purple.c
