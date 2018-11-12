# -*- coding: utf-8 -*-
"""
Spyder Editor

This temporary script file is located here:
C:\Users\Lee\.spyder2\.temp.py
"""
from distutils.core import setup

import py2exe


setup(
    options = {
        "py2exe": {
            "dll_excludes": ["MSVCP90.dll"]
        }
    },
)

setup(console=['userintvoff.py'])