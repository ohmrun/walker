package eu.ohmrun.walker;

enum RequestSum<T,K>{
  Issue(msg:Message<T,K>);
  Defer(msg:Message<T,K>);
  Relay(future:Future<Message<T,K>>);
} 
@:using(eu.ohmrun.walker.Request.RequestLift)
abstract Request<T,K>(RequestSum<T,K>) from RequestSum<T,K> to RequestSum<T,K>{
  static public var _(default,never) = RequestLift;

  public function new(self) this = self;  
  static public function lift<T,K>(self:RequestSum<T,K>):Request<T,K> return new Request(self);

  @:from static public function fromMessage<T,K>(self:Message<T,K>){
    return lift(Issue(self));
  }
  @:from static public function fromFuture<T,K>(self:Future<Message<T,K>>){
    return lift(Relay(self));
  }

  public function prj():RequestSum<T,K> return this;
  private var self(get,never):Request<T,K>;
  private function get_self():Request<T,K> return lift(this);

  public var message(get,never):Option<Message<T,K>>;
  public function get_message(){
    return _.fold(
      this,
      x   -> __.option(x),
      x   -> __.option(x),
      ft  -> __.nano().Future().squeeze(ft) 
    );
  }
}
class RequestLift{
  static public function fold<T,K,Z>(self:RequestSum<T,K>,issue:Message<T,K>->Z,defer:Message<T,K>->Z,relay:Future<Message<T,K>>->Z):Z{
    return switch(self){
      case Issue(msg) : issue(msg);
      case Defer(msg) : defer(msg);
      case Relay(ft)  : relay(ft);
    }
  }
}