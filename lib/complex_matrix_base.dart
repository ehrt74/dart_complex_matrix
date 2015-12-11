part of complex_matrix;

class ComplexMatrix {
  final int _NUMROWS;
  final int _NUMCOLUMNS;

  List<Complex> _vals;


  ComplexMatrix getRow(int i) {
    if (i>=_NUMROWS) throw "$i out of bounds";
    return new ComplexMatrix.fromIterable(1, _NUMCOLUMNS, _vals.skip(_NUMCOLUMNS * i).take(_NUMCOLUMNS));
  }
  ComplexMatrix getColumn(int j) {
    if (j>=_NUMCOLUMNS) throw "$j out of bounds";
    var ret = new List<Complex>(_NUMROWS);
    for (int i=0; i<_NUMROWS; i++) {
      ret[i]=(this.getAt(i, j));
    }
    return new ComplexMatrix.fromIterable(_NUMROWS, 1, ret);
  }

  
  ComplexMatrix getSubMatrix(int not_i, int not_j) {
    _checkBounds(not_i, not_j);
    if (_NUMROWS<2 || _NUMCOLUMNS<2) throw "matrix already too small to build a sub matrix";
    var ret = new List<Complex>();
    for (int i=0; i<_NUMROWS; i++) {
      for (int j=0; j<_NUMROWS; j++) {
        if (i!=not_i && j!=not_j) {
          ret.add(this.getAt(i,j));
        }
      }
    }
    return new ComplexMatrix.fromIterable(_NUMROWS-1, _NUMCOLUMNS-1, ret);
  }

  // zero based. i is row. j is column
  void _checkBounds(int i, int j) {
    if (i>=_NUMROWS || j>=_NUMCOLUMNS) throw "$i, $j out of bounds";
  }

  static ComplexMatrix Identity(int _NUMROWS) {
    var vals = new List<Complex>(_NUMROWS*_NUMROWS);
    for (int i=0; i<_NUMROWS; i++) {
      for(int j=0; j<_NUMROWS; j++) {
        if(i==j) vals[i*_NUMROWS + j]=Complex.ONE;
        else vals[i*_NUMROWS + j]=Complex.ZERO;
      }
    }
    return new ComplexMatrix.fromIterable(_NUMROWS, _NUMROWS, vals);
  }

  ComplexMatrix transpose() {
    var vals = new List<Complex>(_NUMROWS*_NUMCOLUMNS);
    for (int i=0; i<_NUMROWS; i++) {
      for(int j=0; j<_NUMCOLUMNS; j++) {
        vals[j*_NUMCOLUMNS+i] = this.getAt(i,j);
      }
    }
    return new ComplexMatrix.fromIterable(_NUMCOLUMNS, _NUMROWS, vals);
  }

  void _checkSquare() {
    if (_NUMROWS!=_NUMCOLUMNS) throw "matrix not square";
  }

  Complex getDeterminant() {
    _checkSquare();
    if (_NUMROWS==1) {
      return getAt(0,0);
    }
    Complex d = Complex.ZERO;
    Complex fact = Complex.ONE;
    for (int i=0; i<_NUMROWS; i++) {
      d += fact * this.getAt(i,0) * this.getSubMatrix(i,0).getDeterminant();
      fact *= -1;
    }
    return d;
  }
  
  String toString() {
    return "${_vals}";
    
  }

  ComplexMatrix inverse() {
    _checkSquare();
    if (_NUMROWS==1) return new ComplexMatrix.fromIterable(1,1, Complex.ONE/getAt(0,0));
    var adj = this.getAdjugate();
    return adj.scale(this.getDeterminant());
  }

  ComplexMatrix getAdjugate() {
    _checkSquare();
    return this.getCofactor().transpose();
  }
  
  ComplexMatrix getCofactor() {
    _checkSquare();
    var ret = new List<Complex>(_NUMROWS*_NUMCOLUMNS);
    Complex factor = Complex.ONE;
    for (int i=0; i<_NUMROWS; i++) {
      if (i%2==1) { factor = Complex.ONE * -1; }
      for (int j=0; j<_NUMCOLUMNS; j++) {
        ret[i*_NUMROWS+j] = factor * this.getAt(i,j)*this.getSubMatrix(i,j).getDeterminant();
        factor *= -1;
      }
    }
    return new ComplexMatrix.fromIterable(_NUMROWS, _NUMCOLUMNS, ret);
  }

  ComplexMatrix.fromIterable(this._NUMROWS, this._NUMCOLUMNS, Iterable<Complex> cl) {
    _vals = new List<Complex>(_NUMROWS*_NUMCOLUMNS);
    if (cl.length!= this._vals.length) throw "list has wrong length";
    _vals = cl.map((var c)=>c).toList();
  }

    // zero based. i is row, j is column
  Complex getAt(int i, int j) {
    _checkBounds(i, j);
    return _vals[i*_NUMCOLUMNS + j];
  }

  bool operator ==(Object other) {
    if (other is ComplexMatrix) {
      if (this._NUMROWS != other._NUMROWS) return false;
      if (this._NUMCOLUMNS != other._NUMCOLUMNS) return false;
      for (int i=0; i<_vals.length; i++) {
        if (this._vals[i] != other._vals[i]) return false;
      }
      return true;
    }
    return false;
  }

  ComplexMatrix operator *(Object other) {
    if (other is ComplexMatrix) {
      if (this._NUMCOLUMNS != other._NUMROWS) throw "incompatible matrix sizes for multiplication";
      int retROWS = this._NUMROWS;
      int retCOLUMNS = other._NUMCOLUMNS;
      var ret = new List<Complex>(retROWS*retCOLUMNS);
      for (int this_i=0; this_i<this._NUMROWS; this_i++) {
        var this_row = this.getRow(this_i);
        for (int other_j = 0; other_j<other._NUMCOLUMNS; other_j++) {
          var other_column = other.getColumn(other_j);
          Complex res = Complex.ZERO;
          for (int n=0; n<this._NUMCOLUMNS; n++) {
            res += this_row.getAt(0,n) * other_column.getAt(n,0);
          }
          ret[this_i*retROWS + other_j]=res;
        }
      }
      return new ComplexMatrix.fromIterable(retROWS, retCOLUMNS, ret);
    } else {
      throw "other is not complexmatrix";
    }
  }
  
  ComplexMatrix scale(Complex s) {
    return new ComplexMatrix.fromIterable(_NUMROWS, _NUMCOLUMNS, _vals.map((var c)=>c/s));
  }

  void setAt(int i, int j, Complex c) {
    _checkBounds(i, j);
    _vals[i*_NUMROWS + j] = c;
  }


  
}