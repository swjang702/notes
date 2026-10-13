#!/bin/sh

mdfile=$1
html="${mdfile%.md}.html"
#pandoc $mdfile -s -f markdown+hard_line_breaks -o $html
pandoc $mdfile -f markdown+hard_line_breaks -o $html
