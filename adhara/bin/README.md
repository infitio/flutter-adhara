# Activate adhara environment

### Activate from local
```bash
flutter pub global activate --source path ~/path/to/adhara
```

### Activate without a local copy (installed by packages get or will be downloaded from pub.dev)
```bash
flutter pub global activate adhara
```

#### setup app
```bash
flutter pub global run adhara setup_app
```

#### Create a module
```bash
flutter pub global run adhara create_module --name=<module-name>
```
