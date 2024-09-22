import 'package:flutter/material.dart';
import 'button_values.dart';
import 'package:decimal/decimal.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = ""; // . 0-9
  String operand = ""; // + - * /
  String input2 = ""; // . 0-9
  String output = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // input2
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$input$operand$input2".isEmpty
                      ?"0"
                      :"$input$operand$input2",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            // buttons
            Wrap(
              children: Btn.buttonValues
                .map(
                    (value) => SizedBox(
                      width: value == Btn.calculate
                        ?screenSize.width/2
                        :(screenSize.width/4),
                      height: screenSize.width/5,
                      child: buildButton(value),
                    )
                  )
                  .toList(),
            )
          ],
        )
      )
    );
  }

  Widget buildButton(value){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black87
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
            value, 
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color:[
                Btn.add,
                Btn.subtract,
                Btn.multiply,
                Btn.divide,
                Btn.calculate,
              ].contains(value)
                  ?Colors.black54
                  :Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Main Function
  void onBtnTap(String value) {
    if (value == Btn.del) {
      deleteValue();
      return;
    }
    if (value == Btn.clr) {
      clearValue();
      return;
    }
    if (value == Btn.per) {
      percentValue();
      return;
    }
    if (value == Btn.calculate) {
      calculateValue();
      return;
    }
    appendValue(value);
  }

  // Clear Value
  void clearValue() {
    setState(() {
      input = "";
      operand = "";
      input2 = "";
    });
  }

  // Delete Value
  void deleteValue() {
    if (input2.isNotEmpty) {
      input2 = input2.substring(0, input2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (input.isNotEmpty) {
      input = input.substring(0, input.length - 1);
    }

    setState(() {});
  }

  // Percent Value
  void percentValue() {
    setState(() {
      if (input.isNotEmpty && operand.isNotEmpty && input2.isNotEmpty) {
        input2 = (double.parse(input) * double.parse(input2) / 100).toStringAsPrecision(1);
      } 
      else if (input.isNotEmpty && operand.isEmpty) {
        input = (double.parse(input) / 100).toStringAsPrecision(1);
      }
    });
  }

  // Calculate value
  void calculateValue() {
    if (input.isEmpty || input2.isEmpty || operand.isEmpty) return;  // Prevent empty input calculations

    Decimal number = Decimal.parse(input);
    Decimal number2 = Decimal.parse(input2);
    Decimal result = Decimal.zero;

    // Perform the operation based on the operand
    if (operand == Btn.add) {
      result = number + number2;
    } 
    else if (operand == Btn.subtract) {
      result = number - number2;
    } 
    else if (operand == Btn.multiply) {
      result = number * number2;
    } 
    else if (operand == Btn.divide) {
      if (number2 != Decimal.zero) {
        // Convert to double for division
        double num1 = double.parse(number.toString());
        double num2 = double.parse(number2.toString());
        double divResult = num1 / num2;

        // Convert the result back to Decimal
        result = Decimal.parse(divResult.toString());
      } 
      else {
        result = Decimal.zero;  // Handle division by zero
      }
    }

    // Convert the result to a string and remove unnecessary trailing zeros
    String finalResult = result.toString();
    finalResult = finalResult.contains('.') ? finalResult.replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '') : finalResult;

    // Update the input with the result and reset operand/input2
    setState(() {
      input = finalResult;  // The result becomes the new input1
      operand = "";         // Reset operand
      input2 = "";          // Reset input2
    });
  }

  // Append Value
  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      // Operand
      if (operand.isEmpty) {
        operand = value;
      }
    } else if (operand.isEmpty) {  // Initiate Input 1
      if (value == Btn.dot && input.contains(Btn.dot)) return;  // Prevent multiple dots
      if (value == Btn.dot && (input.isEmpty || input == Btn.dot)) value = "0.";
      input += value;
    } else {  // Initiate Input 2
      if (value == Btn.dot && input2.contains(Btn.dot)) return;  // Prevent multiple dots
      if (value == Btn.dot && (input2.isEmpty || input2 == Btn.dot)) value = "0.";
      input2 += value;
    }

    setState(() {});
  }

  // Design
  Color getBtnColor(value){
    return [
      Btn.del,
      Btn.clr,
      Btn.per,
      ].contains(value)
        ?const Color.fromARGB(255, 76, 58, 81)
          :[
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.multiply,
            Btn.calculate
          ].contains(value)
            ?const Color.fromARGB(255, 231, 171, 121)
            :const Color.fromARGB(255, 119, 67, 96);
  }
}