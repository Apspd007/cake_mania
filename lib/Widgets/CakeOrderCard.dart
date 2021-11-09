import 'package:cake_mania/Materials.dart';
import 'package:cake_mania/Models/CakeOrderModel.dart';
import 'package:cake_mania/Notifiers/CakeOrderNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CakeOrderCard extends StatefulWidget {
  final int index;
  final CakeOrderModel cakeOrderModel;
  CakeOrderCard({
    required this.index,
    required this.cakeOrderModel,
  });

  @override
  _CakeOrderCardState createState() => _CakeOrderCardState();
}

class _CakeOrderCardState extends State<CakeOrderCard> {
  List<DropdownMenuItem<String>> _flavorList = [
    DropdownMenuItem(
      child: Text('Mango'),
      onTap: () {},
      value: 'Mango',
    ),
    DropdownMenuItem(
      child: Text('Strawberry'),
      onTap: () {},
      value: 'Strawberry',
    ),
  ];
  List<DropdownMenuItem<String>> _weightList = [
    DropdownMenuItem(
      child: Text('1 KG'),
      onTap: () {},
      value: '1 KG',
    ),
    DropdownMenuItem(
      child: Text('2 KG'),
      onTap: () {},
      value: '2 KG',
    ),
    DropdownMenuItem(
      child: Text('5 KG'),
      onTap: () {},
      value: '5 KG',
    ),
    DropdownMenuItem(
      child: Text('10 KG'),
      onTap: () {},
      value: '10 KG',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final _cakeOrderNotifier = context.read<CakeOrderNotifier>();
    return Container(
      decoration: BoxDecoration(
          color: Colors.yellow.shade200,
          // color: MyColorScheme.corn,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: Offset.zero,
              color: Colors.black26,
              blurRadius: 2.5,
            ),
          ]),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.fromLTRB(5, 15, 10, 15),
      width: double.infinity,
      child: Row(children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Image.network(
              widget.cakeOrderModel.imageUrl,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.cakeOrderModel.name,
                    style: lobster2TextStyle(
                      color: Color(0xFF3D3D3D),
                      fontWeight: FontWeight.w500,
                    )),
                Text('\u{20B9}${widget.cakeOrderModel.price}',
                    style: lobster2TextStyle(
                      color: Color(0xFF3D3D3D),
                      fontWeight: FontWeight.w500,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: widget.cakeOrderModel.flavor,
                      hint: Text('Flavor',
                          style: lobster2TextStyle(
                              color: Color(0xFF3D3D3D), fontSize: 15)),
                      style: lobster2TextStyle(
                        fontSize: 16,
                      ),
                      dropdownColor: Colors.white,
                      iconEnabledColor: Color(0xFF3D3D3D),
                      underline: DecoratedBox(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black87,
                              width: 0.5,
                            ),
                          ),
                        ),
                      ),
                      items: _flavorList,
                      onChanged: (String? flavor) {
                        setState(() {
                          _cakeOrderNotifier.changeFlavorAt(
                              widget.index, flavor!);
                        });
                      },
                    ),
                    DropdownButton<String>(
                      value: widget.cakeOrderModel.weight,
                      hint: Text('Weight',
                          style: lobster2TextStyle(
                              color: Color(0xFF3D3D3D), fontSize: 15)),
                      style: lobster2TextStyle(fontSize: 16),
                      dropdownColor: Colors.white,
                      iconEnabledColor: Color(0xFF3D3D3D),
                      underline: DecoratedBox(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black87,
                              width: 0.5,
                            ),
                          ),
                        ),
                      ),
                      items: _weightList,
                      onChanged: (String? weight) {
                        setState(() {
                          _cakeOrderNotifier.changeWeightAt(
                              widget.index, weight!);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
