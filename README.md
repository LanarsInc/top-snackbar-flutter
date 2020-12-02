# top-snackbar-flutter
Made in [lanars.com](https://lanars.com).

[![pub package](https://img.shields.io/pub/v/top_snackbar_flutter.svg)](https://pub.dev/packages/top_snackbar_flutter)

If you need to show the user some information in a nice way, you can use this package. The API is as simple
as API for regular Material method `showDialog`. If you need to use your own widget to display, you
can pass it into `showTopSnackBar` function.

<img src="https://raw.githubusercontent.com/LanarsInc/top-snackbar-flutter/main/example/assets/top-snackbar-example.gif" width="300">

# Getting Started

In order to show a CustomSnackBar you need to call a showTopSnackBar function. You can pass there any widget you want
but we have a CustomSnackBar for example.

```dart
showTopSnackBar(
    context,
    CustomSnackBar.success(
      message:
          "Good job, your release is successful. Have a nice day",
    ),
);
```

```dart
showTopSnackBar(
    context,
    CustomSnackBar.info(
      message:
          "There is some information. You need to do something with that",
    ),
);
```

```dart
showTopSnackBar(
    context,
    CustomSnackBar.error(
      message:
          "Something went wrong. Please check your credentials and try again",
    ),
);
```
