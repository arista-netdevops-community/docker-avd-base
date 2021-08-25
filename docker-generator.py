#!/usr/bin/python
# coding: utf-8 -*-
#
# Copyright 2021 Arista Networks - Thomas Grimonet
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http: //www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

from __future__ import (absolute_import, division,
                        print_function, unicode_literals)
import os
import sys
import yaml
import jinja2


class DockerTemplate():

    def __init__(self, config_file, docker_template_path):
        with open(config_file) as file:
            self.config = yaml.load(file, Loader=yaml.FullLoader)

        # Load template file
        templateLoader = jinja2.FileSystemLoader(searchpath="./")
        templateEnv = jinja2.Environment(loader=templateLoader)
        self.template = templateEnv.get_template(docker_template_path)

    def get_versions(self):
        versions = list()
        if 'versions' in self.config:
            for v in self.config['versions']:
                versions.append(v)
        return versions

    def build_folders(self):
        for version in self.get_versions():
            print("  - version: {}".format(version))
            self.create_output_folder(foldername=str(version))

    def create_output_folder(self, foldername):
        if not os.path.exists("./" + foldername):
            os.makedirs("./" + foldername)

    def render(self, docker_file='Dockerfile'):
        for version in self.get_versions():
            self.__render_j2(destination_folder=str(version), version=version)

    def __render_j2(self, destination_folder, version, filename='Dockerfile'):
        dockerfile = self.template.render(version=version)
        # to save the results
        with open("./"+destination_folder + "/" + filename, "w") as fh:
            fh.write(dockerfile)


if __name__ == '__main__':
    print("Init")
    avd_base = DockerTemplate(config_file='config.yml', docker_template_path='_template/Dockerfile.j2')
    avd_base.build_folders()
    avd_base.render()
    print("Done")
    sys.exit(0)
