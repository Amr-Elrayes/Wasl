import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future pushTo(BuildContext context, String route, {Object? extra}) {
  return context.push(route, extra: extra);
}

pushReplacment(BuildContext context, String route, {Object? extra}) {
  context.pushReplacement(route, extra: extra);
}

pushAndRemoveUntil(BuildContext context, String route, {Object? extra}) {
  context.go(route, extra: extra);
}

pop(BuildContext context) {
  context.pop();
}
