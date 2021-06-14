package eu.ohmrun.walker;

enum EventSum<T,K>{
  FromMachine(requisition:Requisition<T,K>);
  FromEnvironment(message:Message<T,K>);
}
@:using(eu.ohmrun.walker.Event.EventLift)
abstract Event<T,K>(EventSum<T,K>) from EventSum<T,K> to EventSum<T,K>{
  static public var _(default,never) = EventLift;
  public function new(self) this = self;
  static public function lift<T,K>(self:EventSum<T,K>):Event<T,K> return new Event(self);

  @:from static public function fromRequisition<T,K>(self:Requisition<T,K>){
    return lift(FromMachine(self));
  }
  @:from static public function fromMessage<T,K>(self:Message<T,K>){
    return lift(FromEnvironment(self));
  }
  public function prj():EventSum<T,K> return this;
  private var self(get,never):Event<T,K>;
  private function get_self():Event<T,K> return lift(this);

  public var message(get,never):Option<Message<T,K>>;
  public function get_message(){
    return _.fold(
      this,
      req -> req.message,
      mes -> __.option(mes)
    );
  }
}
class EventLift{
  static public function fold<T,K,Z>(self:EventSum<T,K>,from_machine:Requisition<T,K>->Z,from_environment:Message<T,K>->Z){
    return switch(self){
      case FromMachine(requisition) : from_machine(requisition);
      case FromEnvironment(message) : from_environment(message);
    }
  }
}

