class A {

     func bar() {

          print("I'm an instance of A.");

     }

}

 

class B : A {

     override func bar() {

          print("I'm an instance of B.");

     }

}

var a = A()
var b = B()
a = B()
a.bar()
b.bar()