#!/bin/bash
project=${1}
branch=${2}
project_dir="$(basename ${project} .git)"

clone_project() {
  if [ ! -d "/home/bob/git/${project_dir}" ]; then
    cd /home/bob/git/
    git clone ${project}
  fi
}

git_checkout() {
  cd "${project_dir}"
  git checkout -b "${branch}"
}


find_files() {
  find "/home/bob/git/${project_dir}" -type f | wc -l
}
clone_project
git_checkout
find_files
