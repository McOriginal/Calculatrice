import 'package:calculatrice/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
// *****************
  String number1 = "";
  String operand = "";
  String number2 = "";
// *****************

  @override
  Widget build(BuildContext context) {
    // **************
    final screenSize = MediaQuery.of(context).size;
    // **************
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomRight,
                child: Text(
                  "$number1$operand$number2".isEmpty
                      ? "0"
                      : "$number1$operand$number2",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          //*********** Les Bouttons */
          Wrap(
            children: Btn.buttonValues
                .map(
                  (value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                      height: screenSize.width / 5,
                      child: buildButton(value)),
                )
                .toList(),
          )
        ],
      )),
    );
  }

  // **************
  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnValue(value),
        clipBehavior: Clip.hardEdge,
        shape: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white24,
          ),
        ),
        // borderRadius: BorderRadius.circular(100),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ***************onBtnTap ***********
  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

// #################
    if (value == Btn.clr) {
      clearAll();
      return;
    }

    // ##################
    if (value == Btn.per) {
      convertToPercent();
      return;
    }

    // ##########################
    if (value == Btn.calculate) {
      calculate();
      return;
    }

// ##############
    appendValue(value);
  }
// ##################################################################

// **************** calculate
  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }
    setState(() {
      number1 = "$result";

      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }

// **************** calculate

// ******************* convertToPercent
  void convertToPercent() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      // calculate before conversion
      calculate();
    }
    if (operand.isNotEmpty) {
      // cannot be converted
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

// ******************* convertToPercent

// ************** clearAll
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }
// ************** clearAll

// ********* delete *********
  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }
// ********* delete *********

// #################
// appends value to the end
  void appendValue(String value) {
    // if is operand and not "."
    if (value != Btn.dot && int.tryParse(value) == null) {
      // operand pressed
      if (operand.isNotEmpty && number2.isNotEmpty) {
        //d Todo calculate the equation before assigning new operand
        calculate();
      }
      operand = value;
    }

    // assign value to number1 variable

    else if (number1.isEmpty || operand.isEmpty) {
      // check if value is "." | ex: nember1 = "1.2"
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      // check if value is "." | ex: nember1 = "1.2"
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && number2.isEmpty || number2 == Btn.n0) {
        value = "0.";
      }
      number2 += value;
    }
    setState(() {});
  }
  // ***************onBtnTap ***********

  // ***********
  Color getBtnValue(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }
}
