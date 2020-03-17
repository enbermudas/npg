#!/bin/sh

# ########################################### COLORS

NOCOLOR='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'

# ########################################### VARIABLES

dependencies="@babel/cli @babel/core @babel/node @babel/plugin-transform-runtime @babel/preset-env @babel/preset-flow @babel/register @babel/runtime babel-eslint babel-jest babel-plugin-module-resolver codecov eslint eslint-config-airbnb-base eslint-config-prettier eslint-import-resolver-babel-module eslint-plugin-flowtype eslint-plugin-import eslint-plugin-prettier flow-bin jest nodemon prettier"

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

printf "${YELLOW}Codecov [token]: ${NOCOLOR}"
read -r codecov_token

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

# Replacements on codecov.yml and .circleci/config.yml
declare -a codecov_searchs=("codecov.token")
declare -a codecov_replacements=("$codecov_token")

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

    # codecov.yml
    sed -i -e "s/codecov.token/${codecov_token}/g" "./${project_name}/codecov.yml"
    sed -i -e "s/codecov.token/${codecov_token}/g" "./${project_name}/.circleci/config.yml"
}

# ########################################### PROJECT GENERATION

printf "Creating project directory as ${GREEN}${project_name}${NOCOLOR}."
mkdir $project_name
cp -a ./template/. ./$project_name/
placeholders_replacer
cd ./$project_name

printf "\n\nInstalling dependencies with ${LIGHTBLUE}yarn${NOCOLOR}."
printf "\nThis might take a couple of minutes.\n\n"
yarn add $dependencies --dev

printf "\nInitiating git repository.\n\n"
git init
git config user.name "$author_name"
git config user.email "$author_email"
git remote add origin "$project_repository"
git add .
git commit -m "feat: initial commit"

# ########################################### INSTRUCTIONS

printf "\n 🚀   Project succesfully created!\n"

printf "\n${LIGHTBLUE}yarn dev${NOCOLOR}"
printf "\n  Start development server\n"

printf "\n${LIGHTBLUE}yarn lint${NOCOLOR}"
printf "\n  Lint source directory\n"

printf "\n${LIGHTBLUE}yarn test${NOCOLOR}"
printf "\n  Run tests\n"

printf "\n${LIGHTBLUE}yarn build${NOCOLOR}"
printf "\n  Build for production\n"

printf "\nYou should try:"
printf "\n  ${LIGHTBLUE}cd ${NOCOLOR} $project_name"
printf "\n  ${LIGHTBLUE}yarn dev${NOCOLOR}\n\n"