import 'package:flutter/material.dart';

class Bday extends StatefulWidget {
  @override
  _BdayState createState() => _BdayState();
}

class _BdayState extends State<Bday> {
  TextEditingController bdayController = TextEditingController();

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2030));
    if (picked != null) ;
    //  setState(
    //    () => { data.registrationdate = picked.toString(),
    //    intialdateval.text = picked.toString()
    //    }
    //  );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectDate(); // Call Function that has showDatePicker()
      },
      child: IgnorePointer(
        child: TextFormField(
          // focusNode: _focusNode,
          keyboardType: TextInputType.phone,
          autocorrect: false,
          controller: bdayController,
          // onSaved: (value) {
          //   data.registrationdate = value;
          // },
          onTap: () {
            _selectDate();
            FocusScope.of(context).requestFocus(new FocusNode());
          },

          maxLines: 1,
          //initialValue: 'Aseem Wangoo',
          validator: (value) {
            if (value!.isEmpty || value.length < 1) {
              return 'Choose Date';
            }
          },
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            //filled: true,
            icon: const Icon(Icons.calendar_today),
            labelStyle: TextStyle(decorationStyle: TextDecorationStyle.solid),
          ),
        ),
      ),
    );
  }
}
