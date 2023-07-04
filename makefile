SHELL := /usr/bin/env bash

format:
	cd nat-instances && terraform fmt --check
	cd nat-instances && terraform fmt -recursive