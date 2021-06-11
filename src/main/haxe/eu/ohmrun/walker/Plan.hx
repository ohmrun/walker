package eu.ohmrun.walker;


class PlanCls<T,G,K>{
  public final global         : G;
  public final requisitions   : Array<Requisition<T,K>>;
  public function new(global,requisitions){
    this.global       = global;
    this.requisitions = requisitions;
  }
}
@:forward abstract Plan<T,G,K>(PlanCls<T,G,K>) from PlanCls<T,G,K> to PlanCls<T,G,K>{
  public function new(self) this = self;
  static public function lift<T,G,K>(self:PlanCls<T,G,K>):Plan<T,G,K> return new Plan(self);

  static public function pure<T,G,K>(global:G):Plan<T,G,K>{
    return fromG(global);
  }
  static public function make<T,G,K>(global:G,requisitions:Array<Requisition<T,K>>){
    return lift(new PlanCls(global,requisitions));
  }
  @:from static public function fromG<T,G,K>(self:G){
    return lift(new PlanCls(self,[]));
  }
  public function prj():PlanCls<T,G,K> return this;
  private var self(get,never):Plan<T,G,K>;
  private function get_self():Plan<T,G,K> return lift(this);
}