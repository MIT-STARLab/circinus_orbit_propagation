#! /usr/bin/env python

##
# Tool for validating a json file per its corresponding schema file
# @author Kit Kennedy
#

import os
import json
from jsonschema import validate, RefResolver
from jsonschema.exceptions import ValidationError as ve

import argparse

# Define parser for command line arguments
ap = argparse.ArgumentParser(description='tool for validating a .json file per its corresponding schema')
ap.add_argument("schema_file", 
	help='.json schema_file file that specifices the schema from which to validate. \
	Either name of file within same dir as this script, or a file name preceded by absolute path')
ap.add_argument("instance_file", 
	help='.json instance_file file that specifices the schema instance to be validated \
	Either name of file within same dir as this script, or a file name preceded by absolute path')
ap.add_argument('-v','--verbose',
                action='store_true',
                help='controls verbosity of script')

# Parse the command line arguments
args = ap.parse_args()	

schema_file = args.schema_file
instance_file = args.instance_file

if not os.path.exists(schema_file):
	schema_file = os.path.join(os.getcwd(),schema_file)
if not os.path.exists(instance_file):
	instance_file = os.path.join(os.getcwd(),instance_file)

schema_full_path = os.path.join(os.getcwd(),schema_file)
schema_path = os.path.dirname(schema_full_path)

schema_uri = 'file:///{0}/'.format(schema_path)
resolver = RefResolver(schema_uri, schema_file)

with open(instance_file,'r') as f:
	instance = json.load(f)
with open(schema_file,'r') as f:
	schema = json.load(f)

passed = False
try:
	validate(instance, schema, resolver=resolver)
	passed = True
except ve as e:
	print('saw jsonschema.exceptions.ValidationError')
	print('e.message')
	print(e.message)
	
	if args.verbose:
		print('e.schema')
		print(e.schema)
		print('e.instance')
		print(e.instance)
		print('e.cause')
		print(e.cause)
		print('e.context')
		print(e.context)

if passed:
	print('Passed')