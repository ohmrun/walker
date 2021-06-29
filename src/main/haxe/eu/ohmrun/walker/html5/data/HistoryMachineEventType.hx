package eu.ohmrun.walker.html5.data;

enum abstract HistoryMachineEventType(String) from String{
  var REGISTER_SWAP;
  public function toString():String{
    return this;
  }
}