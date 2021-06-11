package eu.ohmrun.walker;

enum EventSum<T,K>{
  FromMachine(requisition:Requisition<T,K>);
  FromEnvironment(message:Message<T,K>);
}
abstract Event<T,K>(EventSum<T,K>) from EventSum<T,K> to EventSum<T,K>{
  public function new(self) this = self;
  static public function lift<T,K>(self:EventSum<T,K>):Event<T,K> return new Event(self);

  public function prj():EventSum<T,K> return this;
  private var self(get,never):Event<T,K>;
  private function get_self():Event<T,K> return lift(this);
}