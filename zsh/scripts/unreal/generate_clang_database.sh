#!/bin/bash

if [[ -z "${ENGINE_PATH}" ]]; then
	echo "Please specify UnrealEngine install location by setting the 'ENGINE_PATH' environment variable."
  exit 1
fi

project_dir="${PROJECT_DIR:-$PWD}"
if [[ -z "${PROJECT_DIR}" ]]; then
	echo "PROJECT_DIR environment variable not set, using '$project_dir' as a project directory."
fi

project_name="${PROJECT_NAME:-${PWD##*/}}"
if [[ -z "${PROJECT_NAME}" ]]; then
	echo "PROJECT_NAME environment variable not set, using '$project_name' as a project directory."
fi

platform="$(uname -s)"
case "${platform}" in
  Linux*)    platform="Linux";;
  Darwin*)   platform="Mac";;
  *)         platform="";;
esac

if [[ -z "${platform}" ]]; then
  echo "Unsupported platform"
  exit 1
fi

"$ENGINE_PATH/Engine/Build/BatchFiles/$platform/Build.sh" -mode=GenerateClangDatabase \
-project="$project_dir/$project_name.uproject" \
-game -engine ${project_name}Editor Mac Development

if [ $? -ne 0 ]; then
  exit $?
fi

compile_commands_target="$project_dir/Source/compile_commands.json"
echo "Moving compilation database to: $compile_commands_target"
cp "$ENGINE_PATH/compile_commands.json" "$compile_commands_target"
