import 'package:flutter/material.dart';
import './../../../models/orders_model.dart';

class TrackOrder extends StatefulWidget {
  final Order order;

  const TrackOrder({Key key, this.order}) : super(key: key);
  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: _buildTrack(),
          ),
        ),
        Row(
          children: _buildSttaus(),
        )
      ],
    );
  }

  _buildSttaus() {
    Color color = Colors.deepOrange;
    String status = 'Confirmed';
    List<Widget> list = new List<Widget>();
    list.add(timelineTstua('Ordered'));
    if(widget.order.status == 'cancelled' || widget.order.status == 'on-hold' || widget.order.status == 'failed' || widget.order.status == 'refunded' ||  widget.order.status == 'pending') {
      color = Colors.grey;
      status = widget.order.status;
    }
    list.add(timelineTstua(status.capitalize()));
    list.add(timelineTstua('Processing'));
    if(widget.order.status != 'completed') {
      color = Colors.grey;
    }
    list.add(timelineTstua('Shipped'));
    list.add(timelineTstua('Delivered'));
    return list;
  }

  _buildTrack() {
    Color color = Colors.deepOrange;
    Color dotColor = Colors.deepOrange;
    String status = 'Confirmed';
    List<Widget> list = new List<Widget>();
    list.add(timelineFirstRow('Ordered'));
    if(widget.order.status == 'cancelled' || widget.order.status == 'on-hold' || widget.order.status == 'failed' || widget.order.status == 'refunded' ||  widget.order.status == 'pending') {
      dotColor = _getDotColor(widget.order.status);
      list.add(timelineRow(color, dotColor, widget.order.status));
      color = Colors.grey;
      dotColor = Colors.grey;
    } else {
      list.add(timelineRow(color, dotColor, status));
    }
    list.add(timelineRow(color, dotColor, 'Processing'));
    if(widget.order.status != 'completed') {
      color = Colors.grey;
      dotColor = Colors.grey;
    }
    list.add(timelineRow(color, dotColor, 'Shipped'));
    list.add(timelineRow(color, dotColor, 'Delivered' ));
    return list;
  }

  Widget timelineFirstRow(String status) {
    final width = MediaQuery.of(context).size.width * .20;
    return Column(
      children: [
        Container(
          height: 18,
          width: width * .3,
          decoration: new BoxDecoration(
            color: Colors.deepOrange,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget timelineRow(Color color, Color dotColor, String status) {
    final width = MediaQuery.of(context).size.width * .20;
    return Expanded(
      child: Container(
       // width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 3,
                decoration: new BoxDecoration(
                  color: color,
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            Container(
              height: 18,
              width: width * .3,
              decoration: new BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget timelineTstua(String status) {
   return Expanded(
      child: Text(status, textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
          fontSize: 12
        ),
      ),
    );
  }

  Color _getDotColor(String status) {
    switch (status) {
      case "on-hold":
        return Colors.amber;
        break;
      case "pending":
        return Colors.amber;
        break;
      case "refunded":
        return Colors.amber;
        break;
      case "cancelled":
        return Color(0xffeba3a3);
        break;
      case "failed":
        return Color(0xffeba3a3);
        break;
      default:
        return Colors.grey;
    }
  }


}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
