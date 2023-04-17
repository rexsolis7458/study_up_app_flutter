import 'package:flutter/material.dart';

class MultiSelectDropdown extends StatefulWidget {
  final List<String> options;
  final String hintText;
  final Function(List<String>) onSelected;

  MultiSelectDropdown({
    required this.options,
    required this.hintText,
    required this.onSelected,
  });

  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  List<String> _selectedValues = [];
  String? _searchTerm;

  @override
   Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return widget.options
            .where((option) =>
                _searchTerm == null ||
                option.toLowerCase().contains(_searchTerm!.toLowerCase()))
            .map((option) => CheckedPopupMenuItem<String>(
                  value: option,
                  checked: _selectedValues.contains(option),
                  child: Text(option),
                ))
            .toList();
      },
      onSelected: (String selectedOption) {
        setState(() {
          if (_selectedValues.contains(selectedOption)) {
            _selectedValues.remove(selectedOption);
          } else {
            _selectedValues.add(selectedOption);
          }
          widget.onSelected(_selectedValues);
        });
      },
      child: ListTile(
        title: _selectedValues.isEmpty
            ? Text(widget.hintText)
            : Text(_selectedValues.join(', ')),
        trailing: Icon(Icons.arrow_drop_down),
      ),
    );
  }
}