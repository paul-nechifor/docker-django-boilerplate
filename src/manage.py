#!/usr/bin/env python
import os
import sys

from django.core.management import execute_from_command_line

if __name__ == '__main__':
    sys.dont_write_bytecode = True
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'project.settings')
    execute_from_command_line(sys.argv)
