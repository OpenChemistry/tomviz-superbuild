#!/usr/bin/env python3

from pathlib import Path
import urllib.request
import subprocess
import sys

if len(sys.argv) < 2:
    sys.exit('Usage: <script> <release_tag>')

release_tag = sys.argv[1]

filenames = [
    f'Tomviz-{release_tag}.dmg',
    f'Tomviz-{release_tag}-Linux.tar.gz',
    f'Tomviz-{release_tag}.msi',
    f'tomviz-{release_tag}.tar.gz',
    f'Tomviz-{release_tag}.zip',
]

print('Downloading files...')
for filename in filenames:
    repo_url = 'https://github.com/openchemistry/tomviz-superbuild'
    release_url = f'{repo_url}/releases/download/{release_tag}/{filename}'

    print(f'Downloading "{filename}"...')
    urllib.request.urlretrieve(release_url, filename)

output_file_name = f'Tomviz-{release_tag}-SHAs.txt'

print('Generating shas...')
with open(output_file_name, 'w') as wf:
    sum_methods = {
        'SHA-256': 'sha256sum',
        'SHA-512': 'sha512sum',
    }

    last_label = list(sum_methods)[-1]

    for sum_label, sum_exec in sum_methods.items():
        wf.write(f'{sum_label}\n\n')
        for filename in filenames:
            cmd = [sum_exec, filename]
            output = subprocess.check_output(cmd)
            wf.write(output.decode())

        # Write a newline if it isn't the last one
        if sum_label != last_label:
            wf.write('\n')

print(f'SHAs written out to "{output_file_name}"')

print('Cleaning up...')
for filename in filenames:
    Path(filename).unlink()

print('All done. Now use GPG to create a signature, like so:')
print(f'$ gpg --armor --output Tomviz-{release_tag}-SHAs.txt.asc --detach-sig Tomviz-{release_tag}-SHAs.txt')

print(f'Then, upload both "Tomviz-{release_tag}-SHAs.txt"',
      f'and "Tomviz-{release_tag}-SHAs.txt.asc" to GitHub!')
