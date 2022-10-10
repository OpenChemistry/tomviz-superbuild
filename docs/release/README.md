Update Tomviz Version in CMake
==============================

In the OpenChemistry/tomviz repository, update the hard-coded version
numbers in the root `CMakeLists.txt` file labeled `tomviz_version_major`,
`tomviz_version_minor`, and `tomviz_version_patch`. These are used by
the source tarball to correctly identify the version.

Create the Git Tag
==================

In the OpenChemistry/tomviz repository, create a signed git tag for the
release/release candidate, and then push it. For instance:

```bash
git tag -s 2.0.0-rc1 -m "Tag 2.0.0 release candidate 1"
git push --tags origin
```

Never delete a tag once pushed. If a mistake is made, make a new tag.


Build the Binaries
==================

In the OpenChemistry/tomviz-superbuild repository, trigger a manual "build"
workflow in order to generate the release binaries. To do so, follow these
steps:

1. Go to the [build workflow](https://github.com/OpenChemistry/tomviz-superbuild/actions/workflows/build.yml) on the tomviz-superbuild GitHub page.
2. On the right side of the web page at the top of the table, there should be
a `Run workflow` button. Click this, selecting the master branch, and then
type in the Tomviz tag that should be used for the release. Start the workflow.
3. Once the workflow finishes, a new tag and release should have automatically
been created in the OpenChemistry/tomviz-superbuild repository that matches the
Tomviz tag that was used for the build. The attached assets should be as follows:

* Tomviz-<tag>.dmg (macOS DMG binary)
* Tomviz-<tag>.msi (Windows installer binary)
* tomviz-<tag>.tar.gz (the release source)
* Tomviz-<tag>.zip (Windows zip binary)
* Tomviz-<tag>-Linux.tar.gz (the Linux binary)

Do some testing on each of these to verify that they work properly


Windows Signing
===============

You will need to use [Microsoft's code signing](https://learn.microsoft.com/en-us/windows-hardware/drivers/install/authenticode) with the `.msi` file
in order for it to be opened without warnings.


macOS Notarization
==================

See the [notarization directory](notarization/readme.md).

After notarization, double-check again that the binary works properly
(sometimes, notarization can cause issues with the binary itself).


Create the SHAs
===============

After the Windows and Mac binaries have been signed/notarized, replace their
respective unsigned/unnotarized binaries located in the
OpenChemistry/tomviz-superbuild release with the signed/notarized versions.

A [helper script](generate_sha_sums.py) located in this directory can then
be used to create the SHAs file, like so:

```
./generate_sha_sums.py <tag>
```

This will automatically download all of the release files and create the
SHAs file from them. It will also print a command to make a GPG signature.
Upload the SHAs file along with the GPG signature to the release directory.


Final Steps
===========

With this, the binaries and source are done. We can now proceed to create
release notes, create a copy of the `OpenChemistry/tomviz-superbuild` release
on the `OpenChemistry/tomviz` repository (by uploading the same assets), and
then editing the links on the tomviz website to point to the new release.
