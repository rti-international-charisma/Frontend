# charisma

Charisma Flutter project.

## Building the project
Create an empty file `lib/environment.dart` with contents<br>
`final variables = {};`

## Setting environment variables
The App uses `API_BASEURL` and `ASSETS_URL` through environment variables.
Set these variables as System environment variables.

Once the variables are set execute following 

Run `dart tool/env.dart`

`env.dart` populates `lib/environment.dart` with System Environment variables.

`lib/environment.dart` is added to `./gitignore`

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
