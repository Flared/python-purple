#!/usr/bin/env python3

from setuptools import setup
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

ext_modules = cythonize(
    Extension(
        "purple",
        sources=["purple/c_purple.c", "purple/purple.pyx"],
        extra_compile_args=cflags,
        extra_link_args=ldflags,
    ),
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
    ext_modules=ext_modules,
)
