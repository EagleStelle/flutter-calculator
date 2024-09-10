import 'package:flutter/material.dart';

import 'button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = ""; // . 0-9
  String operand = ""; // + - * /
  String input2 = ""; // . 0-9

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
  void onBtnTap(String value){
    if(value==Btn.del){
      deleteValue();
      return;
    }
    if(value==Btn.clr){
      clearValue();
      return;
    }
    if(value==Btn.per){
      percentValue();
      return;
    }
    appendValue(value);
  }

  // Clear Value
  void clearValue(){
    setState(() {
      input = "";
      operand = "";
      input2 = "";
    });

  }
  // Delete Value
  void deleteValue(){
    if(input2.isNotEmpty){
      input2=input2.substring(0, input2.length - 1);
    }
    else if(operand.isNotEmpty){
      operand = "";
    }
    else if(input.isNotEmpty){
      input=input.substring(0, input.length - 1);
    }

    setState(() {});
  }
  // Percent Value
  void percentValue(){
    if(input.isNotEmpty&&operand.isNotEmpty&&input2.isNotEmpty){

    }

    if(operand.isNotEmpty){
      
    }
  }

  // Apend Value
  void appendValue(String value){
    if(value!=Btn.dot&&int.tryParse(value)==null){
      // Operand
      if(operand.isNotEmpty&&input2.isNotEmpty){

      }
      operand = value;
    }
    // Initiate Input 1
    else if(input.isEmpty || operand.isEmpty){
      // When dot and dot pressed, remain "0."
      if(value==Btn.dot && input.contains(Btn.dot)) return;
      // When empty or dot, set "0."
      if(value==Btn.dot && (input.isEmpty || input==Btn.dot)){
        value = "0.";
      }
    input += value;
    }
    // Initate Input 2, will happen if operand
    else if(input2.isEmpty || operand.isNotEmpty){
      // When dot and dot pressed, remain "0."
      if(value==Btn.dot && input2.contains(Btn.dot)) return;
      // When empty or dot, set "0."
      if(value==Btn.dot && (input2.isEmpty || input2==Btn.dot)){
        value = "0.";
      }
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