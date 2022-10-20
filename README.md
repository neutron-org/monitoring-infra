# Monitoring infra toolset
This is a place for monitoring configs and configs template compiler.

## Intro
* All configs are in `configs` folder
* If you need some templates to use in configs place them into `templates` folder and use as `{{ template "path_to_file" . }}`
* All files inside `configs` folder ending by `.tmpl` interpreted as golang templates
* All other files are copied from configs as is

## Create configs
* To start you'll need to create `.env` file, please find `.env.sample` as a reference
* Please have Go installed
* Run `start.sh`
* Find ready to use configs inside `build` directory

## Installation
### Nodes
* copy `install-node-*.sh` and to the node
* run `install-node-exporter.sh` on the node
* run `install-node-rsyslog.sh` on the node
* allow all incoming connections from `monitoring server` to the current node

### Monitoring server
* copy `./build` folder to `/opt/monitoring` (monitoring server)
* allow all incoming connections from `neutron nodes` to the `monitoring server`
* execute `docker-compose up` in `/opt/monitoring`
* Open grafana going to your domain 
* Import `dashboard-*.json` into dashboards
