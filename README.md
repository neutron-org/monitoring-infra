# Monitoring infra toolset
There are places monitoring configs and configs template compiler.

## Intro
* All configs are in `configs` folder
* If you need some templates to use in configs place them into `templates` folder and use as `{{ template "path_to_file" . }}`
* All files inside `configs` folder ending by `.tmpl` interpreted as golang templates
* All other files are copied from configs as is

## Run
* To start you'll need to create `.env` file, please find `.env.sample` as a reference
* Please have Go installed
* Run `start.sh`
* Find ready to use configs inside `build` directory
