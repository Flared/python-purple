#!/usr/bin/env python3

import os
from setuptools import setup, find_packages
from distutils.extension import Extension
from Cython.Build import cythonize
from subprocess import Popen, PIPE

cflags = (
    Popen(["pkg-config", "--cflags", "purple"], stdout=PIPE)
    .communicate()[0]
    .decode()
    .split()
)
ldflags = (
    Popen(["pkg-config", "--libs", "purple"], stdout=PIPE)
    .communicate()[0]
    .decode()
    .split()
)

# Note: Some if this setup was copied from the cython wiki:
# - https://github.com/cython/cython/wiki/PackageHierarchy

# scan the 'purple' directory for extension files, converting
# them to extension names in dotted notation
def scandir(dir, files=[]):
    for file in os.listdir(dir):
        path = os.path.join(dir, file)
        if os.path.isfile(path) and path.endswith(".pyx"):
            files.append(path.replace(os.path.sep, ".")[:-4])
        elif os.path.isdir(path):
            scandir(path, files)
    return files


# generate an Extension object from its dotted name
def make_extension(ext_name):
    ext_path = ext_name.replace(".", os.path.sep) + ".pyx"
    return Extension(
        ext_name,
        ["purple/c_purple.c", ext_path],
        include_dirs=[
            "include",
            ".",
        ],  # adding the '.' to include_dirs is CRUCIAL!!
        extra_compile_args=cflags,
        extra_link_args=ldflags,
    )


ext_names = scandir("purple")

ext_modules = [make_extension(name) for name in ext_names]

cythonized_modules = cythonize(
    ext_modules,
    include_path=["include"],
    build_dir="build",
    compiler_directives={"language_level": "3"},
)

long_description = "\
Python bindings for libpurple, a multi-protocol instant messaging library."

setup(
    name="python-purple",
    version="0.1",
    author="Alexandre Viau",
    author_email="alexandre.viau@flare.systems",
    description="Python bindings for libpurple",
    long_description=long_description,
    ext_modules=cythonized_modules,
    packages=["purple"],
)
