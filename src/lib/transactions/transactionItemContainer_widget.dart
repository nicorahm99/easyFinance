import 'package:ef/persistence.dart';
import 'package:ef/transactions/transactionItem_widget.dart';
import 'package:flutter/material.dart';

class TransactionItemContainer extends StatelessWidget{
  final List<TransactionDTO> transactions;
  TransactionItemContainer(this.transactions);
  
  List<Widget> _buildTransactionItems(){
    List<Widget> items = List<Widget>();
    transactions.forEach((element) {items.add(TransactionItem(element)); items.add(Divider(color: Colors.green, thickness: 2,indent: 5,endIndent: 5));});
    items.removeLast();
    items.add(SizedBox(height: 8,));
    return items;
  }

  List<Widget> _buildWidgetList(Widget widget, List<Widget> widgets){
    List<Widget> newWidgets = [widget];
    newWidgets.addAll(widgets);
    return newWidgets;
  }

  Widget _buildDateBox() {
    return  SizedBox(
      width: 80,height: 20,
      child: DecoratedBox(
        child: Center( child:Text(transactions[0].getGermanDateTimeString(),
        style: TextStyle(color: Colors.black87, fontSize: 15),textAlign: TextAlign.center,)),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 1),
          color: Colors.green,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context){
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2,),
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: 
      Column(
        children: _buildWidgetList(_buildDateBox(), _buildTransactionItems()),
      ),
    );
  } 
}