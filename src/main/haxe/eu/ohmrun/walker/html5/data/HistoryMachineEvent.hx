package eu.ohmrun.walker.html5.data;

class HistoryMachineEvent extends js.html.Event{
  public function new(type:HistoryMachineEventType,data){
    super(type.toString());
    this.data = data;
  }
  public final data : Dynamic; 
}