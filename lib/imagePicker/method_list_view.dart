// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:stasht/imagePicker/picker_method.dart';

class MethodListView extends StatefulWidget {
  const MethodListView({
    super.key,
    required this.pickMethods,
    required this.onSelectMethod,
  });

  final List<PickMethod> pickMethods;
  final void Function(PickMethod method) onSelectMethod;

  @override
  State<MethodListView> createState() => _MethodListViewState();
}

class _MethodListViewState extends State<MethodListView> {
  final ScrollController _controller = ScrollController();

  Widget methodItemBuilder(BuildContext context, int index) {
    final PickMethod model = widget.pickMethods[index];
    return InkWell(
      onTap: () => widget.onSelectMethod(model),
      onLongPress: model.onLongPress,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ).copyWith(bottom: 10.0),
      child: Scrollbar(
        controller: _controller,
        thumbVisibility: true,
        radius: const Radius.circular(999),
        child: ListView.builder(
          controller: _controller,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          itemCount: widget.pickMethods.length,
          itemBuilder: methodItemBuilder,
        ),
      ),
    );
  }
}
