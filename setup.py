#
#  Copyright (c) 2019 Flare Systems Inc.
#  Copyright (c) 2008 INdT - Instituto Nokia de Tecnologia
#
#  This file is part of python-purple.
#
#  python-purple is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  python-purple is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#!/usr/bin/env python3

import os

from setuptools import setup
from setuptools import find_packages
from setuptools import dist

from distutils.extension import Extension
from subprocess import Popen, PIPE
from collections import namedtuple

from Cython.Build import cythonize

cflags = (
    Popen(["pkg-config", "--cflags", "purple"], stdout=PIPE)
    .communicate()[0]
    .decode()
    .split()
)

# macOS fixup.
cflags.extend(
    p.replace("/include/libpurple", "/include")
    for p in cflags
    if "Cellar/pidgin/" in p and "/include/libpurple" in p
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

ExtensionInfo = namedtuple("ExtensionInfo", ["name", "sources"])


def scandir(dir, ext_infos=[]):

    for file in os.listdir(dir):
        path = os.path.join(dir, file)

        if os.path.isfile(path) and path.endswith(".pyx"):
            ext_infos.append(
                ExtensionInfo(
                    name=path[: -len(".pyx")].replace(os.path.sep, "."),
                    sources=[path],
                )
            )

        elif os.path.isdir(path):
            scandir(path, ext_infos)

    return ext_infos


def make_extension(ext_info):
    return Extension(
        ext_info.name,
        ["purple/c_purple.c"] + ext_info.sources,
        include_dirs=[
            "include",
            ".",
        ],  # adding the '.' to include_dirs is CRUCIAL!!
        extra_compile_args=cflags,
        extra_link_args=ldflags,
    )


ext_infos = scandir("purple")

ext_modules = [make_extension(ext_info) for ext_info in ext_infos]

cythonized_modules = cythonize(
    ext_modules,
    include_path=["include"],
    build_dir="build",
    compiler_directives={
        "language_level": "3",
        "legacy_implicit_noexcept": True,
    },
)

long_description = "\
Python bindings for libpurple, a multi-protocol instant messaging library."

setup(
    name="python-purple",
    version="0.1.5",
    author="Alexandre Viau",
    author_email="alexandre.viau@flare.systems",
    description="Python bindings for libpurple",
    long_description=long_description,
    ext_modules=cythonized_modules,
    packages=find_packages(),
    setup_requires=["Cython>=3"],
    package_data={"purple": ["py.typed"]},
    zip_safe=False,
)
