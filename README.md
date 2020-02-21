<h2 align="center">Example Flutter VPN App</h2>

![Image of VPNLAB1](https://i.gyazo.com/b34e06482c600bbea9b0d0ba2e4a165a.png)
![Image of VPNLAB2](https://i.gyazo.com/6c0e74ffafc0912ad0f3f3791acbaf5a.png)
![Image of VPNLAB3](https://i.gyazo.com/de9a14ad97922f07c54eda7cb11a4a88.png)

## Installation

### For Android

Modify your `app/build.gradle` to use abiFilter because flutter doesn't apply abiFilter for target platform yet.
```gradle
android {
    ...
    buildTypes {
        ...
        release {
            ...
            ndk {
                    if (project.hasProperty('target-platform')) {
                        if (project.property('target-platform') == 'android-arm,android-arm64')
                            abiFilters 'armeabi-v7a', 'arm64-v8a'
                        else if (project.property('target-platform') == 'android-arm')
                            abiFilters 'armeabi-v7a'
                        else if (project.property('target-platform') == 'android-arm64')
                            abiFilters 'arm64-v8a'
                    }
                }
            }
    }
}
```
The plugin will automatically download pre-build native libraries from [here](https://github.com/X-dea/Flutter_VPN/releases) if they haven't been downloaded.

### For iOS

You need to open `Personal VPN` and `Network Extensions` capabilities in Xcode: see Project->Capabilities.

VPN connection errors are handled in swift code, you need to use Xcode to see connection errors if there is any.

## Strongswan Server installation
  - I'm using this tutorial. Ubuntu, Lets Encrpyt. [here](https://github.com/jawj/IKEv2-setup)

## Features 
  - The Android part was implemented by strongswan which support ikev2 protocol.
  - The iOS part was implemented by NEVPNManager.
  - Compatibility latest goole play multi abis apk. app-universal-debug, app-arm64-v8a-debug, app-armeabi-v7a-debug

## VPN Plugin 
  - This project using X-dea/Flutter-VPN [here](https://github.com/X-dea/Flutter_VPN)