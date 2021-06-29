package eu.ohmrun;

class WalkerLift{
  static public function log(wildcard:Wildcard):Log{
    return new stx.Log().tag("eu.ohmrun.walker");
  }
  static public function id(wildcard:Wildcard,name:String,?uuid:String):Id{
    return Id.make(name,__.option(uuid));
  }
  static public function root<T,G,K,E>():Node<T,G,K,E>{
    return new NodeCls(Id.make("root"),One,Call.debug("root"));
  }
  static public function one<T,G,K,E>(id:Id,?call:Call<T,G,K,E>,?rest:ChildrenSpec<T,G,K,E>):NodeSpec<T,G,K,E>{
    return {
      id    : id,
      type  : One,
      call  : __.option(call).defv(Call.debug(id)),
      rest  : __.option(rest).defv(Cluster.unit())
    };
  }
  static public function all<T,G,K,E>(id:Id,?call:Call<T,G,K,E>,?rest:ChildrenSpec<T,G,K,E>):NodeSpec<T,G,K,E>{
    return {
      id    : id,
      type  : All,
      call  : __.option(call).defv(Call.debug(id)),
      rest  : __.option(rest).defv(Cluster.unit())
    }
  }
}
/**
  T the message payload
  G global state
  K Message
  E Error type
**/
class Walker<T,G,K,E>{
  static public function one<T,G,K,E>(id:Id,?call:Call<T,G,K,E>,?rest:ChildrenSpec<T,G,K,E>):NodeSpec<T,G,K,E>{
    return _.one(id,call,rest);
  }
  static public function all<T,G,K,E>(id:Id,?call:Call<T,G,K,E>,?rest:ChildrenSpec<T,G,K,E>):NodeSpec<T,G,K,E>{
    return _.all(id,call,rest);
  }
  static public var _(default,never) = WalkerLift;
  private var state       : G;
  private final history   : Cluster<TransitionData<T,G,K,E>>;
  private final triggers  : Map<K,Selector>;
  private final machine   : Machine<T,G,K,E>;
  private final buffer    : Buffer<T,K>;
  private var tick        : TimeStamp;
  private final hive      : Hive<T,K>;
  
  public function new(state,history,triggers,machine,buffer,?tick,?hive){
    this.state      = state;
    this.history    = history;
    this.triggers   = triggers;
    this.machine    = machine;
    this.buffer     = buffer;
    this.tick       = __.option(tick).def(LogicalClock.get);
    this.hive       = __.option(hive).def( () -> new Hive());
  }
  public function copy(state,history,triggers,machine,buffer,tick,hive){
    return new Walker(
      __.option(state).defv(this.state),
      __.option(history).defv(this.history),
      __.option(triggers).defv(this.triggers),
      __.option(machine).defv(this.machine),
      __.option(buffer).defv(this.buffer),
      __.option(tick).defv(this.tick),
      __.option(hive).defv(this.hive)
    );
  }
  public function raise(event:Event<T,K>):Walking<T,G,K,E>{
    return Walking.lift(__.hold(stx.coroutine.core.Held.Guard(
      Future.irreversible(
        (cb) -> {
          
          // final events = this.triggers.toIter().search(
          //   kv -> 
          // );
          // $type(events);
        }
      )
    )));
  }
  public function reply(){

  }
}
typedef WalkerFailure<E>              = eu.ohmrun.walker.WalkerFailure<E>;
typedef Spec                          = eu.ohmrun.walker.Spec;
typedef NodeSpec<T,G,K,E>             = eu.ohmrun.walker.Spec.NodeSpec<T,G,K,E>;
typedef ChildrenSpec<T,G,K,E>         = eu.ohmrun.walker.Spec.ChildrenSpec<T,G,K,E>;

typedef IdDef                         = eu.ohmrun.walker.Id.IdDef;
typedef Id                            = eu.ohmrun.walker.Id;

typedef NodeCls<T,G,K,E>              = eu.ohmrun.walker.Node.NodeCls<T,G,K,E>;
typedef Node<T,G,K,E>                 = eu.ohmrun.walker.Node<T,G,K,E>;

typedef TransitionData<T,G,K,E>       = eu.ohmrun.walker.TransitionData<T,G,K,E>;

typedef PhaseSum                      = eu.ohmrun.walker.Phase.PhaseSum;
typedef Phase                         = eu.ohmrun.walker.Phase;

typedef Machine<T,G,K,E>              = eu.ohmrun.walker.Machine<T,G,K,E>;

typedef CallDef<T,G,K,E>              = eu.ohmrun.walker.Call.CallDef<T,G,K,E>;
typedef Call<T,G,K,E>                 = eu.ohmrun.walker.Call<T,G,K,E>;

typedef Selector                      = eu.ohmrun.walker.Selector;
typedef Transition<T,G,K,E>           = eu.ohmrun.walker.Transition<T,G,K,E>;

typedef Plan<T,G,K>                   = eu.ohmrun.walker.Plan<T,G,K>;
typedef PlanCls<T,G,K>                = eu.ohmrun.walker.Plan.PlanCls<T,G,K>;

typedef Hook                          = eu.ohmrun.walker.Hook;
typedef EventSum<T,K>                 = eu.ohmrun.walker.Event.EventSum<T,K>;
typedef Event<T,K>                    = eu.ohmrun.walker.Event<T,K>;
typedef Stamp<T>                      = eu.ohmrun.walker.Stamp<T>;
typedef StampDef<T>                   = eu.ohmrun.walker.Stamp.StampDef<T>;
typedef Hive<T,K>                     = eu.ohmrun.walker.Hive<T,K>;
typedef Spur<K>                       = eu.ohmrun.walker.Spur<K>;
typedef SpurSum<K>                    = eu.ohmrun.walker.Spur.SpurSum<K>;
typedef Request<T,K>                  = eu.ohmrun.walker.Request<T,K>;
typedef RequestSum<T,K>               = eu.ohmrun.walker.Request.RequestSum<T,K>;
typedef Requisition<T,K>              = eu.ohmrun.walker.Requisition<T,K>;
typedef RequisitionDef<T,K>           = eu.ohmrun.walker.Requisition.RequisitionDef<T,K>;
typedef Context<T,G,K>                = eu.ohmrun.walker.Context<T,G,K>;
typedef Message<T,K>                  = eu.ohmrun.walker.Message<T,K>;
typedef Walking<T,G,K,E>              = eu.ohmrun.walker.Walking<T,G,K,E>;
typedef Calls<K>                      = eu.ohmrun.walker.Calls<K>;
typedef CallsDef<K>                   = eu.ohmrun.walker.Calls.CallsDef<K>;
typedef Buffer<T,K>                   = eu.ohmrun.walker.Buffer<T,K>;
typedef Failures                      = eu.ohmrun.walker.Failures;
typedef Selectable                    = eu.ohmrun.walker.Selectable;

abstract ClusterOfNode<T,G,K,E>(Cluster<Node<T,G,K,E>>) from Cluster<Node<T,G,K,E>> to Cluster<Node<T,G,K,E>>{}
class StateDeclaration{

}



class NodeDeclarationResolution{
  public function new(){}  
}
