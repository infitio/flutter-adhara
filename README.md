# adhara

Base framework for Flutter Apps with intense networking and data interactivity.
Adhara provides a seamless offline experience with much ease.

What adhara brings to the plate?

  1. Easy SQLite management - ORM, using DataInterfaces
  2. Easy network setup with the help of network middlewares
  3. Manage data using Data Beans in a well structured format. No more worries about runtime errors or key changes in JSON.
  4. Event Handlers: Listen to events across the widgets. An event can be triggered in one dart file and can be listened in any of stateful widgets*
  5. Internationalization - Manual i18N based on selected language.
  6. Easy routing: Simplified Regex based URL routing like in a web application
  7. Easy Sentry Logger in production with one DSN configuration
  8. Properties file parser, JSON file reader, running modes and many more...


_*stateful widget is overridden by adhara and is called AdharaStatefulWidget, and has a state named AdharaState_


## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).


Report your issues: [https://github.com/infitio/flutter-adhara/issues](https://github.com/infitio/flutter-adhara/issues)

## Using adhara commands

_IN DEV_

`flutter packages pub global activate --source path ./`

_IN INSTALLED_

`flutter packages pub global activate adhara`

Make sure pub cache is added to `PATH`

`flutter packages pub global run adhara:adhara`
