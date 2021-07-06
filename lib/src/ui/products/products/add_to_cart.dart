import 'package:cached_network_image/cached_network_image.dart';

import '../../../models/app_state_model.dart';
import '../../../models/product_model.dart';
import 'package:flutter/material.dart';


import '../product_grid/products_widgets/grouped_products.dart';
import '../product_grid/products_widgets/variations_products.dart';

class AddToCart extends StatefulWidget {

  AddToCart({
    Key key,
    this.variation,
    @required this.product,
    @required this.model,
  }) : super(key: key);

  final Product product;
  final AppStateModel model;
  final AvailableVariation variation;

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    if(getQty() != 0 || isLoading)
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            buttonPadding: EdgeInsets.all(0), // this will take space as minimum as posible(to center)
            children: <Widget>[
              SizedBox(
                height: 30,
                width: 30,
                child: new RaisedButton(
                  elevation: 0,
                  color: Theme.of(context).buttonColor.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.all(Radius.circular(15)),
                  ),
                  child: new Icon(Icons.remove, size: 18),
                  onPressed: () {
                    if(widget.product.type == 'grouped') {
                      _bottomSheet(context);
                    } else decreaseQty();
                  },
                ),
              ),
              SizedBox(
                height: 30,
                width: 30,
                child: new FlatButton(
                  //elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(0.0),
                  ),
                  child: isLoading ? SizedBox(
                    child: CircularProgressIndicator(strokeWidth: 2),
                    height: 16.0,
                    width: 16.0,
                  ) :  SizedBox(
                    width: 20.0,
                    child: Text(
                      getQty().toString(), textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 16
                      ),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                height: 30,
                width: 30,
                child: new RaisedButton(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.all(Radius.circular(15)),
                  ),
                  child: new Icon(Icons.add, size: 18),
                  onPressed: () {
                    if(widget.product.type == 'grouped') {
                      _bottomSheet(context);
                    } else increaseQty();
                  },
                ),
              ),
            ],
          ),
        ],
      );
    else return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ButtonBar(
          buttonPadding: EdgeInsets.all(0),
          children: [
            SizedBox(
              height: 30,
              width: 60,
              child: RaisedButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: Directionality.of(context) == TextDirection.ltr ? BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)) : BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                ),
                child: Text(widget.model.blocks.localeText.add.toUpperCase()),
                onPressed: widget.product.stockStatus == 'outofstock' ? null : () {
                  if(widget.product.type == 'grouped') {
                    _bottomSheet(context);
                  } else {
                    addToCart(context);
                  }
                },
              ),
            ),
            SizedBox(
              height: 30,
              width: 30,
              child: new RaisedButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: Directionality.of(context) == TextDirection.ltr ? BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)) : BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                ),
                child: Card(
                  color: widget.product.stockStatus != 'outofstock' ? Theme.of(context).buttonTheme.colorScheme.primaryVariant : Colors.transparent,
                    elevation: 0,
                    shape: StadiumBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: new Icon(Icons.add, size: 18),
                    )
                ),
                onPressed: widget.product.stockStatus == 'outofstock' ? null : () {
                  if(widget.product.type == 'grouped') {
                    _bottomSheet(context);
                  } else {
                    addToCart(context);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  addToCart(BuildContext context) async {
    var data = new Map<String, dynamic>();
    if(widget.variation != null)
    data['variation_id'] = widget.variation.variationId.toString();
    data['product_id'] = widget.product.id.toString();
    data['quantity'] = '1';
    setState(() {
      isLoading = true;
    });
    await widget.model.addToCart(data, context);
    setState(() {
      isLoading = false;
    });
  }

  decreaseQty() async {
    var cartContent;
    if (widget.model.shoppingCart?.cartContents != null) {
      if(widget.variation != null && widget.model.shoppingCart.cartContents
          .any((cartContent) => cartContent.productId == widget.product.id && cartContent.variationId == widget.variation.variationId)) {
         cartContent = widget.model.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.productId == widget.product.id && cartContent.variationId == widget.variation.variationId);
      } else if (widget.model.shoppingCart.cartContents
          .any((cartContent) => cartContent.productId == widget.product.id)) {
        cartContent = widget.model.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.productId == widget.product.id);
      }
      if(cartContent != null) {
        setState(() {
          isLoading = true;
        });
        await widget.model.decreaseQty(cartContent.key, cartContent.quantity);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  increaseQty() async {
    var cartContent;
    if (widget.model.shoppingCart?.cartContents != null) {
      if(widget.variation != null && widget.model.shoppingCart.cartContents
          .any((cartContent) => cartContent.productId == widget.product.id && cartContent.variationId == widget.variation.variationId)) {
        cartContent = widget.model.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.productId == widget.product.id  && cartContent.variationId == widget.variation.variationId);
      } else if (widget.model.shoppingCart.cartContents
          .any((cartContent) => cartContent.productId == widget.product.id)) {
        cartContent = widget.model.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.productId == widget.product.id);
      }
      if(cartContent != null) {
        setState(() {
          isLoading = true;
        });
        bool status = await widget.model.increaseQty(cartContent.key, cartContent.quantity);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  getQty() {
    var count = 0;
    if(widget.model.shoppingCart.cartContents.any((element) => element.productId == widget.product.id)) {
      if(widget.variation != null) {
        widget.model.shoppingCart.cartContents.where((cartContents) => cartContents.productId == widget.product.id && cartContents.variationId == widget.variation.variationId).toList().forEach((e) => {
          count = count + e.quantity
        });
        return count;
      } else return widget.model.shoppingCart.cartContents.firstWhere((element) => element.productId == widget.product.id).quantity;
    } else return count;
  }

  void _bottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          //color: Colors.amber,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        child: Text(widget.product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                if (widget.product.type == 'variable') Expanded(
                  child: ListView.builder
                    (
                      itemCount: widget.product.availableVariations.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        return VariationProduct(id: widget.product.id, variation: widget.product.availableVariations[Index]);
                      }
                  ),
                ) else widget.product.children.length > 0 ? Expanded(
                  child: ListView.builder
                    (
                      itemCount: widget.product.children.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        return GroupedProduct(id: widget.product.id, product: widget.product.children[Index]);
                      }
                  ),
                ) : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}
