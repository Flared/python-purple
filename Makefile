
venv: requirements.txt
	rm -rf venv
	virtualenv -p python3 venv
	venv/bin/pip install -r requirements.txt
	python setup.py install

.PHONY: build
build: venv
	venv/bin/python setup.py build

.PHONY: clean
clean:
	rm -rf venv
	rm -rf build
	rm -f purple.c
