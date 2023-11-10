import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChange;
  final Function(String)? onSubmit;
  const SearchWidget(
      {Key? key, required this.controller, this.onChange, this.onSubmit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      // onChanged:onChange,
      decoration: const InputDecoration(
        hintText: "Search",
      ),
      onSubmitted: onSubmit,
      onChanged: (value) => onChange?.call(value),
    );
  }
}
