import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class OvalGradientTransform extends GradientTransform {
  const OvalGradientTransform(this.scaleX, this.scaleY);

  final double scaleX;
  final double scaleY;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final double centerX = bounds.width / 2;
    final double centerY = bounds.height / 2;

    return Matrix4.identity()
      ..translateByVector3(vm.Vector3(centerX, centerY, 0))
      ..scaleByVector3(vm.Vector3(scaleX, scaleY, 1))
      ..translateByVector3(vm.Vector3(-centerX, -centerY, 0));
  }
}
