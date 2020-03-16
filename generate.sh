#!/bin/sh

# ########################################### COLORS

NOCOLOR='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'

# ########################################### VARIABLES

dependencies="@babel/cli @babel/core @babel/preset-env @babel/preset-flow @babel/node @babel/plugin-transform-runtime @babel/register @babel/runtime babel-eslint eslint eslint-config-airbnb-base eslint-config-prettier eslint-plugin-flowtype eslint-plugin-import eslint-plugin-prettier flow-bin prettier nodemon"

printf "${YELLOW}Project [name]: ${NOCOLOR}"
read -r project_name

printf "${YELLOW}Project [description]: ${NOCOLOR}"
read -r project_description

printf "${YELLOW}Project [repository]: ${NOCOLOR}"
read -r project_repository

printf "${YELLOW}Author [name]: ${NOCOLOR}"
read -r author_name

printf "${YELLOW}Author [email]: ${NOCOLOR}"
read -r author_email

license_year=$(date +%Y)
license_holder=${author_name^^}

# Replacements on package.json
declare -a package_searchs=("author.name" "author.email" "project.name" "project.description" "project.repository")
declare -a package_replacements=("$author_name" "$author_email" "$project_name" "$project_description" "$project_repository")

# Replacements on LICENSE
declare -a license_searchs=("license.year" "license.holder")
declare -a license_replacements=("$license_year" "$license_holder")

# Replacements on README.md
declare -a readme_searchs=("project.name" "project.description")
declare -a readme_replacements=("$project_name" "$project_description")

# ########################################### FUNCTIONS

placeholders_replacer() {
    # package.json
    for ((i = 0; i < ${#package_searchs[@]}; i++))
    do
        sed -i -e "s~${package_searchs[$i]}~${package_replacements[$i]}~g" "./${project_name}/package.json"
    done

    # LICENSE
    for ((i = 0; i < ${#license_searchs[@]}; i++))
    do
        sed -i -e "s/${license_searchs[$i]}/${license_replacements[$i]}/g" "./${project_name}/LICENSE"
    done

    # README.md
    for ((i = 0; i < ${#readme_searchs[@]}; i++))
    do
        sed -i -e "s/${readme_searchs[$i]}/${readme_replacements[$i]}/g" "./${project_name}/README.md"
    done
}

# ########################################### PROJECT GENERATION

echo -e "Creating project directory as ${GREEN}${project_name}${NOCOLOR}"
mkdir $project_name
cp -a ./template/. ./$project_name/
placeholders_replacer
cd ./$project_name

echo -e "Installing dependencies with ${LIGHTBLUE}yarn${NOCOLOR}"
yarn add $dependencies --dev

echo -e "Initiating git repository"
git init
git config user.name "$author_name"
git config user.email "$author_email"
git remote add origin "$project_repository"
git add .
git commit -m "feat: initial commit"