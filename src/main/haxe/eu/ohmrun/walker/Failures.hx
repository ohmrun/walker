package eu.ohmrun.walker;

class Failures extends Clazz{
  static public function fail(wildcard:Wildcard){
    return new Failures();
  }
  public function not_found(path:Cluster<String>,selector:Selector){
    return E_Walker_CannotFindName(path,selector);
  }
  public function no_trigger_for(name:String){
    return E_Walker_NoTriggerFor(name);  
  }
}