Intro
=====

Notarization on macOS requires several steps, and can be somewhat tedious to
work through. The benefit, however, is that it guarantees a high level of
security for the software.

See [here](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution) for more information.

Steps
=====

1. Create an Apple ID if you don't already have one
2. Get added to an authorized provider
3. Create an app-specific password for your application from your Apple ID
  a) Sign in at https://appleid.apple.com/
  b) Scroll down to Security and generate an app-specific password
4. Sign into the computer that is set up for notarization. Set the environment
variables `MY_APPLE_ID` and `MY_APPLE_PASSWORD` (the app-specific password).
You will likely want to remove `MY_APPLE_PASSWORD` from your `~/.bash_history`
afterward.
5. Run `bash sign.bash.tomviz` with an argument of the `.dmg` file to sign.
This will sign the contents of the bundle, create a zip file, and upload it to
Apple servers for Apple's blessing. In 15-20 minutes, you will receive an
email indicating success/failure of the notarization process. If it fails,
see the `Troubleshooting` section below.
6. On success, type `done`, and the next phase of notarization begins. This
"staples" the notarization results onto the `.dmg` file.

If all of the above succeeds, you will now have a notarized `.dmg` file.
You can test it by opening it and double-clicking the application icon.
It should open without prompting or complaining about missing signatures.

Troubleshooting
===============

Chances are, your notarization will fail the first few times. You'll need
to use a command-line tool to get specifics to help debug why, but usually
it's because you didn't sign a .dylib or other executables in the packaging
executable needs to be signed.

From the command line (the script will print the UUID once notarization has been requested):

```bash
xcrun altool --notarization-info <uuid> -u <username>
```

You may need to modify the entitlements.xml file generated by the script
to allow the binaries to do certain things. Tomviz requires two. It can
be hard to figure out which entitlements you need, but if your application
fails with weird bugs involving Apples Guardian, you might need to add an
entitlement.
