package eu.ohmrun.walker.html5.data;

#if js
class Rack<T,G,K,E> extends coconut.ui.View{
  public function new(){
    this.register.set(
      '$uuid',
      () -> {
        throw eu.ohmrun.walker.html5.data.Node.make(RackNode(this));
      }  
    );
  }
  @:skipCheck @:implicit  var register  : Register;
  @:ref                   var self      : Element;
  @:attribute             var name      : String;
  @:attribute             var children  : coconut.ui.Children;
  @:optional @:attribute  var call      : Into<T,G,K,E>;
  
  @:isVar public var uuid(get,null) : NodeId; 
  public function get_uuid(){
    return uuid == null ? new NodeId(this.name) : this.uuid.copy(name);
  } 

  function render() '<div id="${uuid}" class="rack history_node" ref=${self} >${...children}</div>';

  function viewDidMount(){
    final parent = __.option(self.closest(".swap"));
  }
  public function get_substates(){
    trace('get substates for ${uuid}');
    final swaps = self.querySelectorAll('.swap').toCluster();
    trace(swaps.map(x -> Std.downcast(x,Element)).map(x -> x.id));
    return swaps;
  }
} 
#end