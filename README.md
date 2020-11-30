# top-snackbar-flutter
Made in [lanars.com](https://lanars.com).

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
