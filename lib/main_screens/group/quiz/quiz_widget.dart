import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;
  OptionTile(
      {required this.option,
      required this.description,
      required this.correctAnswer,
      required this.optionSelected});

  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        children: [
          Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: widget.description == widget.optionSelected
                          ? widget.optionSelected == widget.correctAnswer
                              ? Colors.green.withOpacity(0.7)
                              : Colors.red.withOpacity(0.7)
                          : Colors.grey,
                      width: 1.4),
                  borderRadius: BorderRadius.circular(30)),
              alignment: Alignment.center,
              child: Text(
                '${widget.option}',
                style: TextStyle(
                    color: widget.description == widget.optionSelected
                        ? widget.optionSelected == widget.correctAnswer
                            ? Colors.green.withOpacity(0.7)
                            : Colors.red
                        : Colors.grey),
              )),
          const SizedBox(width: 8),
          Text(
            widget.description,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
