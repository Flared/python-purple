venv: requirements.txt \
	  requirements.tests.txt
	rm -rf venv
	virtualenv -p python3 venv
	venv/bin/pip \
		install \
			-r requirements.txt \
			-r requirements.tests.txt
	venv/bin/python setup.py develop

.PHONY: format
format: venv
	venv/bin/black .

.PHONY: lint
lint: venv
	venv/bin/black --check .

.PHONY: test
test: install
	venv/bin/pytest purple -v --forked

.PHONY: install
install: venv
	venv/bin/python setup.py develop

.PHONY: run-simpleclient
run-simpleclient: install
	venv/bin/python examples/simpleclient.py

.PHONY: clean
clean:
	rm -rf venv
	rm -rf build
	rm -rf *.egg-info
	rm -rf dist
	rm -rf .pytest_cache
	find purple -type f -name "*.so" -exec rm {} \;
