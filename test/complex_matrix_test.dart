// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library complex_matrix.test;

import 'package:complex_matrix/complex_matrix.dart';
import 'package:test/test.dart';
import 'package:complex/complex.dart';

Complex c00 = new Complex(3,0);
Complex c01 = new Complex(-2,0);
Complex c10 = new Complex(-7,0);
Complex c11 = new Complex(5,0);
ComplexMatrix m1 = new ComplexMatrix.fromIterable(2,2,
    [c00, c01, c10, c11]);

Complex d00 = new Complex(3,0);
Complex d01 = new Complex(5,-2);
Complex d10 = new Complex(5,2);
Complex d11 = new Complex(3,0);
ComplexMatrix m2 = new ComplexMatrix.fromIterable(2,2,
    [d00, d01, d10, d11]);

void main() {
  test("equals works", () {
    expect(ComplexMatrix.Identity(2), equals(ComplexMatrix.Identity(2)));
    expect(m2, isNot(equals(m1)));
  });

  test("determinant works", () {
    var d = m1.determinant;
    expect(d, equals(new Complex(1,0)));
  });

  test("cofactor works", () {
    var co = m1.getCofactor();
    expect(co.getAt(0,0), equals(c11));
    expect(co.getAt(0,1), equals(-c10));
    expect(co.getAt(1,0), equals(-c01));
    expect(co.getAt(1,1), equals(c00));
  });

  test("transpose works", () {
    var m1t = m1.getTranspose();
    expect(m1t.getAt(1,0), equals(m1.getAt(0,1)));
  });

  test("getConjugate works", () {
    var m2c = m2.getConjugate();
    expect(m2c, equals(m2.getTranspose()));
  });
  
  test("inverse works", () {
    expect(ComplexMatrix.Identity(2).getInverse(), equals(ComplexMatrix.Identity(2)));
    expect(m2.getInverse()*m2, equals(ComplexMatrix.Identity(2)));
  });

  
  test("getRow works", () {
    var row = m1.getRow(0);
    expect(row.getAt(0,1), equals(m1.getAt(0,1)));
  });

  test("getColumn works", () {
    var col = m1.getColumn(1);
    expect(col.getAt(1,0), equals(m1.getAt(1,1)));
  });

  test("getSubMatrix works", () {
    var sm = m1.getSubMatrix(0,0);
    expect(sm.getAt(0,0), equals(m1.getAt(1,1)));
  });
  
  test("multiplication works", () {
    var m2 = m1*ComplexMatrix.Identity(2);
    expect(m2.getAt(1,1), equals(m1.getAt(1,1)));
  });
}