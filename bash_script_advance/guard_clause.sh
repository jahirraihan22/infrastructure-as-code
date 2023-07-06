#!/bin/bash

# guard clause is the technique to check critical statement to prevent interrupt code

[[ -z ${1} ]] && { echo  "ARG EMPTY"; exit 1}
