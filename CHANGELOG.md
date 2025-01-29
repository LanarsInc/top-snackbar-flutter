## 3.2.0 - 29.01.2025
* Provide `onTap` callback for `DismissType.none` and `DismissType.onSwipe` dismissTypes, thanks to [DarienRomero](https://github.com/DarienRomero)

## 3.1.0 - 30.06.2023
* Enhancement: Add `snackBarPosition` parameter by [fox-avokadik](https://github.com/fox-avokadik)
* Correct errors in the example
* Update README.md

## 3.0.0+1 - 27.12.2022
* Update README.md

## 3.0.0 - 15.11.2022
* **Breaking change**. Remove BuildContext in favor of OverlayState
* **Breaking change**. Add multi direction swipe for DismissType.onSwipe by [mofadillah](https://github.com/mofadillah) 'dismissDirection' change type from DismissDirection to List<DismissDirection>
* Enhancement: Add TextAlign parameter to CustomSnackBar widget by [ayoubrajabi](https://github.com/ayoubrajabi)
* Bugfix [#35](https://github.com/LanarsInc/top-snackbar-flutter/issues/35) Snackbar stuck on status bar

## 2.1.1 - 07.07.2022
* Fix dismissible widget dismissed error

## 2.1.0 - 04.07.2022
* Enhancement: Add `safeAreaValues` parameter by [LeGoffMael](https://github.com/LeGoffMael)
* Enhancement: Make `top_snackbar_flutter` dismissible by swipe with parameters `dismissType` and `dismissDirection` by [LeGoffMael](https://github.com/LeGoffMael)

## 2.0.0 - 21.06.2022
* **Breaking change**. Padding parameters replaced with a single EdgeInsets `padding` parameter.
* **Breaking change**. `showOutAnimationDuration` renamed to `animationDuration`, `hideOutAnimationDuration` renamed to `reverseAnimationDuration`.
* Enhancement [#24](https://github.com/vizhan-lanars/top-snackbar-flutter/issues/24). Add `curve` and `reverseCurve` parameters.

## 1.1.1 - 18.05.2022
* Fix persistent snackbar behaviour

## 1.1.0 - 18.05.2022
* Enhancement [#17](https://github.com/LanarsInc/top-snackbar-flutter/issues/17)
  (Persistent snackbar)
* Enhancement: Add maxLine parameter to CustomSnackBar by [anisalibegic](https://github.com/anisalibegic)

## 1.0.3 - 13.05.2022
* Bugfix

## 1.0.2 - 11.11.2021
* Enhancement: Extend layout customisation by [JekaNS](https://github.com/JekaNS) & [benyaminbeyzaie](https://github.com/benyaminbeyzaie)

## 1.0.1 - 21.09.2021
* Dismiss previous snackbar before displaying new one (snackbars don't overlay 
  each other now).
* Enhancement [#1](https://github.com/LanarsInc/top-snackbar-flutter/issues/1)
* Enhancement [#6](https://github.com/LanarsInc/top-snackbar-flutter/issues/6)

## 1.0.0 - 11.03.2021

* Clean up code

## 0.0.4 - 10.03.2021

* Migrate to null safety
* Provide `onTap` callback for `showTopSnackBar` function

## 0.0.3 - 5.12.2020

* Add additional param in order to specify overlayState at `showTopSnackBar` 
  function

## 0.0.2 - 2.12.2020

* Provide some documentation
* Change pubspec.yaml
* Update Readme.md

## 0.0.1 - 30.11.2020

* Initial Open Source release.