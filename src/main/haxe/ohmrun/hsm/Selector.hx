package ohmrun.hsm;

enum SelectorSum{
  SelectId(id:String);
  SelectPath(path:Array<String>);
}
abstract Selector(SelectorSum) from SelectorSum to SelectorSum{

}