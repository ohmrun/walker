package eu.ohmrun.walker.html5.data;

class Swap<T,G,K,E> extends coconut.ui.View{
  public function new(){
    this.register.set(
      '$uuid',
      () -> {
        throw eu.ohmrun.walker.html5.data.Node.make(SwapNode(this));
      }
    );
  }
  @:skipCheck @:implicit  var register                        : Register;
  @:ref                   var self                            : Element;
  @:optional @:attribute  var call                            : Into<T,G,K,E>;
  @:attribute             var name                            : String;
  @:attribute             var children                        : coconut.ui.Children;

  @:isVar public var uuid(get,null) : NodeId; 
  public function get_uuid(){
    return uuid == null ? new NodeId(this.name) : this.uuid.copy(name);
  } 
  function render() '<div id="${uuid}" class="swap history_node" ref=${self} >${...children}</div>';

  function viewDidMount(){
    // final parent = 
    //   __.option(self.closest(".rack")).either(
    //     () -> __.option(self.closest(".port")).fudge("no <Port>${...children}</Port> set at root")
    //   );
    final racks = self.querySelectorAll('.rack');
    for(rack in racks){
      trace(Std.downcast(rack,Element).getAttribute("id"));

    }
  }
  public function get_substates(){
    trace('get substates for ${uuid}');
    
    final nodes = self.querySelectorAll('.history_node').toCluster();
    //trace(nodes.map(x -> downcast(x,Element)).map(x ->x.id));
   
    return nodes;
  }
}