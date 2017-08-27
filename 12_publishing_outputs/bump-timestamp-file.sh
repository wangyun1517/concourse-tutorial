#!/bin/sh

set -e # fail fast
set -x # print commands

git clone resource-gist updated-gist

cd updated-gist
echo $(date) > test-for-concourse

git config --global user.email "640238027@qq.com"
git config --global user.name "Concourse"

git add .
git commit -m "Bumped date"
