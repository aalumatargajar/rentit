import 'package:flutter/material.dart';
import 'package:rentit/src/common/const/global_variable.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String? hintTxt;
  final Function(String)? onChanged;
  final FocusNode? focusNode;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.hintTxt,
    this.onChanged,
    this.focusNode,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {}); // Update UI when text changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 51,
      child: SearchBar(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        focusNode: widget.focusNode,
        controller: widget.controller,
        elevation: const WidgetStatePropertyAll(0),
        hintText: widget.hintTxt ?? "Search here",
        hintStyle: WidgetStatePropertyAll(
          txtTheme(context).bodyMedium!.copyWith(color: Colors.black38),
        ),
        keyboardType: TextInputType.text,
        onChanged: widget.onChanged,
        trailing: [
          if (widget.controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                widget.controller.clear();
                if (widget.onChanged != null) widget.onChanged!('');
                widget.focusNode?.unfocus();
              },
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Icon(Icons.cancel_outlined, color: Colors.black54),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: Icon(Icons.search),
            ),
        ],
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        side: WidgetStatePropertyAll(
          BorderSide(
            width: 1,
            color: colorScheme(context).onSurface.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }
}
