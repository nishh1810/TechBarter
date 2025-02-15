import 'package:flutter/material.dart';

class QuantityStepper extends StatefulWidget {
  final int quantity;
  final int maxQuantity;
  final Function(int) onQuantityChanged;

  const QuantityStepper({super.key, required this.quantity, required this.maxQuantity, required this.onQuantityChanged});

  @override
  State<QuantityStepper> createState() => _QuantityStepperState();
}

class _QuantityStepperState extends State<QuantityStepper> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
          ),
          child: Center(
            child: IconButton(
                onPressed: () {
                  if(widget.quantity > 1) {
                    widget.onQuantityChanged(widget.quantity - 1);
                  }
                },
                icon: Icon(Icons.remove, color: Colors.black, size: 20))
          ),
        ),
        Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.zero,
          ),
          child: Center(child: Text(widget.quantity.toString(), style: TextStyle(color: Colors.black, fontSize: 20))),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
          ),
          child: Center(
              child: IconButton(
                  onPressed: () {
                    if(widget.quantity < widget.maxQuantity) {
                      widget.onQuantityChanged(widget.quantity + 1);
                    }
                  },
                  icon: Icon(Icons.add, color: Colors.black, size: 20))
          ),
        ),
      ],
    );
  }
}
