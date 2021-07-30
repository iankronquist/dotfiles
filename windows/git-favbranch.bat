@echo off

if "%sdxroot%"=="" (
	echo Must be run from within razzle
	exit 1
)

pushd %sdxroot%
call favbranch /b:%1%
git fetch
popd

