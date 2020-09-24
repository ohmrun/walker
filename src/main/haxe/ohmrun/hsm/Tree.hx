package ohmrun.hsm;

abstract Tree<T>(KaryTree<Node<T>>) from KaryTree<Node<T>> to KaryTree<Node<T>>{
  public function new(self) this = self;
}