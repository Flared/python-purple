#!/usr/bin/env python3

from distutils.core import setup
from distutils.extension import Extension

from Cython.Distutils import build_ext
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
    include_path=["libpurple"],
)

long_description = "\
Python bindings for libpurple, a multi-protocol instant messaging library."

setup(
    name="python-purple",
    version="0.1",
    author="Bruno Abinader",
    author_email="bruno.abinader@openbossa.org",
    description="Python bindings for Purple",
    long_description=long_description,
    ext_modules=ext_modules,
)
