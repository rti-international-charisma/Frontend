# Charisma Flutter Web Frontend Home @github


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

##  Related projects

This project has counterpart projects:

- [Charisma-API: APIS's this application will integrate with](https://github.com/rti-international-charisma/charisma-api)
- [Charisma-CMS: Default content for this project](https://github.com/rti-international-charisma/charisma-directus)

## License information

This project is licensed under the [Apache 2.0 open-source license](https://www.apache.org/licenses/LICENSE-2.0)

*This mobile website was developed by RTI International, Wits Reproductive Health and Research Institute, and FHI360 with technical support from Equal Experts and Fluidity Software. It was funded through Digital Square, a PATH-led initiative funded and designed by the United States Agency for International Development, the Bill & Melinda Gates Foundation, and a consortium of other donors. It was made possible by the generous support of the American people through the United States Agency for International Development (USAID). The contents are the responsibility of PATH and do not necessarily reflect the views of USAID or the United States Government.*
