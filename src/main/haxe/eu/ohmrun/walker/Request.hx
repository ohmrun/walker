package eu.ohmrun.walker;

enum RequestDef<T,K>{
  Issue(msg:Message<T,K>);
  Defer(msg:Message<T,K>);
  Relay(future:Future<Message<T,K>>);
} 
abstract Request<T,K>(RequestDef<T,K>) from RequestDef<T,K> to RequestDef<T,K>{
  public function new(self) this = self;  
  static public function lift<T,K>(self:RequestDef<T,K>):Request<T,K> return new Request(self);

  @:from static public function fromMessage<T,K>(self:Message<T,K>){
    return lift(Issue(self));
  }
  public function prj():RequestDef<T,K> return this;
  private var self(get,never):Request<T,K>;
  private function get_self():Request<T,K> return lift(this);
}