#!/usr/bin/env python3

# My Ansible Roles Checker
# Written by Marco D'Aleo

import os
import yaml
import argparse


parser = argparse.ArgumentParser()

parser.add_argument(
    "-s",
    "--source",
    type=str,
    dest="source",
    help="Ansible root folder. e.g. '~/somedir/ansible'",
)

args = parser.parse_args()


roles_ls = [
    f
    for f in os.listdir(f"{args.source}/roles/")
    if not f.startswith(".")
]


playbooks = [
    f
    for f in os.listdir(f"{args.source}/playbooks/")
    if not f.startswith(".")
]


# How many roles do we have?
print(f"\n >>> Checking {len(roles_ls)} roles... \n")

roles_used_list = []
roles_doubles_list = []

for d in roles_ls:
    for p in playbooks:
        with open(
            f"{args.source}/playbooks/{p}"
        ) as f:
            full_file = yaml.safe_load(f)
            for item in full_file:
                for i in item:
                    # Find the role
                    if i == "roles":
                        roles = item[i]
                        for r in roles:
                            # Checking...
                            if r == d:
                                if r not in roles_used_list:
                                    roles_used_list.append(r)
                                else:
                                    if r not in roles_doubles_list:
                                        roles_doubles_list.append(r)
                                print(f"Found role '{r}' in playbook '{p}'")

# Comparing...
roles_unused_list = [r for r in roles_ls if r not in roles_used_list]
if roles_used_list == roles_ls:
    print(" All roles are used in at least one playbook!")

if roles_unused_list:
    print(f" {roles_unused_list} not used by any playbook")

if roles_doubles_list:
    print(f" {roles_doubles_list} referenced in multiple playbooks!")

