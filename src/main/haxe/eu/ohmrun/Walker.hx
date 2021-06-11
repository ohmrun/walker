package eu.ohmrun;

class WalkerLift{
  static public function log(wildcard:Wildcard):Log{
    return new stx.Log().tag("eu.ohmrun.walker");
  }
  static public function id(wildcard:Wildcard,name:String,?uuid:String):Id{
    return Id.make(name,__.option(uuid));
  }
  static public function root<T,G,K>():Node<T,G,K>{
    return new NodeCls(Id.make("root"),One,Call.debug("root"));
  }
  static public function one<T,G,K>(id:Id,?call:Call<T,G,K>,?rest:ChildrenSpec<T,G,K>):NodeSpec<T,G,K>{
    return {
      id    : id,
      type  : One,
      call  : __.option(call).defv(Call.debug(id)),
      rest  : __.option(rest).defv([])
    };
  }
  static public function all<T,G,K>(id:Id,?call:Call<T,G,K>,?rest:ChildrenSpec<T,G,K>):NodeSpec<T,G,K>{
    return {
      id    : id,
      type  : All,
      call  : __.option(call).defv(Call.debug(id)),
      rest  : __.option(rest).defv([])
    }
  }
}
/**
  T the message payload
  G global state
  K Message
  E Error type
**/
abstract class Walker<T,G,K,E>{
  static public function one<T,G,K>(id:Id,?call:Call<T,G,K>,?rest:ChildrenSpec<T,G,K>):NodeSpec<T,G,K>{
    return _.one(id,call,rest);
  }
  static public function all<T,G,K>(id:Id,?call:Call<T,G,K>,?rest:ChildrenSpec<T,G,K>):NodeSpec<T,G,K>{
    return _.all(id,call,rest);
  }
  static public var _(default,never) = WalkerLift;
  private var state       : G;
  private var tick        : TimeStamp;

  private final history   : Array<TransitionData<T,G,K>>;
  private final triggers  : Map<K,Selector>;
  private final machine   : Machine<T,G,K>;
  private final hive      : Hive<T,K>;

  public function new(state,history,triggers,machine){
    this.state      = state;
    this.tick       = LogicalClock.get();
    this.history    = history;
    this.triggers   = triggers;
    this.machine    = machine;
    this.hive       = new Hive();
  }
  public function enact(){
    var init         = machine.activator();
    var events       = [];
    var canceller    = Hook.signal.handle(
      (stamp) -> {
        events.push(stamp);
      }
    );
    function enter(){

    }
    init.reply().environment(
      Context.make(Message.unit(),this.state,Enter,null,null),
      (plan:Plan<T,G,K>) -> {
        this.state  = plan.global;
        for(requisition in plan.requisitions){
          raise(requisition);
        }
        enter();
      },
      __.crack  
    ).submit();
  }
  public function raise(event:Event<T,K>){
    hive.raise(event);
  }
}
typedef WalkerFailure                 = eu.ohmrun.walker.WalkerFailure;
typedef Spec                          = eu.ohmrun.walker.Spec;
typedef NodeSpec<T,G,K>               = eu.ohmrun.walker.Spec.NodeSpec<T,G,K>;
typedef ChildrenSpec<T,G,K>           = eu.ohmrun.walker.Spec.ChildrenSpec<T,G,K>;

typedef IdDef                         = eu.ohmrun.walker.Id.IdDef;
typedef Id                            = eu.ohmrun.walker.Id;

typedef NodeCls<T,G,K>                = eu.ohmrun.walker.Node.NodeCls<T,G,K>;
typedef Node<T,G,K>                   = eu.ohmrun.walker.Node<T,G,K>;

typedef TransitionData<T,G,K>         = eu.ohmrun.walker.TransitionData<T,G,K>;

typedef PhaseSum                      = eu.ohmrun.walker.Phase.PhaseSum;
typedef Phase                         = eu.ohmrun.walker.Phase;

typedef Machine<T,G,K>                = eu.ohmrun.walker.Machine<T,G,K>;

typedef CallDef<T,G,K>                = eu.ohmrun.walker.Call.CallDef<T,G,K>;
typedef Call<T,G,K>                   = eu.ohmrun.walker.Call<T,G,K>;

typedef Selector                      = eu.ohmrun.walker.Selector;
typedef Transition<T,G,K>             = eu.ohmrun.walker.Transition<T,G,K>;

typedef Plan<T,G,K>                   = eu.ohmrun.walker.Plan<T,G,K>;
typedef PlanCls<T,G,K>                = eu.ohmrun.walker.Plan.PlanCls<T,G,K>;

typedef Hook                          = eu.ohmrun.walker.Hook;
typedef Event<T,K>                    = eu.ohmrun.walker.Event<T,K>;
typedef Stamp                         = eu.ohmrun.walker.Stamp;
typedef StampDef                      = eu.ohmrun.walker.Stamp.StampDef;
typedef Hive<T,K>                     = eu.ohmrun.walker.Hive<T,K>;
typedef Spur<K>                       = eu.ohmrun.walker.Spur<K>;
typedef SpurSum<K>                    = eu.ohmrun.walker.Spur.SpurSum<K>;
typedef Requisition<T,K>              = eu.ohmrun.walker.Requisition<T,K>;
typedef RequisitionDef<T,K>           = eu.ohmrun.walker.Requisition.RequisitionDef<T,K>;
typedef Context<T,G,K>                = eu.ohmrun.walker.Context<T,G,K>;
typedef Message<T,K>                  = eu.ohmrun.walker.Message<T,K>;

enum Selectable{
  One;
  All;
}
abstract ArrayOfNode<T,G,K>(Array<Node<T,G,K>>) from Array<Node<T,G,K>> to Array<Node<T,G,K>>{}
class StateDeclaration{

}
typedef CallsDef = stx.ds.RedBlackMap<String,Selector>;

@:forward abstract Calls(CallsDef) from CallsDef to CallsDef{
  static public function unit(){
    return new Calls();
  }
  public function new(){
    this = RedBlackMap.make(
      Comparable.String()
    );
  }
}


class NodeDeclarationResolution{
  public function new(){}  
}