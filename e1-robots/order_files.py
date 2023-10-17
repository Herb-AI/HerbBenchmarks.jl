#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os

def enumerate_files(path):
    """Enumerate all files in the specified directory."""
    if not os.path.isdir(path):
        raise ValueError(f"'{path}' is not a directory.")

    return_dict = {}

    # List all files in the directory
    filelist = [f for f in os.listdir(path) if os.path.isfile(os.path.join(path, f))]
    for file in filelist:
        problem_name = file.split("-")[1]
        with open(file=path+file, mode='r') as f:
            for line in f:
                if problem_name in return_dict:
                    return_dict[problem_name].add(line.strip())
                else:
                    return_dict[problem_name] = set()
    return return_dict

def write_files(path, val_dict):
    for problem_name, val in val_dict.items():
        with open(file=path+problem_name+".pl", mode='w') as f:
            for line in val:
                print(line, file=f)

a = enumerate_files("../data/train/")
b = enumerate_files("data/test/")
write_files("../data/String_transformations_2020/data/", a|b)

