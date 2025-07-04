#!/usr/bin/env python3

import os
import urllib.request
import pprint


def sha256_file(url):
    import hashlib

    sha256 = hashlib.sha256()
    with urllib.request.urlopen(url) as response:
        while chunk := response.read(8192):
            sha256.update(chunk)
    return sha256.hexdigest()


versions = {
    "umu-launcher": {
        "version_placeholder": "UMU_LAUNCHER_VERSION",
        # renovate: datasource=github-tags depName=Open-Wine-Components/umu-launcher
        "version": "1.2.7",
        "url_template": "https://github.com/Open-Wine-Components/umu-launcher/releases/download/{version}/umu-launcher-{version}-zipapp.tar",
    }
}

cwd = os.getcwd()

with open(f"{cwd}/templates/io.github.mactan_sc.RSILauncher.yml", "r") as f:
    data = f.read()
    for key, value in versions.items():
        data = data.replace(f"${{{value['version_placeholder']}}}", value["version"])
        sha256 = sha256_file(value["url_template"].format(version=value["version"]))
        data = data.replace(f"${{{value['version_placeholder'] + '_SHA256'}}}", sha256)
    with open(f"{cwd}/io.github.mactan_sc.RSILauncher.yml", "w") as f:
        f.write(data)
