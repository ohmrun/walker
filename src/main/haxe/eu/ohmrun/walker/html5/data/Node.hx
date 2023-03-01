package eu.ohmrun.walker.html5.data;

enum NodeSum<T,G,K,E>{
  RackNode(rack:Rack<T,G,K,E>);
  SwapNode(swap:Swap<T,G,K,E>);
}
class NodeCls<T,G,K,E>{
  public final delegate : NodeSum<T,G,K,E>;
  public function new(delegate){
    this.delegate = delegate;
  }
}
@:using(eu.ohmrun.walker.html5.data.Node.NodeLift)
@:forward abstract Node<T,G,K,E>(NodeCls<T,G,K,E>) from NodeCls<T,G,K,E> to NodeCls<T,G,K,E>{
  public function new(self) this = self;
  static public var _(default,never) = NodeLift;

  static public function lift<T,G,K,E>(self:NodeCls<T,G,K,E>):Node<T,G,K,E> return new Node(self);
  @:noUsing static public function make<T,G,K,E>(self:NodeSum<T,G,K,E>):Node<T,G,K,E> return lift(new NodeCls(self));

  public function prj():NodeCls<T,G,K,E> return this;
  private var self(get,never):Node<T,G,K,E>;
  private function get_self():Node<T,G,K,E> return lift(this);

  @:from static public function fromRackNode<T,G,K,E>(self:Rack<T,G,K,E>){
    return lift(new NodeCls(RackNode(self)));
  }
  @:from static public function fromSwapNode<T,G,K,E>(self:Swap<T,G,K,E>){
    return lift(new NodeCls(SwapNode(self)));
  }
  public function get_substates(){
    return _.fold(
      this,
      (x) -> x.get_substates(),
      (x) -> x.get_substates()
    );
  }
  public var el(get,never):Element;
  private function get_el():Element{
    return _.fold(
      this,
      (x) -> @:privateAccess x.self,
      (x) -> @:privateAccess x.self 
    );
  }
  public var call(get,never):Call<T,G,K,E>;
  private function get_call():Call<T,G,K,E>{
    return _.fold(
      this,
      (x) -> @:privateAccess x.call.prj(),
      (x) -> @:privateAccess x.call.prj() 
    );
  }
  public function getNodeSpec():eu.ohmrun.walker.Node<T,G,K,E>{
    var bit = (type) -> {
      return new eu.ohmrun.walker.Node.NodeCls(NodeId.decode(el.id).fudge().toId(),type,call);
    }
    return _.fold(
      this,
      x -> bit(All),
      x -> bit(One)
    );
  }
}
class NodeLift{
  static public function fold<T,G,K,E,Z>(self:NodeCls<T,G,K,E>,rack:Rack<T,G,K,E>->Z,swap:Swap<T,G,K,E>->Z):Z{
    return switch(self.delegate){
      case RackNode(x) : rack(x);
      case SwapNode(x) : swap(x); 
    }
  }
  static public function comparable<T,G,K,E>():Comparable<Node<T,G,K,E>>{
    return Comparable.Anon(Eq.Anon(eq),Ord.Anon(lt));
  }
  static public function lt<T,G,K,E>(l:Node<T,G,K,E>,r:Node<T,G,K,E>){
    return switch([l.delegate,r.delegate]){
      case [RackNode(_),SwapNode(_)]  : LessThan;
      case [RackNode(l),RackNode(r)]  : Ord.String().comply('${l.uuid}','${r.uuid}');
      case [SwapNode(_),RackNode(_)]  : NotLessThan;
      case [SwapNode(l),SwapNode(r)]  : Ord.String().comply('${l.uuid}','${r.uuid}'); 
    }
  }
  static public function eq<T,G,K,E>(l:Node<T,G,K,E>,r:Node<T,G,K,E>){
    return switch([l.delegate,r.delegate]){
      case [RackNode(_),SwapNode(_)]  : NotEqual;
      case [RackNode(l),RackNode(r)]  : Eq.String().comply('${l.uuid}','${r.uuid}');
      case [SwapNode(_),RackNode(_)]  : NotEqual;
      case [SwapNode(l),SwapNode(r)]  : Eq.String().comply('${l.uuid}','${r.uuid}'); 
    }
  }
}