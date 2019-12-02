import 'ar.dart';
import 'r.dart';


class _BaseUtils{ }

class AdharaAppUtils extends _BaseUtils{

  AppResources ar;
  initialize(AppResources ar){
    this.ar = ar;
  }

}

class AdharaModuleUtils extends _BaseUtils{

  Resources r;
  initialize(Resources r){
    this.r = r;
  }

}