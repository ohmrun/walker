package eu.ohmrun.walker;


class PlanCls<T,G,K>{
  public final global         : G;
  public final buffer         : Buffer<T,K>;
  public function new(global,buffer){
    this.global       = global;
    this.buffer       = buffer;
  }
}
@:forward abstract Plan<T,G,K>(PlanCls<T,G,K>) from PlanCls<T,G,K> to PlanCls<T,G,K>{
  public function new(self) this = self;
  static public function lift<T,G,K>(self:PlanCls<T,G,K>):Plan<T,G,K> return new Plan(self);

  static public function pure<T,G,K>(global:G):Plan<T,G,K>{
    return fromG(global);
  }
  static public function make<T,G,K>(global:G,buffer:Buffer<T,K>){
    return lift(new PlanCls(global,buffer));
  }
  @:from static public function fromG<T,G,K>(self:G){
    return lift(new PlanCls(self,Cluster.unit()));
  }
  public function prj():PlanCls<T,G,K> return this;
  private var self(get,never):Plan<T,G,K>;
  private function get_self():Plan<T,G,K> return lift(this);
}