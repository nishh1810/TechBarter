import 'package:flutter/material.dart';
import 'package:tech_barter/components/custom_header.dart';

class CustomScaffold extends StatefulWidget {
  final int curIndex;
  final Widget body;
  const CustomScaffold({super.key, required this.body, required this.curIndex});

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();

}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
            if (constraints.maxWidth > 850) {
            return displayDesktop();
          }else {
            return displayTabletAndMobile();
          }
        }
      ),
    );
  }

  Widget displayDesktop() {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomHeader(curIndex: widget.curIndex),
              Expanded(
                  child: SingleChildScrollView(
                    child: widget.body,
                  )
              )
            ],
          ),
        )
    );
  }

  Widget displayTabletAndMobile() {
    return SafeArea(
      child: Center(
        child: Text("No view available for Mobile & Tablet"),
      ),
    );
  }
}
