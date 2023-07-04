SHELL := /usr/bin/env bash

format:
	cd nat-instances && terraform fmt -recursive