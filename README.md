# complex_matrix

A library for Dart developers. It is awesome.

## Usage

A simple usage example:

    import 'package:complex_matrix/complex_matrix.dart';

    main() {
      var m1 = new new ComplexMatrix.fromIterable(2,2,
    [new Complex(2,0), new Complex(-1,0), new Complex(-3,0), new Complex(4,0)]);
      print(ComplexMatrix.Identity(3) == ComplexMatrix.Identity(3).inverse());
      print(m1.getCofactor());
    }

## Features and bugs

0.0.2 fixed bug in cofactor function

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
