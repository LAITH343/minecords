import 'package:flutter/material.dart';
import 'package:minecords/screens/add/methods.dart';
import 'package:minecords/screens/src/custom_text_filed.dart';
import 'package:minecords/screens/src/widgets.dart';

class AddBody extends StatefulWidget {
  const AddBody({super.key});

  @override
  State<AddBody> createState() => _AddBodyState();
}

class _AddBodyState extends State<AddBody> {
  TextEditingController name = TextEditingController();
  TextEditingController worldName = TextEditingController();
  TextEditingController keywords = TextEditingController();
  TextEditingController x = TextEditingController();
  TextEditingController y = TextEditingController();
  TextEditingController z = TextEditingController();
  List<DropdownMenuItem<String>> dimensionDropDown = const [
    DropdownMenuItem(
      value: "Overworld",
      child: Text("Overworld"),
    ),
    DropdownMenuItem(
      value: "Nether",
      child: Text("Nether"),
    ),
    DropdownMenuItem(
      value: "End",
      child: Text("End"),
    ),
  ];
  String _selectedDimension = "Overworld";
  Widget _save = const Text("Save");

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: inputFileds(context),
      ),
    );
  }

  Column inputFileds(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CustomTextFiled(
            helpText: "Enter name",
            controller: name,
            keyboardType: TextInputType.text,
            maxLength: 25,
          ),
        ),
        CustomTextFiled(
            helpText: "Enter world name",
            controller: worldName,
            keyboardType: TextInputType.text,
            maxLength: 25),
        CustomTextFiled(
            helpText: "Keywords",
            controller: keywords,
            keyboardType: TextInputType.text,
            maxLength: 100),
        CustomTextFiled(
            helpText: "Enter x",
            controller: x,
            keyboardType: TextInputType.number,
            maxLength: 1000000),
        CustomTextFiled(
            helpText: "Enter y",
            controller: y,
            keyboardType: TextInputType.number,
            maxLength: 1000000),
        CustomTextFiled(
            helpText: "Enter z",
            controller: z,
            keyboardType: TextInputType.number,
            maxLength: 1000000),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(flex: 3, child: Text("Dimension")),
            Flexible(
              flex: 1,
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                items: dimensionDropDown,
                value: _selectedDimension,
                borderRadius: BorderRadius.circular(20),
                onChanged: (value) {
                  setState(() {
                    _selectedDimension = value ?? "Overworld";
                  });
                },
              )),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
            ),
            onPressed: () async {
              setState(() {
                _save = loadingWidget;
              });
              try {
                bool result = await onSavePressed(
                  context,
                  name,
                  worldName,
                  keywords,
                  _selectedDimension,
                  x,
                  y,
                  z,
                );
              } catch (e) {
                showMessage(context, "failed to add cords");
              }
              setState(() {
                _save = const Text("Save");
              });
            },
            child: SizedBox(width: 40, height: 30, child: Center(child: _save)),
          ),
        )
      ],
    );
  }
}
